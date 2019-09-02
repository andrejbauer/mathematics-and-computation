---
id: 800
title: The Dialectica interpertation in Coq
date: 2011-01-03T02:07:41+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=800
permalink: /2011/01/03/the-dialectica-interpertation-in-coq/
categories:
  - Constructive math
  - Logic
---
I think I am getting addicted to [Coq](http://coq.inria.fr/), or more generally to doing mathematics, including the proofs, with computers. I spent last week finalizing a formalization of Gödel&#8217;s functional interpretation of logic, also known as the _Dialectica_ interpretation. There does not seem to be one available already, which is a good opportunity for a blog post.

<!--more-->I would like to think we are not too far from a future in which the standard in mathematical research will be to always publish papers together with computer-verified proofs. In some areas of theoretical computer science, for example in the theory of programming languages, such a future is rapidly becoming the present. Mainstream mathematics is still not there, but once the tools get good enough, computer-assisted theorem proving will spread approximately as fast as TeX did some time ago. Let that be my New Year&#8217;s prediction! In the meanwhile the enthusiasts should explore the possibilities offered by what is currently available.

I always liked the work on [proof mining](http://en.wikipedia.org/wiki/Proof_mining), but I could never quite memorize the details of Gödel&#8217;s Dialectica interpretation, which lies at the basis of proof mining. Doing them in Coq was a good way of learning about the Dialectica interpretation, and I even got some new ideas (but that&#8217;s a topic for another day).

If you are not familiar with the Dialectica interpetation I recommend [Jeremy Avigad&#8217;s](http://www.andrew.cmu.edu/user/avigad/) and [Solomon Feferman&#8217;s](http://math.stanford.edu/~feferman/) chapter on _&#8220;[Gödel&#8217;s functional (&#8220;Dialectica&#8221;) interpretation](http://www.andrew.cmu.edu/user/avigad/Papers/dialect.pdf)&#8220;_ in S. Buss ed., _The Handbook of Proof Theory,_ North-Holland, pages 337-405, 1999.

Since this is not a tutorial I will only say that the main idea is a transformation of each formula $\phi$ to a classically equivalent formula $\phi^D$ of the form $\exists x . \forall u . \phi\_D(x,u)$ with $\phi\_D$ quantifier-free. The amazing thing is that $\phi^D$ is sometimes constructively valid even though $\phi$ is not, so this is a systematic way of &#8220;constructivizing&#8221; classical mathematics. To see what can be done with it, have a look at [Ulrich Kohlenbach](http://www.mathematik.tu-darmstadt.de/~kohlenbach/)&#8216;s [book](http://www.springer.com/mathematics/book/978-3-540-77532-4).

Writing this post forced me to think about how to present a computer-assisted piece of mathematics. Should I just publish the Coq file and be done with it, or should I inline the Coq code? I suppose it is better to do both.

**Download:** [dialectica.v](http://math.andrej.com/wp-content/uploads/2011/01/dialectica.v)

The following is essentially the same as the above file. 

### Basic definitions

We present Goedel&#8217;s &#8220;Dialectica&#8221; functional interpretation of logic, slightly generalized and adapted for Coq. 

Needed for decidable equality on natural numbers but otherwise we could do without `Arith`.

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">Require Import Arith.
Require Import Bool.
</pre>

The following line is specific to Coq 8.3, but Coq 8.2 does not seem to be bothered by it, so luckily this file is compatible with both versions.

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">Unset Automatic Introduction.
Set Implicit Arguments.
</pre>

We shall allow universal and existential quantification over arbitrary inhabited types. The usual interpretation allows quantification over the natural numbers (and possibly functionals over the natural numbers), which are of course inhabited.

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">Record Inhabited := inhabit { ty :&gt; Set; member : ty }.
</pre>

The inhabited natural numbers:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">Definition N := inhabit 0.
</pre>

The inductive type `prp` is a kind of &#8220;deep embedding&#8221; of the abstract syntax of the object language that we shall interpret into Coq. We admit only decidable primitive predicates, as is usual in the basic Dialectica variant. (Note: The original version of this post claimed we used [higher-order abstract syntax](http://en.wikipedia.org/wiki/Higher-order_abstract_syntax) (HOAS). Thanks to Bob Harper for pointing out that in fact we didn&#8217;t.)

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">Inductive prp : Type :=
  | primitive : bool -&gt; prp
  | conjunction : prp -&gt; prp -&gt; prp
  | disjunction : prp -&gt; prp -&gt; prp
  | implication : prp -&gt; prp -&gt; prp
  | negation : prp -&gt; prp
  | universal : forall (ty : Inhabited), (ty -&gt; prp) -&gt; prp
  | existential : forall (ty : Inhabited), (ty -&gt; prp) -&gt; prp.
</pre>

Our representation of syntax allows us to express &#8220;exotic&#8221; propositional functions `p : ty -> prp` in which the logical structure of `p x` may depend on `x`. Because of this phenomenon we will be forced later on to introduce certain type dependencies where there are none in the usual Dialectica interpretation.

Convenient notation for the object language.

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">Notation "'[' p ']'" := (primitive p) (at level 80, no associativity).
Notation "'neg' x" := (negation x) (at level 70, no associativity).
Notation "x 'and' y" := (conjunction x y) (at level 74, left associativity).
Notation "x 'or' y" := (disjunction x y) (at level 76, left associativity).
Notation "x ==&gt; y" := (implication x y) (at level 78, right associativity).
Notation "'all' x : t , p" :=  (@universal t (fun x =&gt; p)) (at level 80, x at level 99).
Notation "'some' x : t , p" :=  (@existential t (fun x =&gt; p)) (at level 80, x at level 99).
</pre>

With each proposition `p` we associate the types `W p` and `C p` of &#8220;witnesses&#8221; and &#8220;counters&#8221;, respectively. Think of them as moves in a game between a player `W` and an opponent `C`. We make two changes to the standard Dialectica representation:

  1. First, we use sum for counters of conjunctions, where normally a product is used. This gives us symmetry between conjunction and disjunction, simplifies the notorious conjunction contraction `and_contr`, but complicates the adjunction between implication and conjunction. Thomas Streicher pointed out that the change is inessential in the sense that we could prove a separate lemma which allows us to pass from counters for `p and q` as pairs to counters as elements of a sum (such a lemma relies in decidability of the `dia` relation defined below).
  2. Second, because the structure of a propositional function is allowed to depend on its argument, we are forced to introduce type dependency into `W p` and `C p` when `p` is a quantified statement. This is not a big surprise, but what is a little more surprising is that the counters for existentials, `C (existential ty p')`, involve a dependency not only on `ty` but also on `W (p' x)`. The dependency is needed in the rule `exists_elim`. The rest of Dialectica interpetation is not influenced by this change, with the exception of the Independence of Premise where we have to impose a condition that is not required in the usual interpretation. 
    These type-dependecies clearly points towards an even more type-dependent Dialectica variant. Indeed, we are going to investigate it in a separate file. For now we are just trying to faithfully represent the Dialectica interpretation.</li> </ol> 
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Fixpoint W (p : prp) :=
  (match p with
     | primitive p =&gt; unit
     | conjunction p1 p2 =&gt; (W p1) * (W p2)
     | disjunction p1 p2 =&gt; (W p1) + (W p2)
     | implication p1 p2 =&gt; (W p1 -&gt; W p2) * (W p1 * C p2 -&gt; C p1)
     | negation p' =&gt; (W p' -&gt; C p')
     | universal ty p' =&gt; (forall x : ty, W (p' x))
     | existential ty p' =&gt; { x : ty & W (p' x) }
   end)%type

