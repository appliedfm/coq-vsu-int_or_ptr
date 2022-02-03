From VST Require Import floyd.proofauto.

From appliedfm Require Import int_or_ptr.model.int_or_ptr.
From appliedfm Require Import int_or_ptr.vst.ast.ast.
From appliedfm Require Import int_or_ptr.vst.clightgen.int_or_ptr.
From appliedfm Require Import int_or_ptr.vst.cmodel.val.
From appliedfm Require Import int_or_ptr.vst.spec.spec.

Lemma body_int_or_ptr__is_int:
  semax_body Vprog ASI f_int_or_ptr__is_int int_or_ptr__is_int_spec.
Proof.
  start_function.
  forward.
  forward.
  forward_if.
  {
    destruct H as [H|H].
    - destruct x ; simpl in H ; try contradiction.
      unfold denote_tc_islong, denote_tc_isint.
      unfold is_long, is_int.
      entailer!.
    - destruct x ; simpl in * ; try contradiction.
      exfalso.
      subst v.
      change
        (Int64.repr (Int.signed (Int.repr 1)))
        with (Int64.repr 1)
        in H0.
      change
        (Int64.repr (Int.signed (Int.repr 0)))
        with (Int64.repr 0)
        in H0.
      admit.
  }
  {
    forward.
    entailer!.
    clear H1.
    destruct H as [H|H] ; destruct x ; simpl in * ; try easy.
    exfalso.
    change
      (Int64.repr (Int.signed (Int.repr 1)))
      with (Int64.repr 1)
      in H0.
    first
      [ replace
          (Int64.and i (Int64.repr 1))
          with (Int64.repr 1)
          in H0
      | replace
          (Int.and i (Int.repr 1))
          with (Int.repr 1)
          in H0
      ].
    {
      inversion H0.
    }
    clear -H.
    unfold int_or_ptr__is_valid_int in H ; simpl in H.
    now first
      [ apply int64__odd__and_one
      | apply int__odd__and_one
      ].
  }
  forward.
  entailer!.
  destruct H as [H|H] ; now destruct x.
Admitted.

Lemma body_int_or_ptr__of_int:
  semax_body Vprog ASI f_int_or_ptr__of_int int_or_ptr__of_int_spec.
Proof.
  start_function.
  forward.
Qed.

Lemma body_int_or_ptr__to_int:
  semax_body Vprog ASI f_int_or_ptr__to_int int_or_ptr__to_int_spec.
Proof.
  start_function.
  red in H.
  destruct x; try easy.
  forward.
Qed.

Lemma body_int_or_ptr__of_ptr:
  semax_body Vprog ASI f_int_or_ptr__of_ptr int_or_ptr__of_ptr_spec.
Proof.
  start_function.
  forward.
Qed.

Lemma body_int_or_ptr__to_ptr:
  semax_body Vprog ASI f_int_or_ptr__to_ptr int_or_ptr__to_ptr_spec.
Proof.
  start_function.
  forward.
  red in H.
  destruct x; try easy.
Qed.
