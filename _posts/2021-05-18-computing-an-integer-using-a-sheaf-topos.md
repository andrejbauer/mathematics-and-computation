---
title: Computing an integer using a Grothendieck topos
author: Martin Escardo
layout: post
categories:
  - Constructive mathematics
  - Type theory
  - Formalization
---



A while ago, my former student [Chuangjie Xu](https://cj-xu.github.io/) and I computed an integer using a [sheaf topos](https://ncatlab.org/nlab/show/Grothendieck+topos). For that purpose,

1. we developed our mathematics constructively,
1. we formalized our mathematics in Martin-Löf type theory, in [Agda](https://wiki.portal.chalmers.se/agda/pmwiki.php) notation,
1. we pressed a button, and
1. after a few seconds we saw the integer we expected in front of us.

Well, it was a few seconds for the computer in steps (3)-(4), but three years for us in steps (1)-(2).

<!--more-->

#### Why formalize?

Most people formalize mathematics (in Automath, NuPrl, Coq, Agda, Lean, ...) to get confidence in the correctness of mathematics - or so they claim. The reality is that formalizing mathematics is intellectually fun.

Entertaining considerations aside, my initial motivation for computer formalization, about 10 years ago, was to write algorithms derived from work on game theory with [Paulo Oliva](https://www.eecs.qmul.ac.uk/~pbo/). In particular, this had applications to proof theory, such as [getting programs from classical proofs](https://www.cs.bham.ac.uk/~mhe/pigeon/). Our first version of a (manually) extracted program from a classical proof was written in Haskell, in a train journey coming back from a visit to our collaborators [Monika Seisenberger](https://www.swansea.ac.uk/staff/science/computer-science/m.seisenberger/) and [Ulrich Berger](http://www-compsci.swan.ac.uk/~csulrich/) in Swansea. The train journey was long enough for us to be able to complete the program. But when we ran it, it didn't work. I had been learning Agda for about one year by then, and I told Paulo that it would be easier to write the mathematics in Agda, and hence be sure it will work before we ran it, than to debug the Haskell program. And that was the case.

Before then I was the kind of person who dismissed formalization, and would say so to people who did formalization (it is probably too late to apologize now). I trusted my own mathematics, and if I wanted to derive programs from my mathematical work, I would just write them manually. Since then, my attitude has changed considerably.

I now [use Agda as a "blackboard"](https://www.cs.bham.ac.uk/~mhe/TypeTopology/) to develop my work. For example, the following were conceived and developed directly in Agda before they were written in mathematical vernacular: [Injective types in univalent mathematics](https://www.cambridge.org/core/journals/mathematical-structures-in-computer-science/article/injective-types-in-univalent-mathematics/AFCBBABE47F29ED7AFB4C262929D8810), [Compact, totally separated and well-ordered types in univalent mathematics](https://www.cs.bham.ac.uk/~mhe/papers/compact-ordinals-Types-2019-abstract.pdf), [The Cantor-Schröder-Bernstein Theorem for ∞-groupoids](https://arxiv.org/abs/2002.07079), [The Burali-Forti argument in HoTT/UF](http://math.andrej.com/2021/02/22/burali-forti-in-hott-uf/) and [Continuity of Gödel's system T functionals via effectful forcing](https://www.cs.bham.ac.uk/~mhe/dialogue/dialogue.pdf).

Other people will have different reasons to formalize. For example, wouldn't it be wonderful if the whole [undergraduate mathematical curriculum were formalized](https://wwwf.imperial.ac.uk/~buzzard/xena/)? Wouldn't it be wonderful to archive all mathematical knowledge not just as text but in a more structured way, so that it can be used by both people and computers? Wouldn't it be wonderful if when we submit a paper, the referee didn't need to check correctness, but only novelty, significance and so on? Did you ever woke up in the middle of the night after you submitted a paper, with doubts about the crucial lemma? Or worse, after it was published?

But for the purposes of this post, I will concentrate on only one aspect of formalization: a formalized piece of constructive mathematics is automatically a computer program that you can run in practice.

#### Constructive mathematics

Constructive mathematics begins by removing the principle of excluded middle, and therefore the axiom of choice, because choice implies excluded middle.
[But why would anybody do such an outrageous thing?](http://math.andrej.com/2016/10/10/five-stages-of-accepting-constructive-mathematics/)

I particularly like the analogy with [Euclidean geometry](https://en.wikipedia.org/wiki/Euclidean_geometry). If we remove the parallel postulate, we get [absolute geometry](https://en.wikipedia.org/wiki/Absolute_geometry), also known as *neutral* geometry. If after we remove the parallel postulate, we add a suitable axiom, we get [hyperbolic geometry](https://en.wikipedia.org/wiki/Hyperbolic_geometry), but if we instead add a different suitable axiom we get [elliptic geometry](https://en.wikipedia.org/wiki/Elliptic_geometry). Every theorem of neutral geometry is a theorem of these three geometries, and more geometries. So a neutral proof is more general.


When I say that I am interested in constructive mathematics, most of the time I mean that I am interested in [neutral mathematics](http://logic.math.su.se/mloc-2019/), so that we simply remove excluded middle and choice, and we don't add anything to replace them. So my constructive definitions and theorems are also definitions and theorems of classical mathematics.

Occasionally, I flirt with axioms that *contradict* the principle of excluded middle, such as Brouwerian intuitionistic axioms that imply that "all functions $(\mathbb{N} \to 2) → \mathbb{N}$ are uniformly continuous", when we equip the set $2$ with the discrete topology and $\mathbb{N} \to 2$ with the product topology, so that we get the Cantor space. The contradiction with classical logic, of course, is that using excluded middle we can define non-continuous functions by cases. Brouwerian intuitionistic mathematics is analogous to hyperbolic or elliptic geometry in this respect. The "constructive" mathematics I am talking about in this post is like neutral geometry, and I would rather call it "neutral mathematics", but then nobody would know what I am talking about. That's not to say that the majority of mathematicians will know what I am talking about if I just say "constructive mathematics".

But it is not (only) the generality of neutral mathematics that I find attractive. Somehow magically, constructions and proofs that don't use excluded middle or choice are *automatically* programs. The only way to define non-computable things is to use excluded middle or choice. There is no other way. At least in the underlying type theories of proof assistants such as NuPrl, Coq, Agda and Lean. We don't need to consider Turing machines to establish computability. What is a computable sheaf, anyway? I don't want to pause to consider this question in order to use a sheaf topos to compute a number. We only need to consider sheaves in the usual mathematical sense.

Sometimes people ask me whether I *believe* in the principle of excluded middle. That would be like asking me whether I believe in the parallel postulate. It is clearly true in Euclidean geometry, clearly false in elliptic and in hyperbolic geometries, and deliberately undecided in neutral geometry. Not only that, in the same way as the parallel postulate *defines* Euclidean geometry, the principle of excluded middle and the axiom of choice *define* classical mathematics.

The undecidedness of excluded middle in my neutral mathematics allows me to prove, for example, "if excluded middle holds, then the Cantor-Schröder-Bernstein Theorem for ∞-groupoids [holds](https://arxiv.org/abs/2002.07079)". If excluded middle were false, I would be proving a counter-factual - I would be proving that an implication is true simply because its premise is false. But this is not what I am doing. What I am really proving is that the CSB theorem holds for the objects of *boolean* ∞-toposes.
And why did I use excluded middle? Because somebody else showed that [there is no other way](https://arxiv.org/abs/1904.09193). But also sometimes I use excluded middle or choice when *I don't know* whether there is another way (in fact, I believe that more than half of my publications use classical logic).

So, am I a constructivist? There is only one mathematics, of which classical and constructive mathematics are particular branches. I enjoy exploring the whole landscape. I am particularly fond of constructive mathematics, and I wouldn't practice it, however useful it may be for applications, if I didn't enjoy it. But this is probably my bad taste.

#### Toposes as provinces of the mathematical world

Toposes are generalized (sober) spaces. But also toposes can be considered as provinces of the mathematical world.

Hyland's [effective topos](https://ncatlab.org/nlab/show/effective+topos) is a province where "everything is computable".
This is an elementary topos, which is not a Grothendieck topos, built from *classical* ingredients: we use excluded middle and choice, with Turing machines to talk about computability. But, as it turns out, although everybody agrees which functions $\mathbb{N} \to \mathbb{N}$ are computable and which ones aren't, there is disagreement among classical mathematicians working on computability theory about
[what counts as "computable" for more general mathematical objects](https://www.springer.com/gp/book/9783662479919), such as functions $(\mathbb{N} \to \mathbb{N}) \to \mathbb{N}$. No problem. Just consider other provinces, called [realizability toposes](https://ncatlab.org/nlab/show/realizability+topos), which include the effective topos as an example.

Johnstone's [topological topos](https://ncatlab.org/nlab/show/Johnstone%27s+topological+topos) is a topos *of* spaces. It fully embeds a large category of topological spaces, where the objects outside the image of the embedding can be considered as generalized spaces (which include the [Kuratowski limit spaces](https://ncatlab.org/nlab/show/subsequential+space) and more). In this province of the mathematical world, "all functions are continuous".

There are also provinces where [there are infinitesimals](https://ncatlab.org/nlab/show/synthetic+differential+geometry) and "all functions are smooth".

A more boring, but important, province, is the topos of classical sets. This is were classical mathematics takes place.

These provinces of mathematics have an *internal language*. We use a certain [subobject classifier](https://ncatlab.org/nlab/show/subobject+classifier) to collect the things that count as truth values in the province, and we devise a kind of type theory whose types are interpreted as objects and whose mathematical statements are interpreted as truth values in the province. Then a mathematical statement in this type theory is true in some toposes, false in other toposes, and undecided in yet other toposes. This internal language, or type theory, is very rich. Starting from natural numbers we can construct the integers, the rationals, the real numbers, free groups etc., and then do e.g. analysis and group theory and so on. The internal language of the [free topos](https://ncatlab.org/nlab/show/free+topos) can be considered as a type theory for neutral mathematics: whatever we prove in the free type theory is true in all mathematical provinces, including classical set theory.

In the above first three provinces, the principle of excluded middle fails, but for different reasons, with respectively computability, continuity and infinitesimals to blame.

#### Our topos

Now our plot has a twist: we work within *neutral* mathematics to build a province of "biased" constructive mathematics where Brouwerian principles hold, such as "all functions $(\mathbb{N} \to 2) → \mathbb{N}$ are uniformly continuous".

[Johnstone's topological topos (1979)](https://academic.oup.com/plms/article-abstract/s3-38/2/237/1484548) would do the job, except that it is built using classical ingredients. This topos has siblings by [Mike Fourman (1982)](http://homepages.inf.ed.ac.uk/mfourman/research/publications/pdf/fourman82-notions-of-choice-sequence.pdf) and [van der Hoeven and Moerdijk (1984)](https://www.sciencedirect.com/science/article/pii/0168007284900356) with aims similar to ours, as explained in our own [2013](https://cj-xu.github.io/papers/xu-escardo-model-uc.pdf) and [2016](https://www.sciencedirect.com/science/article/pii/S0168007216300410) papers, which give a third sibling.

Johnstone's topological topos is very easy to describe: take the monoid of continuous endomaps of the one-point compactification of the natural numbers, considered as a category, then take sheaves for the canonical coverage.
Van der Hoeven and Moerdijk's topos is similar: this time take the monoid of continuous endomaps of the Baire space,
with the "open-cover coverage". Fourman's topos is constructed from a site of formal spaces or locales, with a similar coverage.

Our topos is also similar: we take the monoid of uniformly continuous endomaps of the Cantor space.
Because it is not provable in neutral mathematics that continuous functions on the Cantor space are automatically uniformly continuous, we explicitly ask for uniform continuity rather than just continuity. As for our coverage, we initially considered coverings of finitely many jointly surjective maps. But an equivalent, smaller coverage makes the mathematics (and the formalization) simpler: for each natural number $n$ we consider a cover with $2^n$ functions, namely the concatenation maps $(\mathbb{N} \to 2) \to (\mathbb{N} \to 2)$ defined by $\alpha \mapsto s \alpha$ for each finite binary sequence $s$ of length $n$. These functions are jointly surjective, and, moreover, have disjoint images, considerably simplifying the checking of the sheaf condition. Moreover, the coverage axiom is not only satisfied, but also is equivalent to the fact that the morphisms in our site are uniformly continuous functions. So this is a sort of "uniform-continuity coverage". Our [slides (2014)](https://www.cs.bham.ac.uk/~mhe/.talks/ihp2014/escardo-ihp2014.pdf) illustrate these ideas with pictures and examples.

The details of the mathematics can be found in the [above paper](https://www.sciencedirect.com/science/article/pii/S0168007216300410), and the Agda formalization can be found at [Chuangjie's page](https://cj-xu.github.io/). A few years later, [we ported part of this formalization](https://www.cs.bham.ac.uk/~mhe/chuangjie-xu-thesis-cubical/html/) to [Cubical Agda](https://agda.readthedocs.io/en/v2.6.1.3/language/cubical.html) to deal properly with function extensionality (which we originally dealt with in *ad hoc* ways).

#### The integer we compute

After we construct the sheaf topos, we define a simple type theory and we interpret it in the topos. We define a "function" $(\mathbb{N} \to 2) \to \mathbb{N}$ in this type theory, without proving that it is uniformly continuous, and apply the interpretation map to get a morphism of the topos, which amounts to a uniformly continuous function. From this morphism we get the modulus of uniform continuity, which is the integer we are interested in.
The interested reader can find the details in the [above paper](https://www.sciencedirect.com/science/article/pii/S0168007216300410) and [Agda code for the paper](http://www.cs.bham.ac.uk/~mhe/papers/kleene-kreisel/) or the substantially more comprehensive [Agda code](http://cj-xu.github.io/ContinuityType/) for [Chuangjie's thesis](http://cj-xu.github.io/ContinuityType/xu-thesis.pdf).
