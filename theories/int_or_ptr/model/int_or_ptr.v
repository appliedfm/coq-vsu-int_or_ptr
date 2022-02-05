From Coq Require Import ZArith.ZArith.

Definition int_or_ptr (X: Type): Type := option (Z + X).
