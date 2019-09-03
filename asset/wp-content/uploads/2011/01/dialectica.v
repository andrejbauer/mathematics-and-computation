(** Goedel's "Dialectica" functional interpretation of logic, slightly generalized and
   adapted for Coq.

   As a starting point we take chapter VI, "Goedel's Functional Interpretation", by J.
   Avigad and S. Feferman from "Handbook of Proof Theory", edited by S.R. Buss, published
   by Elsevier Science, 1995. A preliminary draft is available at
   http://www.andrew.cmu.edu/user/avigad/Papers/dialect.pdf.

   Author: Andrej Bauer, http://andrej.com/
*)

(** * Basic definitions *)

(** Needed for decidable equality on natural numbers but otherwise we could do without
   [Arith]. *)

Require Import Arith.
Require Import Bool.

(** The following line is specific to Coq 8.3, but Coq 8.2 does not seem to be bothered by
   it, so luckily this file is compatible with both versions. *)

Unset Automatic Introduction.

Set Implicit Arguments.

(** We shall allow universal and existential quantification over arbitrary inhabited types.
   The usual interpretation allows quantification over the natural numbers (and possibly
   functionals over the natural numbers), which are of course inhabited. *)

Record Inhabited := inhabit { ty :> Set; member : ty }.

(** The inhabited natural numbers. *)

Definition N := inhabit 0.

(** The inductive type [prp] is a "deep embedding" of the abstract syntax of
   the object language that we shall interpret into Coq. We admit only decidable primitive
   predicates, as is usual in the basic Dialectica variant.

   Our embedding allows us to express "exotic" propositional functions [p : ty -> prp] in
   which the logical structure of [p x] may depend on [x]. Because of this phenomenon we
   will be forced later on to introduce certain type dependencies where there are none in
   the usual Dialectica interpretation. *)

Inductive prp : Type :=
  | primitive : forall p : bool, prp
  | conjunction : prp -> prp -> prp
  | disjunction : prp -> prp -> prp
  | implication : prp -> prp -> prp
  | negation : prp -> prp
  | universal : forall (ty : Inhabited), (ty -> prp) -> prp
  | existential : forall (ty : Inhabited), (ty -> prp) -> prp.

(** Convenient notation for the object language. *)


Notation "'[' p ']'" := (primitive p) (at level 80, no associativity).
Notation "'neg' x" := (negation x) (at level 70, no associativity).
Notation "x 'and' y" := (conjunction x y) (at level 74, left associativity).
Notation "x 'or' y" := (disjunction x y) (at level 76, left associativity).
Notation "x ==> y" := (implication x y) (at level 78, right associativity).
Notation "'all' x : t , p" :=  (@universal t (fun x => p)) (at level 80, x at level 99).
Notation "'some' x : t , p" :=  (@existential t (fun x => p)) (at level 80, x at level 99).

(** printing ==> $\Longrightarrow$ #&rArr;# *)

(** With each proposition [p] we associate the types [W p] and [C p] of "witnesses" and
   "counters", respectively. Think of them as moves in a game between a player [W] and an
   opponent [C]. We make two changes to the standard Dialectica representation.

   First, we use sum for counters of conjunctions, where normally a product is used. This
   gives us symmetry between conjunction and disjunction, simplifies the notorious
   conjunction contraction [and_contr], but complicates the adjunction between implication
   and conjunction. Thomas Streicher pointed out that the change is inessential in the
   sense that we could prove a separate lemma which allows us to pass from counters for [p
   and q] as pairs to counters as elements of a sum (such a lemma relies in decidability
   of the [dia] relation defined below).

   Second, because we allow the structure of a propositional function to depend on the
   argument, we are forced to introduce type dependency into [W p] and [C p] when [p] is a
   quantified statement. This is not a big surprise, but what is a little more surprising
   is that the counters for existentials, [C (existential ty p')], involve a dependency
   not only on [ty] but also on [W (p' x)]. The dependency is needed in the rule
   [exists_elim]. The rest of Dialectica interpetation is not influenced by this change,
   with the exception of the Independence of Premise where we have to impose a condition
   that is not required in the usual interpretation.

   These type-dependecies clearly towards an even more type-dependent Dialectica variant.
   Indeed, we are going to investigate it in a separate file. For now we are just trying
   to faithfully represent the Dialectica interpretation. *)

Fixpoint W (p : prp) :=
  (match p with
     | primitive p => unit
     | conjunction p1 p2 => (W p1) * (W p2)
     | disjunction p1 p2 => (W p1) + (W p2)
     | implication p1 p2 => (W p1 -> W p2) * (W p1 * C p2 -> C p1)
     | negation p' => (W p' -> C p')
     | universal ty p' => (forall x : ty, W (p' x))
     | existential ty p' => { x : ty & W (p' x) }
   end)%type

with C p : Set :=
  (match p with
     | primitive p => unit
     | conjunction p1 p2 => (C p1) + (C p2)
     | disjunction p1 p2 => (C p1) * (C p2)
     | implication p1 p2 => (W p1) * (C p2)
     | negation p' => W p'
     | universal ty p' => { x : ty & C (p' x) }
     | existential ty p' => (forall x : ty, W (p' x) -> C (p' x))
   end)%type.

