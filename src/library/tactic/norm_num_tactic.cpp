/*
Copyright (c) 2015 Microsoft Corporation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

Author: Rob Lewis
*/
#include "library/util.h"
#include "library/norm_num.h"
#include "library/tactic/expr_to_tactic.h"

namespace lean {
tactic norm_num_tactic() {
    return tactic01([=](environment const & env, io_state const &, proof_state const & s) {
            goals const & gs = s.get_goals();
            if (empty(gs)) {
                throw_no_goal_if_enabled(s);
                return none_proof_state();
            }
            goal const & g = head(gs);
            expr const & c = g.get_type();
            expr lhs, rhs;
            if (!is_eq(c, lhs, rhs)) {
                throw_tactic_exception_if_enabled(s, "norm_num tactic failed, conclusion is not an equality");
                return none_proof_state();
            }
            buffer<expr> hyps;
            g.get_hyps(hyps);
            local_context ctx(to_list(hyps));
            try {
                pair<expr, expr> p = mk_norm_num(env, ctx, lhs);
                expr new_lhs = p.first;
                expr new_pr  = p.second;
                if (new_lhs != rhs) {
                    throw_tactic_exception_if_enabled(s, "norm_num tactic failed, lhs normal form doesn't match rhs");
                    return none_proof_state();
                }
                substitution new_subst = s.get_subst();
                assign(new_subst, g, new_pr);
                return some_proof_state(proof_state(s, tail(gs), new_subst));
            } catch (exception & ex) {
                throw_tactic_exception_if_enabled(s, ex.what());
                return none_proof_state();
            }
        });
}

void initialize_norm_num_tactic() {
    register_tac(name{"tactic", "norm_num"},
                 [](type_checker &, elaborate_fn const &, expr const &, pos_info_provider const *) {
                     return norm_num_tactic();
                 });
}
void finalize_norm_num_tactic() {
}
}