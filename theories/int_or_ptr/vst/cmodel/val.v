From Coq Require Import micromega.Lia.
From Coq Require Import ZArith.ZArith.

From compcert Require Import common.Values.
From compcert Require Import lib.Integers.

From VST Require Import floyd.proofauto.

From appliedfm Require Import int_or_ptr.model.int_or_ptr.

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

(* 
Definition int_or_ptr__to_val (x: int_or_ptr {p: val | isptr p}): val
 := match x with
    | None => Vundef
    | Some (inl z) => if Archi.ptr64 then Vlong (Int64.repr z) else Vint (Int.repr z)
    | Some (inr p) => proj1_sig p
    end.
 *)

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

Lemma int_or_ptr__is_int__true (x: val):
  (int_or_ptr__is_valid x /\ int_or_ptr__is_int x = true)
  <-> int_or_ptr__is_valid_int x.
Proof.
  split.
  - intros [Hx E].
    destruct Hx as [Hx|Hx] ; now destruct x.
  - intro H.
    unfold int_or_ptr__is_valid.
    destruct x ; intuition easy.
Qed.

Lemma int_or_ptr__is_int__false (x: val):
  (int_or_ptr__is_valid x /\ int_or_ptr__is_int x = false)
  <-> int_or_ptr__is_valid_ptr x.
Proof.
  split.
  - intros [Hx e].
    destruct Hx as [Hx|Hx] ; now destruct x.
  - intro H.
    unfold int_or_ptr__is_valid.
    destruct x ; intuition easy.
Qed.

Lemma int64__odd__and_one (i: int64) (Hodd: Z.odd (Int64.unsigned i) = true):
  Int64.repr 1 = Int64.and i (Int64.repr 1).
Proof.
  destruct i as [i Hi].
  destruct i ; try lia ; try easy.
  unfold Int64.and.
  f_equal.
  simpl in *.
  clear -Hodd.
  change
    (Int64.unsigned (Int64.repr 1))
    with 1.
  simpl.
  change
    1
    with (Z.of_N (1)%N).
  f_equal.
  now destruct p.
Qed.

Lemma int__odd__and_one (i: int) (Hodd: Z.odd (Int.unsigned i) = true):
  Int.repr 1 = Int.and i (Int.repr 1).
Proof.
  destruct i as [i Hi].
  destruct i ; try lia ; try easy.
  unfold Int.and.
  f_equal.
  simpl in *.
  clear -Hodd.
  change
    (Int.unsigned (Int.repr 1))
    with 1.
  simpl.
  change
    1
    with (Z.of_N (1)%N).
  f_equal.
  now destruct p.
Qed.
