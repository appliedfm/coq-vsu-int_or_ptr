From VST Require Import floyd.proofauto.

Definition word_size: Z := Eval cbv [Archi.ptr64] in if Archi.ptr64 then 8 else 4.

Definition word_align: Z := Eval cbv [Archi.ptr64] in if Archi.ptr64 then 3 else 2.
