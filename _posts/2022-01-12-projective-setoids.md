---
title: Is every projective setoid isomorphic to a type?
author: Andrej Bauer
layout: post
categories:
  - Constructive math
  - Type theory
  - Formalization
---

[Jacques Carette](https://t.co/pr2rfOaFQ8) [asked on Twitter](https://twitter.com/jjcarett2/status/1478883775555723267?s=20) for a refence to the fact that countable choice holds in setoids. I then spent a day formalizing [facts about the axiom of choice in setoids](https://gist.github.com/andrejbauer/65ee1ae98167e6411e512d3e5a36c086#file-setoidchoice-agda) in Agda. I noticed something interesting that is worth blogging about.

<!--more-->

We are going to work in pure Martin-Löf type theory and the straightforward propostions-as-types interpretation of logic, so no univalence, propostional truncation and other goodies are available. Our primary objects of interest are [setoids](https://en.wikipedia.org/wiki/Setoid), and [Agda's setoids](https://agda.github.io/agda-stdlib/Relation.Binary.Bundles.html#1009) in particular. 
The content of the post has been formalized in [this gist](https://gist.github.com/andrejbauer/65ee1ae98167e6411e512d3e5a36c086). I am not going to bother to reproduce here the careful tracking of universe levels that the formalization carries out (because it must).


In general, a type, set, or an object $X$ of some sort is said to **satisfy choice** when every total relation $R \subseteq X \times Y$ has a choice function:
$$(\forall x \in X . \exists y \in Y . R(x,y)) \Rightarrow \exists f : X \to Y . \forall x \in X . R(x, f\,x). \tag{AC}$$
In Agda this is transliterated for a setoid $A$ as follows:


    satisfies-choice : ∀ c' ℓ' r → Set (c ⊔ ℓ ⊔ suc c' ⊔ suc ℓ' ⊔ suc r)
    satisfies-choice c' ℓ' r = ∀ (B : Setoid c' ℓ') (R : SetoidRelation r A B) →
                                 (∀ x → Σ (Setoid.Carrier B) (rel R x)) → Σ (A ⟶ B) (λ f → ∀ x → rel R x (f ⟨$⟩ x))


Note the long arrow in `A ⟶ B` which denotes **setoid maps**, i.e., the choice map $f$ must respect the setoid equivalence relations $\sim_A$ and $\sim_B$.

A category theorist would instead prefer to say that $A$ satisfies choice if every epi $e : B \to A$ splits:
$$(\forall B . \forall e : B \to A . \text{$e$ epi} \Rightarrow \exists s : A \to B . e \circ s = \mathrm{id}_A. \tag{PR}.$$
Such objects are known as *projective*. The Agda code for this is


    surjective : ∀ {c₁ ℓ₁ c₂ ℓ₂} {A : Setoid c₁ ℓ₁} {B : Setoid c₂ ℓ₂} → A ⟶ B → Set (c₁ ⊔ c₂ ⊔ ℓ₂)
    surjective {B = B} f = ∀ y → Σ _ (λ x → Setoid._≈_ B (f ⟨$⟩ x) y)
    
    split : ∀ {c₁ ℓ₁ c₂ ℓ₂} {A : Setoid c₁ ℓ₁} {B : Setoid c₂ ℓ₂} → A ⟶ B → Set (c₁ ⊔ ℓ₁ ⊔ c₂ ⊔ ℓ₂)
    split {A = A} {B = B} f = Σ (B ⟶ A) (λ g → ∀ y → Setoid._≈_ B (f ⟨$⟩ (g ⟨$⟩ y)) y)
    
    projective : ∀ c' ℓ' → Set (c ⊔ ℓ ⊔ suc c' ⊔ suc ℓ')
    projective c' ℓ' = ∀ (B : Setoid c' ℓ') (f : B ⟶ A) → surjective f → split f

(If anyone can advise me how to to avoid the ugly `Setoid._≈_ B` above using just what is available in the standard library, please do. I know how to introduce my own notation, but why should I?)

Actually, the above code uses surjectivity in place of being epimorphic, so we should verify that the two notions coincide in setoids, which is done in [`Epimorphism.agda`](https://gist.github.com/andrejbauer/65ee1ae98167e6411e512d3e5a36c086#file-epimorphism-agda). The human proof goes as follows, where we write $=_A$ or just $=$ for the equivalence relation on a setoid $A$.


**Theorem:** *A setoid morphism $f : A \to B$ is epi if, and only if, $\Pi (y : B) . \Sigma (x : A) . f \, x =_B y$.*

*Proof.* (⇒) I [wrote up the proof on MathOverflow](https://mathoverflow.net/a/178804/1176). That one works for toposes, but is easy to transliterate to setoids, just replace the subobject classifier $\Omega$ with the setoid of propositions $(\mathrm{Type}, {\leftrightarrow})$.

(⇐) Suppose $\sigma : \Pi (y : B) . \Sigma (x : A) . f \, x =_B y$ and $g \circ f = h \circ f$ for some $g, h : B \to C$. Given any $y : B$ we have
$$g(y) =_C g(f(\mathrm{fst}(\sigma\, y))) =_C h(f(\mathrm{fst}(\sigma\, y))) =_C h(y).$$
QED.

Every type $T$ may be construed as a setoid $\Delta T = (T, \mathrm{Id}_T)$, which is [`setoid`](https://agda.github.io/agda-stdlib/Relation.Binary.Bundles.html#1615) in Agda.

Say that a setoid $A$ has **canonical elements** when there is a map $c : A \to A$ such that $x =_A y$ implies $\mathrm{Id}_A(c\,x , c\,y)$, and $c\, x =_A x$ for all $x : A$. In other words, the map $c$ takes each element to a canonical representative of its equivalence class. In Agda:

    record canonical-elements : Set (c ⊔ ℓ) where
      field
        canon : Carrier → Carrier
        canon-≈ : ∀ x → canon x ≈ x
        canon-≡ : ∀ x y → x ≈ y → canon x ≡ canon y

Based on my experience with realizability models, I always thought that the following were equivalent:

1. $A$ satisfies choice (AC)
2. $A$ is projective (PR)
3. $A$ is isomorphic to a some $\Delta T$
4. $A$ has canonical elements.

But there is a snag! The implication (2 ⇒ 3) seemingly requires extra conditions that I do not know how to get rid of. Before discussing these, let me just point out that [`SetoidChoice.agda`](https://gist.github.com/andrejbauer/65ee1ae98167e6411e512d3e5a36c086#file-setoidchoice-agda) formalizes (1 ⇔ 2) and (3 ⇒ 4 ⇒ 1) unconditionally. In particular any $\Delta T$ is projective.

The implication (2 ⇒ 3) I could prove under the additional assumption that the underlying type of $A$ is an h-set. Let us take a closer look.
Suppose $(A, {=_A})$ is a projective setoid. How could we get a type $T$ such that $A \cong \Delta T$? The following construction suggests itself. The setoid map

\begin{align}
  r &: (A, \mathrm{Id}_A) \to (A, {=_A})  \notag \\\\\\\\
  r &: x \mapsto x \notag
\end{align}

is surjective, therefore epi. Because $A$ is projective, the map splits, so we have a setoid morphism $s : (A, {=_A}) \to (A, \mathrm{Id}_A)$ such that $r \circ s = \mathrm{id}$. The endomap $s \circ r : A \to A$ is a choice of canonical representatives of equivalence classes of $(A, {=_A})$, so we expect $(A, {=_A})$ to be isomorphic to $\Delta T$ where
$$T = \Sigma (x : A) . \mathrm{Id}_A(s (r \, x), x).$$
The mediating isomorphisms are

\begin{align}
  i &: A \to T                              &   j &: T \to A \notag \\\\\\\\
  i &: x \mapsto (s (r \, x), \zeta \, x)   &   j &: (x, \xi) \mapsto x \notag
\end{align}

where $\zeta \, x : \mathrm{Id}(s (r (s (r \, x))), s (r \, x)))$ is constructed from the proof that $s$ splits $r$. This *almost* works! It is easy to verify that $j (i \, x) =_A x$, but then I got stuck on showing that $\mathrm{Id}_T(i (j (x, \xi), (x, \xi))$, which amounts to inhabiting
$$
  \mathrm{Id}_T((x, \zeta x), (x, \xi)). \tag{1}
$$
There is no a priori reason why $\zeta x$ and $\xi$ would be equal.
If $A$ is an h-set then we are done because they will be equal by fiat. But what do to in general? I do not know and I leave you with an open problem:

<center>
<b>Is every projective setoids isomorphic to a type?</b>
</center>

Egbert Rijke and I spent one tea-time thinking about producing a counter-example by using circles and other HoTT gadgets, but we failed. Just a word of warning: in HoTT/UF the map $1 \to S^1$ from the unit type to the circle is onto (in the HoTT sense) *but* $\Delta 1 \to \Delta S^1$ is *not* epi in setoids, because that would split $1 \to S^1$.

Here is an obvious try: use the propositional truncation and define
$$
T = \Sigma (x : A) . \\|\mathrm{Id}_A(s (r \, x), x) \\|.
$$
Now (1) does not pose a problem anymore. However, in order for $\Delta T$ to be isomorphic to $(A, {=_A})$ we will need to know that $x =_A y$ is an h-proposition for all $x, y : A$.

This is as far as I wish to descend into the setoid hell.

