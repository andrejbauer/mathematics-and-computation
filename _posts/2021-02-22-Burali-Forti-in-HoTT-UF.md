---
title: The Burali-Forti argument in HoTT/UF
author: Martin Escardo
layout: post
categories:
  - General
  - HoTT/UF
  - Constructive mathematics
---

This is joint work with [Marc Bezem](https://www.uib.no/en/persons/Marcus.Aloysius.Bezem), [Thierry Coquand](https://www.cse.chalmers.se/~coquand/), [Peter Dybjer](https://www.cse.chalmers.se/~peterd/).

We use the
[Burali-Forti](https://en.wikipedia.org/wiki/Burali-Forti_paradox)
argument to show that, in [homotopy type theory and univalent foundations](https://homotopytypetheory.org/),
the embedding $$ \mathcal{U} \to \mathcal{U}^+$$ of a universe
$\mathcal{U}$ into its successor $\mathcal{U}^+$ is not an
equivalence.  We also establish this for the types of sets, magmas, monoids and
groups. The arguments in this post are also [written](https://www.cs.bham.ac.uk/~mhe/TypeTopology/BuraliForti.html#Burali-Forti) in
[Agda](https://agda.readthedocs.io/en/v2.6.1.3/).

<!--more-->

#### Ordinals in univalent type theory

The Burali-Forti paradox is about the collection of all ordinals. In set theory, this collection cannot be a set, because it is too big, and this is what the Burali-Forti argument shows. This collection is a [proper class](https://en.wikipedia.org/wiki/Class_(set_theory)) in set theory.


In univalent type theory, we can collect all ordinals of a universe $\mathcal{U}$ in
a type $\operatorname{Ordinal}\,\mathcal{U}$ that lives in the
successor universe $\mathcal{U}^+$: $$
\operatorname{Ordinal}\,\mathcal{U} : \mathcal{U}^+.$$ See Chapter
10.3 of the [HoTT book](https://homotopytypetheory.org/book/), which
uses univalence to show that this type is a set in the sense of
univalent foundations (meaning that its equality is proposition valued).

The analogue in type theory of the notion of proper
class in set theory is that of [large
type](https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-Size.html#is-large),
that is, a type in a successor universe $\mathcal{U}^+$ that doesn't
have a copy in the universe $\mathcal{U}$. In this post we show that the type of ordinals is large and derive some consequences from this.

We have two further uses of univalence, at least:

1. to adapt the Burali-Forti argument from set theory to our type theory, and

1. to resize down the values of the order relation of the ordinal
   of ordinals, to conclude that the ordinal of ordinals is large.

There are also a number of uses of univalence via functional and
propositional extensionality.

[Propositional resizing](https://unimath.github.io/bham2017/UniMath_origins-present-future.pdf)
rules or axioms are not needed, thanks to (2).

An ordinal in a universe $\mathcal{U}$ is a type $X : \mathcal{U}$ equipped with a relation
$$ - \prec - : X \to X \to \mathcal{U}$$

required to be

1. proposition valued,

1. transitive,

1. extensional (any two points with same lower set are the same),

1. well founded (every element is accessible, or, equivalently, the
   principle of [transfinite
   induction](https://en.wikipedia.org/wiki/Transfinite_induction)
   holds).

The HoTT book additionally requires $X$ to be a set, but this [follows
automatically](https://www.cs.bham.ac.uk/~mhe/TypeTopology/OrdinalNotions.html#extensionally-ordered-types-are-sets) from the above requirements for the order.

The underlying type of an ordinal $\alpha$ is denoted by $\langle
\alpha \rangle$ and its order relation is denoted by $\prec_{\alpha}$ or simply $\prec$ when we believe the reader will be able to infer the missing subscript.

Equivalence of ordinals in universes $\mathcal{U}$ and $\mathcal{V}$,
$$    -\simeq_o- : \operatorname{Ordinal}\,\mathcal{U} \to \operatorname{Ordinal}\,\mathcal{V} \to \mathcal{U} \sqcup \mathcal{V},$$
means that there is an equivalence of the underlying types that
preserves and reflects order. Here we denote by $\mathcal{U} \sqcup \mathcal{V}$ the least upper bound of the two universes $\mathcal{U}$ and $\mathcal{V}$. The precise definition of the type theory we adopt here, including the handling of universes, can be found in [Section 2 of this paper](https://www.cambridge.org/core/journals/mathematical-structures-in-computer-science/article/injective-types-in-univalent-mathematics/AFCBBABE47F29ED7AFB4C262929D8810) and also in our [Midlands Graduate School 2019 lecture notes](https://www.cs.bham.ac.uk/~mhe/HoTT-UF-in-Agda-Lecture-Notes/index.html) in Agda form.

For ordinals $\alpha$ and $\beta$ in the **same** universe, their
identity type $\alpha = \beta$ is canonically equivalent to the
ordinal-equivalence type $\alpha \simeq_o \beta$, by univalence.

The lower set of a point $x : \langle \alpha \rangle$ is written
$\alpha \downarrow x$, and is itself an ordinal under the inherited
order. The ordinals in a universe $\mathcal{U}$ form an ordinal in the
successor universe $\mathcal{U}^+$, denoted by
$$ \operatorname{OO}\,\mathcal{U} : \operatorname{Ordinal}\,\mathcal{U}^+,$$
for [ordinal of ordinals](https://www.cs.bham.ac.uk/~mhe/TypeTopology/OrdinalOfOrdinals.html#OO).

Its underlying type is $\operatorname{Ordinal}\,\mathcal{U}$ and
its order relation is denoted by $-\triangleleft-$ and is defined by
$$\alpha \triangleleft \beta = \Sigma b : \langle \beta \rangle , \alpha = (\beta \downarrow b).$$

This order has type $$-\triangleleft- : \operatorname{Ordinal}\,\mathcal{U} \to
\operatorname{Ordinal}\,\mathcal{U} \to \mathcal{U}^+,$$ as required for it to make the
type $\operatorname{\operatorname{Ordinal}} \mathcal{U}$ into an ordinal in the next
universe.

By univalence, this order is equivalent to the
order defined by
$$\alpha \triangleleft^- \beta = \Sigma b : \langle \beta \rangle , \alpha \simeq_o (\beta \downarrow b).$$
This has the more general type
$$ -\triangleleft^-- : \operatorname{\operatorname{Ordinal}}\,\mathcal{U} \to \operatorname{\operatorname{Ordinal}}\,\mathcal{V} \to \mathcal{U} \sqcup \mathcal{V},$$
so that we can compare ordinals in different universes. But also when the universes $\mathcal{U}$ and $\mathcal{V}$ are the same, this order has values in $\mathcal{U}$ rather than $\mathcal{U}^+$. The existence of such a resized-down order is crucial for our
corollaries of Burali-Forti, but not for Burali-Forti itself.

For any $\alpha : \operatorname{Ordinal}\,\mathcal{U}$ we have
$$ \alpha \simeq_o (\operatorname{OO}\,\mathcal{U} \downarrow \alpha),$$
so that $\alpha$ is an initial segment of the ordinal of ordinals, and hence
$$ \alpha \triangleleft^- \operatorname{OO}\,\mathcal{U}.$$

#### The Burali-Forti theorem in HoTT/UF

We adapt the original formulation and argument from set theory.

> **Theorem**. No ordinal in a universe $\mathcal{U}$ can be equivalent to the ordinal of all ordinals in $\mathcal{U}$.

**Proof.** Suppose, for the [sake of
deriving
absurdity](http://math.andrej.com/2010/03/29/proof-of-negation-and-proof-by-contradiction/),
that there is an ordinal $\alpha \simeq_o \operatorname{OO}\,\mathcal{U}$ in the universe
$\mathcal{U}$.  By the above discussion, $\alpha \simeq_o \operatorname{OO}\,\mathcal{U} \downarrow
\alpha$, and, hence, by symmetry and transitivity, $\operatorname{OO}\,\mathcal{U} \simeq_o \operatorname{OO}\,\mathcal{U} \downarrow
\alpha$. Therefore, by univalence, $\operatorname{OO}\,\mathcal{U} = \operatorname{OO}\,\mathcal{U} \downarrow \alpha$. But this
means that $\operatorname{OO}\,\mathcal{U} \triangleleft \operatorname{OO}\,\mathcal{U}$, which is impossible as any accessible
relation is irreflexive. $\square$

Some corollaries follow.

#### The type of ordinals is large

We say that a type in the successor universe $\mathcal{U}^+$ is [**small**](https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-Size.html#is-small) if it is
equivalent to some type in the universe $\mathcal{U}$, and [**large**](https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-Size.html#is-large) otherwise.


> **Theorem**. The type of ordinals of any universe is large.


**Proof.** Suppose the type of ordinals in the universe $\mathcal{U}$
is small, so that there is a type $X : \mathcal{U}$ equivalent to the
type $\operatorname{Ordinal}\, \mathcal{U} : \mathcal{U}^+$. We can
then transport the ordinal structure from the type $\operatorname{Ordinal}\,
\mathcal{U}$ to $X$ along this equivalence to get an ordinal in
$\mathcal{U}$ equivalent to the ordinal of ordinals in $\mathcal{U}$,
which is impossible by the Burali-Forti theorem.

But the proof is not concluded yet, because we have to say how we transport the ordinal structure.  At first sight [we should be able to simply apply univalence](https://www.cs.bham.ac.uk/~mhe/TypeTopology/OrdinalsWellOrderTransport.html#transport-ordinal-structure). However, this is not possible because the types $X : \mathcal{U}$ and $\operatorname{Ordinal}\,\mathcal{U} :\mathcal{U}^+$ live in different universes. The problem is that only elements of the same type can be compared for equality.

1. In the cumulative universe hierarchy of the HoTT book, we
   automatically have that $X : \mathcal{U}^+$ and hence, being
   equivalent to the type $\operatorname{Ordinal}\,\mathcal{U} :
   \mathcal{U}^+$, the type $X$ is equal to the type
   $\operatorname{Ordinal}\,\mathcal{U}$ by univalence. But this
   equality is an element of an identity type of the universe
   $\mathcal{U}^+$. Therefore when we transport the ordinal structure
   on the type $\operatorname{Ordinal}\,\mathcal{U}$ to the type $X$
   along this equality and equip $X$ with it, we get an ordinal in the
   successor universe $\mathcal{U}^+$. But, in order to get the desired
   contradiction, we need to get an ordinal in $\mathcal{U}$.

1. In the non-cumulative universe hierarchy we adopt here, we face
   essentially the same difficulty. We cannot assert that $X :
   \mathcal{U}^+$ but we can promote $X$ to an equivalent type in the
   universe $\mathcal{U}^+$, and from this point on we reach the same
   obstacle as in the cumulative case.

So we have to transfer the ordinal structure from $\operatorname{Ordinal}\,\mathcal{U}$ to $X$ [manually](https://www.cs.bham.ac.uk/~mhe/TypeTopology/OrdinalsWellOrderTransport.html) along the given equivalence, call it
$$f : X \to \operatorname{Ordinal}\,\mathcal{U}.$$
We define the order of $X$ from that of $\operatorname{Ordinal}\,\mathcal{U}$ by
$$
x \prec y = f(x) \triangleleft f(y).
$$
It is [laborious but not hard to see](https://www.cs.bham.ac.uk/~mhe/TypeTopology/OrdinalsWellOrderTransport.html#transfer-structure) that this order satisfies the required axioms for making $X$ into an ordinal, except that it has values in $\mathcal{U}^+$ rather than $\mathcal{U}$. But this problem is solved by instead using the resized-down relation $\triangleleft^-$ discussed above, which is equivalent to $\triangleleft$ by univalence.
$\square$

#### There are more types and sets in $\mathcal{U}^+$ than in $\mathcal{U}$

By a [**universe embedding**](https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-UniverseEmbedding.html#is-universe-embedding) we mean a map
$$f : \mathcal{U} \to \mathcal{V}$$
of universes such that, for all $X : \mathcal{U}$,
$$f(X) \simeq X.$$ Of course, any two universe embeddings of $\mathcal{U}$ into $\mathcal{V}$ are equal,
by univalence, so that there is at most one universe embedding between
any two universes.  Moreover, universe embeddings [are automatically
type embeddings](https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-UniverseEmbedding.html) (meaning that they have propositional fibers).

So the following says that the universe $\mathcal{U}^+$ is strictly larger than the
universe $\mathcal{U}$:

> **Theorem.** The universe embedding $\mathcal{U} \to \mathcal{U}^+$ doesn't have a section and therefore is not an equivalence.

**Proof.** A section would give a type in the universe $\mathcal{U}$ equivalent to the type of ordinals in $\mathcal{U}$, but we have seen that there is no such type. $\square$

(However, by Theorem 29 of [Injective types in univalent mathematics](https://www.cambridge.org/core/journals/mathematical-structures-in-computer-science/article/injective-types-in-univalent-mathematics/AFCBBABE47F29ED7AFB4C262929D8810), if propositional resizing holds then the universe embedding $\mathcal{U} \to \mathcal{U}^+$
[is a section](https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-Size.html#Lift-is-section).)

The same argument of the above theorem shows that there are more sets
in $\mathcal{U}^+$ than in $\mathcal{U}$, because the type of ordinals
is a set. For a universe $\mathcal{U}$ define the type
$$\operatorname{hSet}\,\mathcal{U} : \mathcal{U}^+$$
by
$$ \operatorname{hSet}\,\mathcal{U} = Σ A : \mathcal{U} , \text{$A$ is a set}.$$
By an [**hSet embedding**](https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-UniverseEmbedding.html#is-hSet-embedding) we mean a map
$$f : \operatorname{hSet}\,\mathcal{U} → \operatorname{hSet}\,\mathcal{V}$$
such that the underlying type of $f(\mathbb{X})$ is equivalent to the underlying type of $\mathbb{X}$ for every $\mathbb{X} : \operatorname{hSet}\,\mathcal{U}$, that is,
$$
\operatorname{pr_1} (f (\mathbb{X})) ≃ \operatorname{pr_1}(\mathbb{X}).
$$
Again [there is at most one hSet-embedding](https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-UniverseEmbedding.html#at-most-one-hSet-embedding) between any two universes, hSet-embeddings are type embeddings, and we have:

> **Theorem.** The hSet-embedding $\operatorname{hSet}\,\mathcal{U} \to \operatorname{hSet}\,\mathcal{U}^+$ doesn't have a section and therefore is not an equivalence.


#### There are more magmas and monoids in $\mathcal{U}^+$ than in $\mathcal{U}$

This is because the type of ordinals is a monoid under
addition with the ordinal zero as its neutral element, and hence also a magma.  If the
inclusion of the type of magmas (respectively monoids) of one universe into that of the
next were an equivalence, then we would have a small copy of the type of ordinals.

> [**Theorem.**](https://www.cs.bham.ac.uk/~mhe/TypeTopology/BuraliForti.html) The canonical embeddings $\operatorname{Magma}\,\mathcal{U} → \operatorname{Magma}\,\mathcal{U}^+$ and $\operatorname{Monoid}\,\mathcal{U} → \operatorname{Monoid}\,\mathcal{U}^+$ don't have sections and hence are not equivalences.

#### There are more groups in $\mathcal{U}^+$ than in $\mathcal{U}$

This case is more interesting.

The axiom of choice is equivalent to the statement that [any non-empty set can
be given the structure of a
group](https://en.wikipedia.org/wiki/Group_structure_and_the_axiom_of_choice). So
if we assumed the axiom of choice we would be done. But we are brave
and work without assuming excluded middle, and hence without choice.


It is also  the case that [the type of propositions can be given the structure of a group](https://homotopytypetheory.org/2021/01/23/can-the-type-of-truth-values-be-given-the-structure-of-a-group/) if and only if the principle of excluded middle holds. And [the type of propositions is a retract of the type of ordinals](https://www.cs.bham.ac.uk/~mhe/TypeTopology/OrdinalArithmetic-Properties.html#retract-%CE%A9-of-Ordinal), which makes it unlikely that the type of ordinals can be given the structure of a group without excluded middle.

So our strategy is to embed the type of ordinals into a group, and the free group does the job.

1. First we need to show that the inclusion of generators, or the
universal map into the free group, [is an
embedding](https://www.cs.bham.ac.uk/~mhe/TypeTopology/FreeGroup.html).

1. But having a large type $X$ embedded into a type $Y$ is not enough
   to conclude that $Y$ is also large. For example, if $P$ is a
   proposition then the unique map $P \to \mathbb{1}$ is an embedding,
   and the unit type $\mathbb{1}$ is small but $P$ may be large.

1. So more work is needed to show that the group freely generated by
   the type of ordinals is large. We say that a map is [**small**](https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-Size.html#is-small) if
   each of its fibers is small, and **large** otherwise.
   [De Jong and Escardo](https://arxiv.org/abs/2102.08812) showed that
   if a map $X \to Y$ is small and the type $Y$ is small, [then so is
   the type
   $X$](https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-Size.html#is-small),
   and hence if $X$ is large then so is $Y$. Therefore our approach is
   to show that the universal map into the free group is small. To [do
   this](https://www.cs.bham.ac.uk/~mhe/TypeTopology/FreeGroupOfLargeLocallySmallSet.html),
   we exploit the fact that the type of ordinals is [locally
   small](https://arxiv.org/abs/1701.07538) ([its identity types are
   all equivalent to small
   types](https://www.cs.bham.ac.uk/~mhe/TypeTopology/BuraliForti.html#the-type-of-ordinals-is-locally-small)).

But we want to be as general as possible, and hence work with a spartan univalent type theory which doesn't include higher inductive types other than propositional truncation. We include the empty type, the unit type, natural numbers, list types ([which can actually be constructed from the other type formers](https://www.cs.bham.ac.uk/~mhe/agda-new/Fin.html#vec)), coproduct types, $\Sigma$-types, $\Pi$-types, identity types and a sequence of universes. We also assume the univalence axiom (from which we automatically get functional and propositional extensionality) and the axiom of existence of propositional truncations.

1. We [construct the free
   group](https://www.cs.bham.ac.uk/~mhe/TypeTopology/FreeGroup.html)
   as a quotient of a type of words following [Mines, Richman and
   Ruitenburg](https://www.springer.com/gb/book/9780387966403). To
   prove that the universal map is an embedding, one first proves a
   Church-Rosser property for the equivalence relation on words. It is
   remarkable that this can be done without assuming that the set of
   generators has decidable equality.

1. Quotients [can be constructed from propositional
   truncation](https://www.cs.bham.ac.uk/~mhe/agda-new/UF-Quotient.html). This
   construction increases the universe level by one, but eliminates
   into any universe.

1. To [resize back](https://www.cs.bham.ac.uk/~mhe/TypeTopology/FreeGroupOfLargeLocallySmallSet.html#resize-free-group) the quotient used to construct the group freely
   generated by the type of ordinals to the original universe, we
   exploit the fact that the type of ordinals is locally small.

1. As above, we have to transfer [**manually**](https://www.cs.bham.ac.uk/~mhe/TypeTopology/Groups.html#transport-Group-structure) group structures between equivalent types of different universes, because univalence can't be applied.

Putting the above together, and leaving many steps to the [Agda code](https://www.cs.bham.ac.uk/~mhe/TypeTopology/BuraliForti.html), we get the following in our spartan univalent type theory.

> [**Theorem.**](https://www.cs.bham.ac.uk/~mhe/TypeTopology/FreeGroupOfLargeLocallySmallSet.html) For any large, locally small set, the free group is also large and locally small.

> [**Corollary.**](https://www.cs.bham.ac.uk/~mhe/TypeTopology/BuraliForti.html) In any  successor universe $\mathcal{U}^+$ there is a group which is not isomorphic to any group in the universe $\mathcal{U}$.

> [**Corollary.**](https://www.cs.bham.ac.uk/~mhe/TypeTopology/BuraliForti.html) The canonical embedding $\operatorname{Group}\,\mathcal{U} → \operatorname{Group}\,\mathcal{U}^+$ doesn't have a section and hence is not an equivalence.

Can we formulate and prove a general theorem of this kind that
specializes to a wide variety of mathematical structures that occur in
practice?
