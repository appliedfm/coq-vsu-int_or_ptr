From VST Require Import floyd.proofauto.

From appliedfm Require Import int_or_ptr.model.int_or_ptr.
From appliedfm Require Import int_or_ptr.vst.ast.ast.
From appliedfm Require Import int_or_ptr.vst.cmodel.val.
From appliedfm Require Import int_or_ptr.vst.clightgen.int_or_ptr.

Definition int_or_ptr__is_int_spec :=
 DECLARE _int_or_ptr__is_int
 WITH x : val
 PRE [ int_or_ptr_type ]
   PROP (int_or_ptr__is_valid x)
   PARAMS (x)
   GLOBALS ()
   SEP ()
 POST [ tint ]
   PROP()
   LOCAL(temp ret_temp
          (Vint (Int.repr (if (int_or_ptr__is_int x) then 1 else 0))))
   SEP().

Definition int_or_ptr__to_int_spec :=
  DECLARE _int_or_ptr__to_int
  WITH x : val
  PRE [ int_or_ptr_type ]
    PROP (is_int I32 Signed x)
    PARAMS (x)
    GLOBALS ()
    SEP ()
  POST [ (if Archi.ptr64 then tlong else tint) ]
    PROP() LOCAL (temp ret_temp x) SEP().

Definition int_or_ptr__to_ptr_spec :=
  DECLARE _int_or_ptr__to_ptr
  WITH x : val
  PRE [ int_or_ptr_type ]
    PROP (isptr x)
    PARAMS (x)
    GLOBALS ()
    SEP ()
  POST [ tptr tvoid ]
    PROP() LOCAL (temp ret_temp x) SEP().

Definition int_or_ptr__of_int_spec :=
  DECLARE _int_or_ptr__of_int
  WITH x : val
  PRE [ (if Archi.ptr64 then tlong else tint) ]
    PROP (int_or_ptr__is_valid x)
    PARAMS (x)
    GLOBALS ()
    SEP ()
  POST [ int_or_ptr_type ]
    PROP() LOCAL (temp ret_temp x) SEP().

Definition int_or_ptr__of_ptr_spec :=
  DECLARE _int_or_ptr__of_ptr
  WITH x : val
  PRE [ tptr tvoid ]
    PROP (int_or_ptr__is_valid x)
    PARAMS (x)
    GLOBALS ()
    SEP()
  POST [ int_or_ptr_type ]
    PROP() LOCAL (temp ret_temp x) SEP().

Definition ASI: funspecs := ltac:(with_library prog
  [ int_or_ptr__is_int_spec
  ; int_or_ptr__to_int_spec
  ; int_or_ptr__to_ptr_spec
  ; int_or_ptr__of_int_spec
  ; int_or_ptr__of_ptr_spec
  ]).