with C p : Set :=
  (match p with
     | primitive p =&gt; unit
     | conjunction p1 p2 =&gt; (C p1) + (C p2)
     | disjunction p1 p2 =&gt; (C p1) * (C p2)
     | implication p1 p2 =&gt; (W p1) * (C p2)
     | negation p' =&gt; W p'
     | universal ty p' =&gt; { x : ty & C (p' x) }
     | existential ty p' =&gt; (forall x : ty, W (p' x) -&gt; C (p' x))
   end)%type.
</pre>
    
    The relation `dia p w c` is what is usually written as $p_D(w,c)$ in the Dialectica interpretation, i.e., the matrix of the interpreted formula.
    
    In terms of games, `dia p w c` tells whether the player move `w` wins against the opponent move `c` in the game determined by the proposition `p`.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Fixpoint dia (p : prp) : W p -&gt; C p -&gt; Prop :=
  match p return W p -&gt; C p -&gt; Prop with
    | primitive p =&gt; (fun _ _ =&gt; Is_true p)
    | conjunction p1 p2 =&gt;
      (fun a b =&gt; match b with
                    | inl b1 =&gt; dia p1 (fst a) b1
                    | inr b2 =&gt; dia p2 (snd a) b2
                  end)
    | disjunction p1 p2 =&gt;
        (fun a b =&gt; match a with
                      | inl x =&gt; dia p1 x (fst b)
                      | inr u =&gt; dia p2 u (snd b)
                    end)
    | implication p1 p2 =&gt;
        (fun a b =&gt; dia p1 (fst b) (snd a b) -&gt; dia p2 (fst a (fst b)) (snd b))
    | negation p' =&gt;
        (fun a b =&gt; ~ dia p' b (a b))
    | universal t p' =&gt;
        (fun a b =&gt; dia (p' (projT1 b)) (a (projT1 b)) (projT2 b))
    | existential t p' =&gt;
        (fun a b =&gt; dia (p' (projT1 a)) (projT2 a) (b (projT1 a) (projT2 a)))
  end.
</pre>
    
    The `dia` relation is decidable. This fact is used only in the adjunction between conjunction and implication.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Theorem dia_decidable (p : prp) (a : W p) (b : C p) : {dia p a b} + {not (dia p a b)}.
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
</pre>
    
    Of course, a decidable proposition is stable for double negation.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Lemma dia_not_not_stable (p : prp) (w : W p) (c : C p) : ~ ~ dia p w c -&gt; dia p w c.
Proof.
  intros p w c H.
  destruct (dia_decidable p w c); tauto.
Qed.
</pre>
    
    The types `W` and `C` are always inhabited because we restrict quantifiers to inhabited types.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Definition WC_member (p : prp) : W p * C p.
  induction p; unfold W; unfold C; simpl; fold W; fold C; split; try firstorder.
  exact (member ty0).
  exact (member ty0).
Defined.

Definition W_member (p : prp) := fst (WC_member p).
Definition C_member (p : prp) := snd (WC_member p).
</pre>
    
    The predicate `valid p` is the Dialectica interpretation of `p`. It says that there is `w` such that `dia p w c` holds for any `c`. In terms of games semantics this means that `W` has a winning strategy (which amounts to a winning move `w`).
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Definition valid (p : prp) := { a : W p | forall b : C p, dia p a b }.
</pre>
    
    ### Validity of inference rules
    
    We now verify that the Hilbert-style axioms for first-order logic are validated by our interpretation. We follow Avigad & Feferman.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Theorem modus_ponens (p q : prp) : valid p -&gt; valid (p ==&gt; q) -&gt; valid q.
Proof.
  unfold valid,  W, C; simpl; fold W; fold C; simpl.
  intros p q [wp H] [[u v] G].
  simpl in G.
  exists (u wp).
  intro b.
  apply (G (wp, b)); simpl.
  apply H.
Qed.

Theorem impl_chain (p q r : prp) : valid (p ==&gt; q) -&gt; valid (q ==&gt; r) -&gt; valid (p ==&gt; r).
Proof.
  unfold valid,  W, C; simpl; fold W; fold C; simpl.
  intros p q r [[a b] H] [ G].
  exists (fun w =&gt; c (a w), fun v =&gt; b (fst v, d (a (fst v), snd v))).
  simpl in H.
  simpl in G.
  simpl.
  intros g I.
  apply (G (a (fst g), snd g)); simpl.
  apply (H (fst g, d (a (fst g), snd g))); simpl.
  assumption.
Qed.

Theorem or_contr (p : prp) : valid (p or p ==&gt; p).
Proof.
  intros p.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (fun x =&gt; (match x with inl a =&gt; a | inr a =&gt; a end), fun x =&gt; (snd x, snd x)); simpl.
  intros [u v]; simpl.
  destruct u; auto.
Qed.
</pre>
    
    In the following theorem we avoid decidability of `dia` because we defined counters of conjunctions as sums.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Theorem and_contr (p : prp) : valid (p ==&gt; p and p).
Proof.
  intros p.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (fun x =&gt; (x,x),
          fun y =&gt; match snd y with
                     | inl c =&gt; c
                     | inr c =&gt; c
                   end); simpl.
  intros [u [v1|v2]] H; auto.
Qed.

Theorem or_introl (p q : prp) : valid (p ==&gt; p or q).
Proof.
  intros p q.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (fun x =&gt; @inl _ _ x, fun y =&gt; fst (snd y)).
  auto.
Qed.

Theorem and_eliml (p q : prp) : valid (p and q ==&gt; p).
Proof.
  intros p q.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (@fst _ _, fun y =&gt; @inl _ _ (snd y)).
  tauto.
Qed.

Theorem or_comm (p q : prp) : valid (p or q ==&gt; q or p).
Proof.
  intros p q.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (fun x =&gt; match x with inl a =&gt; @inr _ _ a | inr b =&gt; @inl _ _ b end,
          fun y =&gt; (snd (snd y), fst (snd y))); simpl.
  intros [u [v w]]; simpl.
  destruct u; auto.
Qed.

Theorem and_comm (p q : prp) : valid (p and q ==&gt; q and p).
Proof.
  intros p q.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (fun x =&gt; (snd x, fst x), 
          fun y =&gt; match snd y with
                     | inl c =&gt; @inr _ _ c
                     | inr c =&gt; @inl _ _ c
                   end).
  intros [[a1 a2] [b1|b2]]; auto.
Qed.

Theorem or_distr (p q r : prp) : valid (p ==&gt; q) -&gt; valid (r or p ==&gt; r or q).
Proof.
  intros p q r.
  unfold valid, C, W; simpl; fold C; fold W.
  intros [[a b] H].
  simpl in H.
  exists (fun x =&gt; match x with inl t =&gt; @inl _ _ t | inr u =&gt; @inr _ _ (a u) end,
          fun y =&gt; match fst y with
                     | inl i =&gt; (fst (snd y), b (W_member p, snd (snd y)))
                     | inr j =&gt; (fst (snd y), b (j, snd (snd y)))
                   end).
  intros ]; simpl.
  destruct c; auto.
  intro G.
  apply (H (w, e)); simpl.
  apply G.
Qed.
</pre>
    
    The next two theorems verify the adjunction between conjunction and implication. This is where we need decidability of `dia p w c` and inhabitation of `W` and `C`.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Theorem impl_conj_adjunct1 (p q r : prp) : valid (p ==&gt; (q ==&gt; r)) -&gt; valid (p and q ==&gt; r).
Proof.
  intros p q r.
  unfold valid, C, W; simpl; fold C; fold W.
  intros [[a b] H].
  simpl in H.
  eexists (fun x =&gt; fst (a (fst x)) (snd x),
          fun (y : W p * W q * C r) =&gt;
            let (wp, wq) := fst y in 
            let cr := snd y in
            if dia_decidable q wq (snd (a wp) (wq, cr))
            then @inl _ _ (b (wp, (wq, cr)))
            else @inr _ _ (snd (a wp) (wq, cr))).
  simpl.
  intros [ e].
  simpl.
  destruct (dia_decidable q d (snd (a c) (d,e))) as [D1 | D2].
  intro G.
  apply (H (c, (d, e))); auto.
  intro G.
  contradiction.
Qed.

Theorem impl_conj_adjunct2 (p q r : prp) : valid (p and q ==&gt; r) -&gt; valid (p ==&gt; (q ==&gt; r)).
Proof.
  intros p q r.
  unfold valid, C, W; simpl; fold C; fold W.
  intros [[a b] H]; simpl in H.
  exists (fun x =&gt; (fun u =&gt; a (x, u), fun v =&gt; match b ((x, fst v), snd v) with
                                                  | inl c =&gt; C_member q
                                                  | inr d =&gt; d
                                                end),
          fun y =&gt; match b ((fst y, fst (snd y)), snd (snd y)) with
                     | inl c =&gt; c
                     | inr d =&gt; C_member p
                   end).
  simpl.
  intros [u [v w]]; simpl.
  intros F G.
  apply (H (u, v, w)).
  destruct (b (u, v, w)); auto.
Qed.

Theorem false_elim (p : prp) : valid ([false] ==&gt; p).
Proof.
  intros p.
  unfold valid, C, W; simpl; fold C; fold W.
  exists ((fun _ =&gt; W_member p), (fun _ =&gt; tt)).
  intros [u v] G.
  contradiction.
Qed.
  
Theorem forall_intro (ty : Inhabited) (p : prp) (q : ty -&gt; prp) :
  (forall x : ty, valid (p  ==&gt; q x)) -&gt; valid (p ==&gt; all x : ty, q x).
Proof.
  intros t p q.
  unfold valid, C, W; simpl; fold C; fold W.
  intros H.
  exists ((fun u x =&gt; fst (projT1 (H x)) u),
          (fun (y : (W p * {x : t & C (q x)})) =&gt;
           snd (projT1 (H (projT1 (snd y)))) (fst y, projT2 (snd y)))).
  intros [u [x v]].
  simpl.
  intros G.
  apply (projT2 (H x) (u, v)).
  auto.
Qed.

Theorem forall_elim (ty : Inhabited) (a : ty) (p : ty -&gt; prp) :
  valid ((all x : ty, p x) ==&gt; p a).
Proof.
  intros t a p.
  unfold valid, C, W; simpl; fold C; fold W.
  exists ((fun f =&gt; f a), (fun y =&gt; existT _ a (snd y))); auto.
Qed.

Theorem exists_intro (ty : Inhabited) (a : ty) (p : ty -&gt; prp) :
  valid (p a ==&gt; some x : ty, p x).
Proof.
  intros t a p.
  unfold valid, C, W; simpl; fold C; fold W.
  exists ((fun x =&gt; existT _ a x),
          (fun y =&gt; snd y a (fst y))); auto.
Qed.
</pre>
    
    This is the rule in which we need the dependency of counters in existential statements.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Theorem exists_elim (ty : Inhabited) (p : ty -&gt; prp) (q : prp) :
  (forall x : ty, valid (p x ==&gt; q)) -&gt; valid ((some x : ty, p x) ==&gt; q).
Proof.
  intros t p q.
  unfold valid, C, W; simpl; fold C; fold W.
  intros H.
  exists ((fun (u : {x : t & W (p x)}) =&gt; fst (projT1 (H (projT1 u))) (projT2 u)),
          (fun v x w =&gt; snd (projT1 (H x)) (w, snd v))).
  simpl.
  intros [[x u] v]; simpl.
  intro G.
  apply (projT2 (H x) (u, v)).
  simpl.
  apply G.
Qed.
</pre>
    
    ### Equality
    
    Next we verify the rules of equality. To keep things simple we only consider equality of natural numbers. In the general case we could consider decidable equality on an inhabited type.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Definition prpEq (m n : N) := [beq_nat m n].
</pre>
    
    Dialectica equality implies equality.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Theorem prpEq_eq (m n : N) : valid (prpEq m n) -&gt; m = n.
Proof.
  unfold prpEq, valid; simpl; fold valid.
  intros m n [_ H].
  assert (G := H tt).
  apply beq_nat_true.
  apply Is_true_eq_true.
  assumption.
Qed.
</pre>
    
    Equality implies Dialectica equality, of course, but notice how complicated the proofs seems to be. We could move the complication into `prpEq_refl` below.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Theorem eq_prpEq (m n : N) : m = n -&gt; valid (prpEq m n).
Proof.
  intros m n E.
  rewrite E.
  exists tt.
  intro b.
  unfold dia; simpl; fold dia.
  apply Is_true_eq_right.
  apply (beq_nat_refl n).
Qed.
</pre>
    
    Reflexivity.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Theorem prpEq_refl (n : N) : valid (prpEq n n).
Proof.
  intros n.
  apply eq_prpEq.
  reflexivity.
Qed.
</pre>
    
    Leibniz&#8217;s law as a rule of inference.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Theorem leibniz_rule (p : N -&gt; prp) (m n : N) :
  valid (prpEq m n) -&gt; valid (p m) -&gt; valid (p n).
Proof.
  unfold valid, C, W; simpl; fold C; fold W.
  intros p m n [a H] [b G].
  assert (E := H tt).
  apply Is_true_eq_true in E.
  apply beq_nat_true in E.
  rewrite &lt;- E.
  exists b.
  assumption.
Qed.
</pre>
    
    Proving Leibniz&#8217;s law as a proposition is more complicated because of type dependency that is not present in the usual Dialectica interpretation.
    
    In fact, it looks like we need UIP (Uniqueness of Identity Proofs) for natural numbers, which luckily holds since the natural numbers are decidable. Below we prove UIP for N. Coq 8.3 contains a more general proof of UIP for decidable types, see [`Logic.Eqdep_dec`](http://coq.inria.fr/stdlib/Coq.Logic.Eqdep.html).
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Definition eqN_compose (k m n : N) (p : k = m) (q : k = n) : m = n.
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

Lemma eqN_decidable (m n : N) : {m = n} + {m &lt;&gt; n}.
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

Definition W_transfer (p : N -&gt; prp) (m n : N) : W (p m) -&gt; W (p n).
Proof.
  intros p m n w.
  destruct (eqN_decidable m n) as [E1 | E2].
  rewrite &lt;- E1.
  exact w.
  exact (W_member ((p n))).
Defined.

Definition C_transfer (p : N -&gt; prp) (m n : N) : C (p m) -&gt; C (p n).
Proof.
  intros p m n c.
  destruct (eqN_decidable m n) as [E1 | E2].
  rewrite &lt;- E1.
  exact c.
  exact (C_member ((p n))).
Defined.
</pre>
    
    Finally, the validity of Leibniz&#8217;s law is proved. If someone knows a shortcut, I would like to know about it.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Theorem leibniz (p : N -&gt; prp) (m n : N) : valid (prpEq m n ==&gt; p m ==&gt; p n).
Proof.
  intros p m n.
  unfold valid, C, W; simpl; fold C; fold W.
  exists ((fun tt =&gt; ((fun (w : W (p m)) =&gt; W_transfer p m n w),
                      (fun y =&gt; C_transfer p n m (snd y)))),
          (fun _ =&gt; tt)).
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
</pre>
    
    ### Natural numbers
    
    Next we verify that the natural numbers obey Peano axioms. They are easy, except for induction which has two parts: the usual &#8220;forward&#8221; direction by primitive recursion, and a &#8220;backwards&#8221; direction in which we search for a counter-example, starting from an upper bound and going down to 0.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Theorem nat_zero_not_succ (n : nat) :
  valid (neg (prpEq (S n) 0)).
Proof.
  intro n.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (fun tt =&gt; tt); auto.
Qed.

Theorem succ_injective (m n : nat) :
  valid (prpEq (S m) (S n) ==&gt; prpEq m n).
Proof.  
  intros m n.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (fun _ =&gt; tt, fun _ =&gt; tt); auto.
Qed.
</pre>
    
    Given a propositional function `p : nat -> prp`, suppose `p m` is not valid. Then `p 0` is not valid, or one of induction steps `p k ==> p (S k)` fails. The &#8220;backwards&#8221; direction of the Dialectica interpretation of induction is a search functional which looks for a failed base case or failed induction step. We construct it separately from the main proof.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Definition search (p : N -&gt; prp) (m : N) :
  W (p 0) -&gt;
  (forall k : N, W (p k) -&gt; W (p (S k))) -&gt;
  (forall k : N, W (p k) * C (p (S k)) -&gt; C (p k)) -&gt;
  C (p m) -&gt;
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
</pre>
    
    Finally we verify validity of induction.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Theorem N_induction (p : nat -&gt; prp) (m : nat) :
  valid (p 0 and (all n : N, p n ==&gt; p (S n)) ==&gt; p m).
Proof.
  intros p m.
  unfold valid, C, W; simpl; fold C; fold W.
  exists (fun x =&gt; nat_rect _ (fst x) (fun k =&gt; fst (snd x k)) m,
          fun y =&gt; search p m (fst (fst y))
                     (fun k =&gt; fst (snd (fst y) k))
                     (fun k =&gt; snd (snd (fst y) k))
                     (snd y)).
  simpl.
  intros [[z h] c]; simpl.
  set (s := fun k : nat =&gt; fst (h k)).
  set (b := fun k : nat =&gt; snd (h k)).
  induction m; auto.
  unfold search; simpl.
  set (w := nat_rect (fun k : nat =&gt; W (p k)) z s m).
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
</pre>
    
    Having done ordinary induction one is tempted to try validating induction for W-types&#8230; but not here.
    
    ### Markov Principle and Independence of Premise
    
    The Dialectica interpretation is characterized by two non-intuitionistic reasoning principles, namely [Markov principle](http://en.wikipedia.org/wiki/Markov%27s_principle) (MP) and [Independence of Premise](http://en.wikipedia.org/wiki/Independence_of_premise) (IP).
    
    Both MP and IP involve primitive propositional function `N -> bool`. The point of these is that their `W` and `C` types are the unit. So instead of actually using primitive proposition, we shall use arbitrary propositions whose `W` and `C` types are singletons. First we make the relevant definitions.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Definition singleton (t : Inhabited) := forall x, x = member t.

Definition trivial_C (p : prp) := singleton (inhabit (C_member p)).
Definition trivial_W (p : prp) := singleton (inhabit (W_member p)).
</pre>
    
    Primitive propositions are trivial, of course.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Lemma primitive_trivial_W (b : bool) : trivial_W ([b]).
Proof.
  intros b w.
  case w; auto.
Qed.

Lemma primitive_trivial_C (b : bool) : trivial_C ([b]).
Proof.
  intros b c.
  case c; auto.
Qed.
</pre>
    
    Whether there are trivial propositions, other than the primitive ones, depends on what extra axioms we have available. For example, in the presence of extensionality of functions, implications and negations of trivial propositions are trivial. We do not dwell on the exact conditions that give us trivial propositions, but only demonstrate how to use extensionality of functions whose codomain is a singleton set to derive triviality of implication of trivial propositions.
    
    Is there a better way of getting the next lemma?
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Lemma pair_equal (X Y : Set) (p q : X * Y) :
  fst p = fst q -&gt; snd p = snd q -&gt; p = q.
Proof.
  intros X Y p q G H.
  induction p; induction q.
  simpl in G; simpl in H.
  rewrite G; rewrite H.
  reflexivity.
Qed.
</pre>
    
    We are only interested in extensionality of functions `s -> t` for which `t` is a singleton. Such extensionality can be phrased as &#8220;any power of a singleton is a singleton&#8221;.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Definition singleton_power :=
  forall t, singleton t -&gt; forall s : Set, singleton (inhabit (fun _ : s =&gt; member t)).
</pre>
    
    I _think_ there is no way of proving `singleton_power`, is there? We can use it to show that `W (p ==> q)` is trivial if `C p` and `W q` are trivial.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Lemma implication_trivial_W (p q : prp) :
  singleton_power -&gt; trivial_C p -&gt; trivial_W q -&gt; trivial_W (p ==&gt; q).
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
</pre>
    
    Triviality of `C (p ==> q)` does not require any extra assumptions.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Lemma implication_trivial_C (p q : prp) :
  trivial_W p -&gt; trivial_C q -&gt; trivial_C (p ==&gt; q).
Proof.
  intros p q TWp TCq.
  unfold trivial_C.
  unfold C, W; simpl; fold C; fold W.
  intros [wp cq].
  rewrite (TWp wp).
  rewrite (TCq cq).
  apply pair_equal; auto.
Qed.
</pre>
    
    #### Markov principle
    
    Markov principle holds for any inhabited type (not just the natural numbers) and a proposition which has trivial `W` and `C` types.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Theorem markov_generalized (t : Inhabited) (p : t -&gt; prp) :
  (forall x, trivial_C (p x)) -&gt;
  (forall x, trivial_W (p x)) -&gt;
  valid (neg (all x : t, neg (p x)) ==&gt; some x : t, p x).
Proof.
  intros t p TC TW.
  unfold valid, C, W; simpl; fold C; fold W.
  pose (u := fun (h : _ -&gt; {x : t & W (p x)})  =&gt;
    let y := projT1 (h (fun x (_ : W (p x)) =&gt; C_member (p x))) in
      existT (fun x : t =&gt; W (p x)) y (W_member (p y))).
  exists (u, fun _ x _ =&gt; C_member (p x)); simpl.
  intros [f g].
  simpl.
  set (v := projT1 (f (fun x _ =&gt; C_member (p x)))).
  set (w := projT2 (f (fun (x : t) (_ : W (p x)) =&gt; C_member (p x)))).
  rewrite (TC v (g v (W_member (p v)))).
  rewrite (TW v w).
  apply dia_not_not_stable.
Qed.
</pre>
    
    The usual Markov principle now follows easily.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Theorem markov (p : N -&gt; bool) :
  valid (neg (all n : N, neg [p n]) ==&gt; some n : N, [p n]).
Proof.
  intro p.
  apply markov_generalized with (t := N) (p := fun (n : N) =&gt; [p n]).
  intro; apply primitive_trivial_C.
  intro; apply primitive_trivial_W.
Qed.
</pre>
    
    #### The Independence of Premise
    
    The usual IP relates a _decidable_ propositional function $p$ and an _arbitrary_ one $q$:
    
    > $((\forall x . p(x)) \Rightarrow \exists y . q(y)) \Rightarrow \exists y . (\forall x . p(x)) \Rightarrow q(y)$
    
    It is possible to generalize the primitive $p$ to `p : s -> prp` with trival `W (p x)`. On the other hand, the type-dependencies force us to require that `C (q y)` be trivial. The proof below is unnecessarily complicated towards the end because I hit against [a bug in `rewrite`](http://coq.inria.fr/bugs/show_bug.cgi?id=2061).
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Theorem ip_generalized (s t : Inhabited) (p : s -&gt; prp) (q : t -&gt; prp) :
  (forall (x : s), trivial_W (p x)) -&gt;
  (forall (y : t), trivial_C (q y)) -&gt;
  valid (((all x : s, p x) ==&gt; some y : t, q y) ==&gt; some y : t, (all x : s, p x) ==&gt; q y).
Proof.
  intros s t p q TW TC.
  unfold valid, C, W; simpl; fold C; fold W.
  pose (u := fun (x : s) =&gt; W_member (p x)).
  pose (v := fun (y : t) (w : W (q y)) =&gt; C_member (q y)).
  refine (existT _
          ((fun a =&gt; existT _ (projT1 (fst a u)) (fun _ =&gt; projT2 (fst a u),
                                                 (fun b =&gt; snd a (u, v)))),
           (fun _ =&gt; (u,v)))
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
  replace (u z) with (fst (h y (fun _ : forall x : s, W (p x) =&gt; projT2 (f u),
                                fun _ : (forall x : s, W (p x)) * C (q y) =&gt; g (u, v))) z).
  assumption.
  transitivity (member (inhabit (W_member (p z)))); apply (TW z).
Qed.
</pre>
    
    A special case of our IP occurs when `p` is a primitive propositional function.
    
    <pre class="brush: plain; gutter: false; title: ; notranslate" title="">Theorem ip (s t : Inhabited) (p : s -&gt; bool) (q : t -&gt; prp) :
  (forall (y : t), trivial_C (q y)) -&gt;
  valid (((all x : s, [p x]) ==&gt; some y : t, q y) ==&gt; some y : t, (all x : s, [p x]) ==&gt; q y).
Proof.
  intros s t p q TC.
  apply ip_generalized.
  intro; apply primitive_trivial_W.
  intro; apply TC.
Qed.
</pre>
    
    This concludes the verification of the Dialectica interpretation in Coq. There are at least three interesting directions to go:
    
      1. Extract programs from the Dialectica interpretation. It looks like this could be done for extraction into Scheme. Extraction into Haskell and Ocaml seem more complicated because the `W` and `C` types are dependent and there seems no easy way of translating them into a simply-typed programming language. Presumably, concrete examples could be extracted with the help of &#8220;`Extraction Inline W C.`&#8220;.
      2. Explore other variants, such as the Diller-Nahm interpretation, or perhaps the interpretations a la [Ulrich Kohlenbach](http://www.mathematik.tu-darmstadt.de/~kohlenbach/) and [Paulo Oliva](http://www.eecs.qmul.ac.uk/~pbo/).
      3. Explore the possibility of having a fully dependent Dialectica interpretation. Initial investigations by [Thomas Streicher](http://www.mathematik.tu-darmstadt.de/~streicher/) and myself indicate that it can be done. This could give us a way of constructing a two-level type system that validates MP and IP.
