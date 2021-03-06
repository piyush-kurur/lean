section
  check (1:nat) + 2
  check add
end

section
  variable a : nat
  check a + a
  check add a a
  check a + 1
end

section
  open - [class] nat
  variable a : nat
  check a + a
  check add a a
  check a + 1
  definition foo1 : inhabited nat :=
  _ -- Error inhabited instances was not loaded
end

section
  open - [class] [decl] nat
  variable a : nat
  check a + a
  check a + 1
  definition foo2 : inhabited nat :=
  _ -- Error inhabited instances was not loaded
end

section
  open [class] nat
  definition foo3 : inhabited nat :=
  _

  variable a : nat
  check a + a
end