(** The relation [dia p w c] is what is usually written as [p_D] in the Dialectica
   interpretation, i.e., the matrix of the interpreted formula.

   In terms of games, [dia p w c] tells whether the player move [w] wins against the
   opponent move [c] in the game determined by the proposition [p].
*)

Fixpoint dia (p : prp) : W p -> C p -> Prop :=
  match p return W p -> C p -> Prop with
    | primitive p => (fun _ _ => Is_true p)
    | conjunction p1 p2 =>
      (fun a b => match b with
                    | inl b1 => dia p1 (fst a) b1
                    | inr b2 => dia p2 (snd a) b2
                  end)
    | disjunction p1 p2 =>
        (fun a b => match a with
                      | inl x => dia p1 x (fst b)
                      | inr u => dia p2 u (snd b)
                    end)
    | implication p1 p2 =>
        (fun a b => dia p1 (fst b) (snd a b) -> dia p2 (fst a (fst b)) (snd b))
    | negation p' =>
        (fun a b => ~ dia p' b (a b))
    | universal t p' =>
        (fun a b => dia (p' (projT1 b)) (a (projT1 b)) (projT2 b))
    | existential t p' =>
        (fun a b => dia (p' (projT1 a)) (projT2 a) (b (projT1 a) (projT2 a)))
  end.

(** The [dia] relation is decidable. This fact is used only in the adjunction between
   conjunction and implication. *)

Theorem dia_decidable (p : prp) (a : W p) (b : C p) : {dia p a b} + {not (dia p a b)}.
Proof.
  intros p a b.
  induction p.

  unfold dia, Is_true.
  induction p; tauto.

  unfold W in a; simpl in a; fold W in a.
  destruct a as [a1 a2].
  unfold C in b; simpl in b; fold C in b.
  destruct b as [b1|b2]; simpl.
  apply IHp1.
  apply IHp2.

  destruct b as [b1 b2].
  destruct a as [a1 | a2]; [apply IHp1 | apply IHp2].

  destruct a as [f g].
  destruct b as [x v].
  assert (I := IHp1 x (g (x,v))).
  assert (J := IHp2 (f x) v).
  unfold dia; fold dia.
  tauto.

  unfold dia; fold dia.
  destruct (IHp b (a b)).
  right.
  intro; contradiction.
  left; auto.

  unfold dia; fold dia.
  apply H.

  unfold dia; fold dia.
  apply H.
Qed.

(** Of course, a decidable proposition is stable for double negation. *)

Lemma dia_not_not_stable (p : prp) (w : W p) (c : C p) : ~ ~ dia p w c -> dia p w c.
Proof.
  intros p w c H.
  destruct (dia_decidable p w c); tauto.
Qed.

(** The types [W] and [C] are always inhabited because we restrict quantifiers to inhabited
   types. *)

Definition WC_member (p : prp) : W p * C p.
  induction p; unfold W; unfold C; simpl; fold W; fold C; split; try firstorder.
  exact (member ty0).
  exact (member ty0).
Defined.

Definition W_member (p : prp) := fst (WC_member p).
Definition C_member (p : prp) := snd (WC_member p).

(** The predicate [valid p] is the Dialectica interpretation of [p]. It says that there is
   [w] such that [dia p w c] holds for any [c]. In terms of games semantics this means
   that [W] has a winning strategy (which amounts to a winning move [w]). *)

Definition valid (p : prp) := { a : W p | forall b : C p, dia p a b }.

(** * Validity of inference rules *)

(** We now verify that the Hilbert-style axioms for first-order logic are validated by our
   interpretation. We follow Avigad & Feferman. *)

Theorem modus_ponens (p q : prp) : valid p -> valid (p ==> q) -> valid q.
Proof.
  unfold valid,  W, C; simpl; fold W; fold C; simpl.
  intros p q [wp H] [[u v] G].
  simpl in G.
  exists (u wp).
  intro b.
  apply (G (wp, b)); simpl.
  apply H.
Qed.

Theorem impl_chain (p q r : prp) : valid (p ==> q) -> valid (q ==> r) -> valid (p ==> r).
Proof.
  unfold valid,  W, C; simpl; fold W; fold C; simpl.
  intros p q r [[a b] H] [[c d] G].
  exists (fun w => c (a w), fun v => b (fst v, d (a (fst v), snd v))).
  simpl in H.
  simpl in G.
  simpl.
  intros g I.
  apply (G (a (fst g), snd g)); simpl.
  apply (H (fst g, d (a (fst g), snd g))); simpl.
  assumption.
Qed.

Theorem or_contr (p : prp) : valid (p or p ==> p).
Proof.
  intros p.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (fun x => (match x with inl a => a | inr a => a end), fun x => (snd x, snd x)); simpl.
  intros [u v]; simpl.
  destruct u; auto.
Qed.

(** In the following theorem we avoid decidability of [dia] because we defined
   counters of conjunctions as sums. *)

Theorem and_contr (p : prp) : valid (p ==> p and p).
Proof.
  intros p.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (fun x => (x,x),
          fun y => match snd y with
                     | inl c => c
                     | inr c => c
                   end); simpl.
  intros [u [v1|v2]] H; auto.
Qed.

Theorem or_introl (p q : prp) : valid (p ==> p or q).
Proof.
  intros p q.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (fun x => @inl _ _ x, fun y => fst (snd y)).
  auto.
Qed.

Theorem and_eliml (p q : prp) : valid (p and q ==> p).
Proof.
  intros p q.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (@fst _ _, fun y => @inl _ _ (snd y)).
  tauto.
Qed.

Theorem or_comm (p q : prp) : valid (p or q ==> q or p).
Proof.
  intros p q.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (fun x => match x with inl a => @inr _ _ a | inr b => @inl _ _ b end,
          fun y => (snd (snd y), fst (snd y))); simpl.
  intros [u [v w]]; simpl.
  destruct u; auto.
Qed.

Theorem and_comm (p q : prp) : valid (p and q ==> q and p).
Proof.
  intros p q.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (fun x => (snd x, fst x), 
          fun y => match snd y with
                     | inl c => @inr _ _ c
                     | inr c => @inl _ _ c
                   end).
  intros [[a1 a2] [b1|b2]]; auto.
Qed.

Theorem or_distr (p q r : prp) : valid (p ==> q) -> valid (r or p ==> r or q).
Proof.
  intros p q r.
  unfold valid, C, W; simpl; fold C; fold W.
  intros [[a b] H].
  simpl in H.
  exists (fun x => match x with inl t => @inl _ _ t | inr u => @inr _ _ (a u) end,
          fun y => match fst y with
                     | inl i => (fst (snd y), b (W_member p, snd (snd y)))
                     | inr j => (fst (snd y), b (j, snd (snd y)))
                   end).
  intros [c [d e]]; simpl.
  destruct c; auto.
  intro G.
  apply (H (w, e)); simpl.
  apply G.
Qed.

(** The next two theorems verify the adjunction between conjunction and implication. This is
   where we need decidability of [dia p w c] and inhabitation of [W] and [C]. *)

Theorem impl_conj_adjunct1 (p q r : prp) : valid (p ==> (q ==> r)) -> valid (p and q ==> r).
Proof.
  intros p q r.
  unfold valid, C, W; simpl; fold C; fold W.
  intros [[a b] H].
  simpl in H.
  eexists (fun x => fst (a (fst x)) (snd x),
          fun (y : W p * W q * C r) =>
            let (wp, wq) := fst y in 
            let cr := snd y in
            if dia_decidable q wq (snd (a wp) (wq, cr))
            then @inl _ _ (b (wp, (wq, cr)))
            else @inr _ _ (snd (a wp) (wq, cr))).
  simpl.
  intros [[c d] e].
  simpl.
  destruct (dia_decidable q d (snd (a c) (d,e))) as [D1 | D2].
  intro G.
  apply (H (c, (d, e))); auto.
  intro G.
  contradiction.
Qed.

Theorem impl_conj_adjunct2 (p q r : prp) : valid (p and q ==> r) -> valid (p ==> (q ==> r)).
Proof.
  intros p q r.
  unfold valid, C, W; simpl; fold C; fold W.
  intros [[a b] H]; simpl in H.
  exists (fun x => (fun u => a (x, u), fun v => match b ((x, fst v), snd v) with
                                                  | inl c => C_member q
                                                  | inr d => d
                                                end),
          fun y => match b ((fst y, fst (snd y)), snd (snd y)) with
                     | inl c => c
                     | inr d => C_member p
                   end).
  simpl.
  intros [u [v w]]; simpl.
  intros F G.
  apply (H (u, v, w)).
  destruct (b (u, v, w)); auto.
Qed.

Theorem false_elim (p : prp) : valid ([false] ==> p).
Proof.
  intros p.
  unfold valid, C, W; simpl; fold C; fold W.
  exists ((fun _ => W_member p), (fun _ => tt)).
  intros [u v] G.
  contradiction.
Qed.
  
Theorem forall_intro (ty : Inhabited) (p : prp) (q : ty -> prp) :
  (forall x : ty, valid (p  ==> q x)) -> valid (p ==> all x : ty, q x).
Proof.
  intros t p q.
  unfold valid, C, W; simpl; fold C; fold W.
  intros H.
  exists ((fun u x => fst (projT1 (H x)) u),
          (fun (y : (W p * {x : t & C (q x)})) =>
           snd (projT1 (H (projT1 (snd y)))) (fst y, projT2 (snd y)))).
  intros [u [x v]].
  simpl.
  intros G.
  apply (projT2 (H x) (u, v)).
  auto.
Qed.

Theorem forall_elim (ty : Inhabited) (a : ty) (p : ty -> prp) :
  valid ((all x : ty, p x) ==> p a).
Proof.
  intros t a p.
  unfold valid, C, W; simpl; fold C; fold W.
  exists ((fun f => f a), (fun y => existT _ a (snd y))); auto.
Qed.

Theorem exists_intro (ty : Inhabited) (a : ty) (p : ty -> prp) :
  valid (p a ==> some x : ty, p x).
Proof.
  intros t a p.
  unfold valid, C, W; simpl; fold C; fold W.
  exists ((fun x => existT _ a x),
          (fun y => snd y a (fst y))); auto.
Qed.

(** This is the rule in which we need the dependency of counters in existential statements. *)

Theorem exists_elim (ty : Inhabited) (p : ty -> prp) (q : prp) :
  (forall x : ty, valid (p x ==> q)) -> valid ((some x : ty, p x) ==> q).
Proof.
  intros t p q.
  unfold valid, C, W; simpl; fold C; fold W.
  intros H.
  exists ((fun (u : {x : t & W (p x)}) => fst (projT1 (H (projT1 u))) (projT2 u)),
          (fun v x w => snd (projT1 (H x)) (w, snd v))).
  simpl.
  intros [[x u] v]; simpl.
  intro G.
  apply (projT2 (H x) (u, v)).
  simpl.
  apply G.
Qed.

(** * Equality

   Next we verify the rules of equality. To keep things simple we only consider equality
   of natural numbers. In the general case we could consider decidable equality on an
   inhabited type. *)

Definition prpEq (m n : N) := [beq_nat m n].

(** Dialectica equality implies equality. *)

Theorem prpEq_eq (m n : N) : valid (prpEq m n) -> m = n.
Proof.
  unfold prpEq, valid; simpl; fold valid.
  intros m n [_ H].
  assert (G := H tt).
  apply beq_nat_true.
  apply Is_true_eq_true.
  assumption.
Qed.

(** Equality implies Dialectica equality, of course, but notice how complicated the proofs
   seems to be. We could move the complication into [prpEq_refl] below. *)

Theorem eq_prpEq (m n : N) : m = n -> valid (prpEq m n).
Proof.
  intros m n E.
  rewrite E.
  exists tt.
  intro b.
  unfold dia; simpl; fold dia.
  apply Is_true_eq_right.
  apply (beq_nat_refl n).
Qed.

(** Reflexivity. *)

Theorem prpEq_refl (n : N) : valid (prpEq n n).
Proof.
  intros n.
  apply eq_prpEq.
  reflexivity.
Qed.

(** Leibniz's law as a rule of inference. *)

Theorem leibniz_rule (p : N -> prp) (m n : N) :
  valid (prpEq m n) -> valid (p m) -> valid (p n).
Proof.
  unfold valid, C, W; simpl; fold C; fold W.
  intros p m n [a H] [b G].
  assert (E := H tt).
  apply Is_true_eq_true in E.
  apply beq_nat_true in E.
  rewrite <- E.
  exists b.
  assumption.
Qed.

(** Proving Leibniz's law as a proposition is more complicated because of type dependency
   that is not present in the usual Dialectica interpretation.

   In fact, it looks like we need UIP (Uniqueness of Identity Proofs) for natural numbers,
   which luckily holds since the natural numbers are decidable. Below we prove UIP for N.
   Coq 8.3 contains a more general proof of UIP for decidable types, see [Logic.Eqdep_dec]. *)

Definition eqN_compose (k m n : N) (p : k = m) (q : k = n) : m = n.
Proof.
  intros k m n p q.
  induction p.
  exact q.
Defined.

Lemma eqN_compose_transitivity (m n : N) (p : m = n) : eqN_compose p p = refl_equal n.
Proof.
  intros m n p.
  case p; trivial.
Qed.

Lemma eqN_decidable (m n : N) : {m = n} + {m <> n}.
Proof.
  induction m; induction n; auto.
  destruct (IHm n) as [E1 | E2].
  rewrite E1.
  left.
  reflexivity.
  right.
  injection.
  contradiction.
Qed.

Definition eqN_nu (m n : N) (p : m = n) : (m = n).
Proof.
  intros m n p.
  destruct (eqN_decidable m n) as [EQ|NEQ].
  exact EQ.
  contradiction.
Defined.

Definition eqN_mu (m n : N) (p : m = n) := eqN_compose (eqN_nu (refl_equal m)) p.

Lemma eqN_mu_nu (n m : N) (p : n = m) : eqN_mu (eqN_nu p) = p.
Proof.
  intros n m p.
  case p.
  unfold eqN_mu.
  apply eqN_compose_transitivity.
Qed.

Theorem UIP_N : forall (m n : N) (p q : m = n), p = q.
Proof.
  intros m n p q.
  elim eqN_mu_nu with (p := p).
  elim eqN_mu_nu with (p := q).
  unfold eqN_nu.
  destruct (eqN_decidable m n) as [EQ|NEQ].
  reflexivity.
  contradiction.
Qed.

Definition W_transfer (p : N -> prp) (m n : N) : W (p m) -> W (p n).
Proof.
  intros p m n w.
  destruct (eqN_decidable m n) as [E1 | E2].
  rewrite <- E1.
  exact w.
  exact (W_member ((p n))).
Defined.

Definition C_transfer (p : N -> prp) (m n : N) : C (p m) -> C (p n).
Proof.
  intros p m n c.
  destruct (eqN_decidable m n) as [E1 | E2].
  rewrite <- E1.
  exact c.
  exact (C_member ((p n))).
Defined.

(** Finally, the validity of Leibniz's law is proved. If someone knows a shortcut,
   I would like to know about it. *)

Theorem leibniz (p : N -> prp) (m n : N) : valid (prpEq m n ==> p m ==> p n).
Proof.
  intros p m n.
  unfold valid, C, W; simpl; fold C; fold W.
  exists ((fun tt => ((fun (w : W (p m)) => W_transfer p m n w),
                      (fun y => C_transfer p n m (snd y)))),
          (fun _ => tt)).
  intros [u [w c]].
  simpl.
  intros E.
  apply Is_true_eq_true in E.
  apply beq_nat_true in E.
  destruct E.
  unfold C_transfer, W_transfer.
  destruct (eqN_decidable m m) as [E1 | E2].
  assert (U := UIP_N E1 (refl_equal m)).
  rewrite U.
  simpl.
  auto.
  assert (F2 : m = m); auto.
  contradiction.
Qed.

(** * Natural numbers

   Next we verify that the natural numbers obey Peano axioms. They are easy, except for
   induction which has two parts: the usual "forward" direction by primitive recursion,
   and a "backwards" direction in which we search for a counter-example, starting from an
   upper bound and going down to 0. *)

Theorem nat_zero_not_succ (n : nat) :
  valid (neg (prpEq (S n) 0)).
Proof.
  intro n.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (fun tt => tt); auto.
Qed.

Theorem succ_injective (m n : nat) :
  valid (prpEq (S m) (S n) ==> prpEq m n).
Proof.  
  intros m n.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (fun _ => tt, fun _ => tt); auto.
Qed.

(** Given a propositional function [p : nat -> prp], suppose [p m] is not valid. Then [p
   0] is not valid, or one of induction steps [p k ==> p (S k)] fails. The "backwards"
   direction of the Dialectica interpretation of induction is a search functional which
   looks for a failed base case or failed induction step. We construct it separately from
   the main proof. *)

Definition search (p : N -> prp) (m : N) :
  W (p 0) ->
  (forall k : N, W (p k) -> W (p (S k))) ->
  (forall k : N, W (p k) * C (p (S k)) -> C (p k)) ->
  C (p m) ->
  C (p 0) + {n : N & (W (p n) * C (p (S n)))%type}.
Proof.
  intros p m z s b c.
  induction m.
  left; exact c.
  pose (w := nat_rect _ z s m).
  destruct (dia_decidable (p m) w (b m (w, c))) as [D1|D2].
  right.
  exists m.
  exact (w, c).
  apply IHm.
  exact (b m (w, c)).
Defined.

(** Finally we verify validity of induction. *)

Theorem N_induction (p : nat -> prp) (m : nat) :
  valid (p 0 and (all n : N, p n ==> p (S n)) ==> p m).
Proof.
  intros p m.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (fun x => nat_rect _ (fst x) (fun k => fst (snd x k)) m,
          fun y => search p m (fst (fst y))
                     (fun k => fst (snd (fst y) k))
                     (fun k => snd (snd (fst y) k))
                     (snd y)).
  simpl.
  intros [[z h] c]; simpl.
  set (s := fun k : nat => fst (h k)).
  set (b := fun k : nat => snd (h k)).
  induction m; auto.
  unfold search; simpl.
  set (w := nat_rect (fun k : nat => W (p k)) z s m).
  destruct (dia_decidable (p m) w (b m (w, c))) as [D1|D2]; simpl.
  intro H.
  apply H.
  apply D1.
  intros.
  assert (G:= IHm (b m (w, c))).
  fold w in G.
  elim D2.
  apply G.
  apply H.
Qed.

(** Having done ordinary induction one is tempted to try validating induction for
   W-types... but not here. *)

(** * Markov Principle and Independence of Premise *)

(** The Dialectica interpretation is characterized by two non-intuitionistic reasoning principles,
   namely Markov principle (MP) and Independence of Premise (IP).

   Both MP and IP involve primitive propositional function [N -> bool]. The point of
   these is that their [W] and [C] types are the unit. So instead of actually using
   primitive proposition, we shall use arbitrary propositions whose [W] and [C] types are
   singletons. First we make the relevant definitions. *)

Definition singleton (t : Inhabited) := forall x, x = member t.

Definition trivial_C (p : prp) := singleton (inhabit (C_member p)).
Definition trivial_W (p : prp) := singleton (inhabit (W_member p)).

(** Primitive propositions are trivial, of course. *)

Lemma primitive_trivial_W (b : bool) : trivial_W ([b]).
Proof.
  intros b w.
  case w; auto.
Qed.

Lemma primitive_trivial_C (b : bool) : trivial_C ([b]).
Proof.
  intros b c.
  case c; auto.
Qed.

(** Whether there are trivial propositions, other than the primitive ones, depends on what
   extra axioms we have available. For example, in the presence of extensionality of
   functions, implications and negations of trivial propositions are trivial. We do not
   dwell on the exact conditions that give us trivial propositions, but only demonstrate
   how to use extensionality of functions whose codomain is a singleton set to derive
   triviality of implication of trivial propositions.
*)

(** Is there a better way of getting the next lemma? *)

Lemma pair_equal (X Y : Set) (p q : X * Y) :
  fst p = fst q -> snd p = snd q -> p = q.
Proof.
  intros X Y p q G H.
  induction p; induction q.
  simpl in G; simpl in H.
  rewrite G; rewrite H.
  reflexivity.
Qed.

(** We are only interested in extensionality of functions [s -> t] for which
   [t] is a singleton. Such extensionality can be phrased as "any power of a
   singleton is a singleton". *)

Definition singleton_power :=
  forall t, singleton t -> forall s : Set, singleton (inhabit (fun _ : s => member t)).

(** I _think_ there is no way of proving [singleton_power], is there? We can use it to
   show that [W (p ==> q)] is trivial if [C p] and [W q] are trivial. *)

Lemma implication_trivial_W (p q : prp) :
  singleton_power -> trivial_C p -> trivial_W q -> trivial_W (p ==> q).
Proof.
  intros p q E TCp TWq.
  unfold trivial_W.
  unfold singleton.
  unfold W_member, C_member; simpl; fold W_member; fold C_member.
  intros [f g].
  apply pair_equal; simpl.
  rewrite (E _ TWq _).
  rewrite (E _ TWq _ f).
  reflexivity.
  rewrite (E _ TCp _).
  rewrite (E _ TCp _ g).
  reflexivity.
Qed.

(** Triviality of [C (p ==> q)] does not require any extra assumptions. *)
Lemma implication_trivial_C (p q : prp) :
  trivial_W p -> trivial_C q -> trivial_C (p ==> q).
Proof.
  intros p q TWp TCq.
  unfold trivial_C.
  unfold C, W; simpl; fold C; fold W.
  intros [wp cq].
  rewrite (TWp wp).
  rewrite (TCq cq).
  apply pair_equal; auto.
Qed.

(** ** Markov principle *)
  
(** Markov principle holds for any inhabited type (not just the natural numbers) and
   a proposition which has trivial [W] and [C] types. *)

Theorem markov_generalized (t : Inhabited) (p : t -> prp) :
  (forall x, trivial_C (p x)) ->
  (forall x, trivial_W (p x)) ->
  valid (neg (all x : t, neg (p x)) ==> some x : t, p x).
Proof.
  intros t p TC TW.
  unfold valid, C, W; simpl; fold C; fold W.
  pose (u := fun (h : _ -> {x : t & W (p x)})  =>
    let y := projT1 (h (fun x (_ : W (p x)) => C_member (p x))) in
      existT (fun x : t => W (p x)) y (W_member (p y))).
  exists (u, fun _ x _ => C_member (p x)); simpl.
  intros [f g].
  simpl.
  set (v := projT1 (f (fun x _ => C_member (p x)))).
  set (w := projT2 (f (fun (x : t) (_ : W (p x)) => C_member (p x)))).
  rewrite (TC v (g v (W_member (p v)))).
  rewrite (TW v w).
  apply dia_not_not_stable.
Qed.

(** The usual Markov principle now follows easily. *)

Theorem markov (p : N -> bool) :
  valid (neg (all n : N, neg [p n]) ==> some n : N, [p n]).
Proof.
  intro p.
  apply markov_generalized with (t := N) (p := fun (n : N) => [p n]).
  intro; apply primitive_trivial_C.
  intro; apply primitive_trivial_W.
Qed.

(** ** The Independence of Premise *)

(** The usual IP relates propositional functions [p : s -> bool] and [q : t -> prp]:

   [((all x : s, p x) ==> some y : t, q y) ==> some y : t, (all x : s, p x) ==> q y]

   It is possible to generalize [p] to [p : s -> prp] with trival [W (p x)]. On the other
   hand, the type-dependencies force us to require that [C (q y)] be trivial. The proof
   below is unnecessarily complicated towards the end because I hit against a bug in
   [rewrite], see http://coq.inria.fr/bugs/show_bug.cgi?id=2061. *)

Theorem ip_generalized (s t : Inhabited) (p : s -> prp) (q : t -> prp) :
  (forall (x : s), trivial_W (p x)) ->
  (forall (y : t), trivial_C (q y)) ->
  valid (((all x : s, p x) ==> some y : t, q y) ==> some y : t, (all x : s, p x) ==> q y).
Proof.
  intros s t p q TW TC.
  unfold valid, C, W; simpl; fold C; fold W.
  pose (u := fun (x : s) => W_member (p x)).
  pose (v := fun (y : t) (w : W (q y)) => C_member (q y)).
  refine (existT _
          ((fun a => existT _ (projT1 (fst a u)) (fun _ => projT2 (fst a u),
                                                 (fun b => snd a (u, v)))),
           (fun _ => (u,v)))
          _).
  simpl.
  intros [[f g] h].
  simpl.
  set (y := projT1 (f u)).
  set (z := projT1 (g (u, v))).
  intros G.
  fold v.
  intro H.
  rewrite (TC y); simpl.
  rewrite (TC y (v y (projT2 (f u)))) in G; simpl in G.
  apply G.
  replace (u z) with (fst (h y (fun _ : forall x : s, W (p x) => projT2 (f u),
                                fun _ : (forall x : s, W (p x)) * C (q y) => g (u, v))) z).
  assumption.
  transitivity (member (inhabit (W_member (p z)))); apply (TW z).
Qed.

(** A special case of our IP occurs when [p] is a primitive propositional function. *)

Theorem ip (s t : Inhabited) (p : s -> bool) (q : t -> prp) :
  (forall (y : t), trivial_C (q y)) ->
  valid (((all x : s, [p x]) ==> some y : t, q y) ==> some y : t, (all x : s, [p x]) ==> q y).
Proof.
  intros s t p q TC.
  apply ip_generalized.
  intro; apply primitive_trivial_W.
  intro; apply TC.
Qed.

(** This concludes the verification of the Dialectica interpretation in Coq. There are at
   least three interesting directions to go:

   - Extract programs from the Dialectica interpretation. It looks like this could be done
     for extraction into Scheme. Extraction into Haskell and Ocaml seem more complicated
     because the [W] and [C] types are dependent and there seems no easy way of
     translating them into a simply-typed programming language. Presumably, concrete
     examples could be extracted with the help of "[Extraction Inline W C.]".

   - Explore other variants, such as the Diller-Nahm interpretation, or perhaps the
     interpretations a la Ulrich Kohlenbach and Paolo Oliva.

   - Explore the possibility of having a fully dependent Dialectica interpretation.
     Initial investigations by Thomas Streicher and myself indicate that it can be done.
     This would give us a way of constructing a two-level type system (with Prop separate
     from Set) that validates MP and IP. *)
