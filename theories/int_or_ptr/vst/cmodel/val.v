From Coq Require Import ZArith.ZArith.

From compcert Require Import common.Values.
From compcert Require Import lib.Integers.

Local Open Scope Z.

Definition int_or_ptr__is_valid_int (x: val): Prop :=
  if Archi.ptr64
  then
    match x with
    | Vlong i => Int64.testbit i 0 = true
    | _ => False
    end
  else
    match x with
    | Vint i => Int.testbit i 0 = true
    | _ => False
    end.

Definition int_or_ptr__is_valid_ptr (x: val): Prop :=
  match x with
  | Vptr _ z => Ptrofs.testbit z 0 = false /\ Ptrofs.testbit z 1 = false
  | _ => False
  end.

Definition int_or_ptr__is_valid (x: val): Prop :=
  int_or_ptr__is_valid_int x \/ int_or_ptr__is_valid_ptr x.

Definition int_or_ptr__is_int (x: val): bool
 := if Archi.ptr64
    then
      match x with
      | Vlong _ => true
      | _ => false
      end
    else
      match x with
      | Vint _ => true
      | _ => false
      end.
