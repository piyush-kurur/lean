import logic

variable matrix.{l} : Type.{l} → Type.{l}
variable same_dim {A : Type} : matrix A → matrix A → Prop
variable add {A : Type} (m1 m2 : matrix A) {H : same_dim m1 m2} : matrix A

theorem same_dim_irrel {A : Type} {m1 m2 : matrix A} {H1 H2 : same_dim m1 m2} : @add A m1 m2 H1 = @add A m1 m2 H2 :=
rfl

theorem same_dim_eq_args {A : Type} {m1 m2 m1' m2' : matrix A} (H1 : m1 = m1') (H2 : m2 = m2') (H : same_dim m1 m2) : same_dim m1' m2' :=
subst H1 (subst H2 H)

theorem add_congr {A : Type} (m1 m2 m1' m2' : matrix A) (H1 : m1 = m1') (H2 : m2 = m2') (H : same_dim m1 m2) : @add A m1 m2 H = @add A m1' m2' (same_dim_eq_args H1 H2 H) :=
have base : ∀ (H1 : m1 = m1) (H2 : m2 = m2), @add A m1 m2 H = @add A m1 m2 (eq_rec (eq_rec H H1) H2), from
  assume H1 H2, rfl,
have general : ∀ (H1 : m1 = m1') (H2 : m2 = m2'), @add A m1 m2 H = @add A m1' m2' (eq_rec (eq_rec H H1) H2), from
  subst H1 (subst H2 base),
calc @add A m1 m2 H = @add A m1' m2' (eq_rec (eq_rec H H1) H2)  : general H1 H2
            ...     = @add A m1' m2' (same_dim_eq_args H1 H2 H) : same_dim_irrel
