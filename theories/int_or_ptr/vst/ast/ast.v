From VST Require Import floyd.proofauto.
From VST Require Import floyd.library.
From appliedfm Require Import int_or_ptr.vst.clightgen.int_or_ptr.

#[global]Instance CompSpecs : compspecs. make_compspecs prog. Defined.
Definition Vprog : varspecs. mk_varspecs prog. Defined.
