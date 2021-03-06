Require Import Crypto.Arithmetic.Core.
Require Import Crypto.Arithmetic.PrimeFieldTheorems.
Require Import Crypto.Specific.Framework.ArithmeticSynthesis.Ladderstep.
Require Import Crypto.Specific.X25519.C64.Synthesis.

(* TODO : change this to field once field isomorphism happens *)
Definition xzladderstep :
  { xzladderstep : feW -> feW * feW -> feW * feW -> feW * feW * (feW * feW)
  | forall x1 Q Q',
      let xz := xzladderstep x1 Q Q' in
      let eval := B.Positional.Fdecode wt in
      feW_tight_bounded x1
      -> feW_tight_bounded (fst Q) /\ feW_tight_bounded (snd Q)
      -> feW_tight_bounded (fst Q') /\ feW_tight_bounded (snd Q')
      -> ((feW_tight_bounded (fst (fst xz)) /\ feW_tight_bounded (snd (fst xz)))
          /\ (feW_tight_bounded (fst (snd xz)) /\ feW_tight_bounded (snd (snd xz))))
         /\ Tuple.map (n:=2) (Tuple.map (n:=2) phiW) xz = FMxzladderstep (m:=m) (eval (proj1_sig a24_sig)) (phiW x1) (Tuple.map (n:=2) phiW Q) (Tuple.map (n:=2) phiW Q') }.
Proof.
  Set Ltac Profiling.
  synthesize_xzladderstep ().
  Show Ltac Profile.
Time Defined.

Print Assumptions xzladderstep.
