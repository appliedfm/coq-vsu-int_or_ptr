From VST Require Import floyd.proofauto.
From VST Require Import floyd.VSU.

From appliedfm Require Import int_or_ptr.vst.clightgen.int_or_ptr.
From appliedfm Require Import int_or_ptr.vst.spec.spec.
From appliedfm Require Import int_or_ptr.vst.verif.verif.

#[local] Existing Instance NullExtension.Espec.

Lemma int_or_ptr__vsu: VSU int_or_ptr__specs.externs int_or_ptr__specs.imports ltac:(QPprog prog) int_or_ptr__specs.exports emp.
Proof.
  mkVSU prog int_or_ptr__specs.all.
  - solve_SF_internal body_int_or_ptr__sizeof.
  - solve_SF_internal body_int_or_ptr__alignof.
  - solve_SF_internal body_int_or_ptr__is_int.
  - solve_SF_internal body_int_or_ptr__to_int.
  - solve_SF_internal body_int_or_ptr__to_ptr.
  - solve_SF_internal body_int_or_ptr__of_int.
  - solve_SF_internal body_int_or_ptr__of_ptr.
Qed.
