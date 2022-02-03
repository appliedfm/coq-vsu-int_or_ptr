From VST Require Import floyd.proofauto.

From appliedfm Require Import int_or_ptr.model.int_or_ptr.
From appliedfm Require Import int_or_ptr.vst.ast.ast.
From appliedfm Require Import int_or_ptr.vst.clightgen.int_or_ptr.

Definition valid_int_or_ptr (x: val) :=
  match x with
  | Vint i => if Archi.ptr64 then False else Int.testbit i 0 = true
  | Vptr _ z => Ptrofs.testbit z 0 = false /\ Ptrofs.testbit z 1 = false
  | Vlong i => if Archi.ptr64 then Int64.testbit i 0 = true else False
  | _ => False
  end.

Definition int_or_ptr__is_int_spec :=
 DECLARE _int_or_ptr__is_int
 WITH x : val
 PRE [ int_or_ptr_type ]
   PROP (valid_int_or_ptr x)
   PARAMS (x)
   GLOBALS ()
   SEP ()
 POST [ tint ]
   PROP()
   LOCAL(temp ret_temp
          (Vint (Int.repr (match x with
                           | Vint _ => if Archi.ptr64 then 0 else 1
                           | Vlong _ => if Archi.ptr64 then 1 else 0
                           | _ => 0
                           end))))
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
    PROP (valid_int_or_ptr x)
    PARAMS (x)
    GLOBALS ()
    SEP ()
  POST [ int_or_ptr_type ]
    PROP() LOCAL (temp ret_temp x) SEP().

Definition int_or_ptr__of_ptr_spec :=
  DECLARE _int_or_ptr__of_ptr
  WITH x : val
  PRE [ tptr tvoid ]
    PROP (valid_int_or_ptr x)
    PARAMS (x)
    GLOBALS ()
    SEP()
  POST [ int_or_ptr_type ]
    PROP() LOCAL (temp ret_temp x) SEP().
