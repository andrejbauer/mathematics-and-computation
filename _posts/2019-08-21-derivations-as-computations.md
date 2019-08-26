---
id: 2053
title: Derivations as computations
date: 2019-08-21T11:02:57+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=2053
permalink: /2019/08/21/derivations-as-computations/
categories:
  - Andromeda
  - Talks
---
I have a [keynote talk "Derivations as Computations"](https://icfp19.sigplan.org/details/icfp-2019-Keynotes-and-Reports/3/Derivations-as-computations) at [ICFP 2019](https://icfp19.sigplan.org).

  * Slides with speaker notes: [derivations-as-computations-icfp-2019.pdf](http://math.andrej.com/wp-content/uploads/2019/08/derivations-as-computations-icfp-2019.pdf)
  * Demo file: [demo-icfp2019.m31](http://math.andrej.com/wp-content/uploads/2019/08/demo-icfp2019.m31)

**Abstract:** According to the propositions-as-types reading, programs correspond to proofs, i.e., a term `t` of type `A` encodes a derivation `D` whose conclusion is `t : A`. But to be quite precise, `D` may have parts which are not represented in `t`, such as subderivations of judgmental equalities. In general, a term does not record an entire derivation, but only its _proof relevant_ part. This is not a problem, as long as the missing subderivations can be reconstructed algorithmically. For instance, an equation may be re-checked, as long as we work in a type theory with decidable equality checking.

But what happens when a type theory misbehaves? For instance, the extensional type theory elides arbitrarily complex term through applications of the equality reflection principle. One may take the stance that good computational properties are paramount, and dismiss any type theory that lacks them – or one may look into the matter with an open mind.

If there is more to a derivation than its conclusion, then we should not equate the two. Instead, we can adopt a fresh perspective in which the conclusion is the _result_ of a derivation. That is, we think of a derivation as a _computation tree_ showing how to compute its conclusion. Moreover, the computation encoded by the derivation is _effectful_: proof irrelevance is the computational effect of discarding data, while checking a side condition is the effect of consulting an oracle. Where there are two computational effects, surely many others can be found.

Indeed, we may set up type theory so that any terminating computation represents a derivation, as long as the computational steps that construct type-theoretic judgments are guaranteed to be validated by corresponding inference rules. Common techniques found in proof assistants (implicit arguments, coercions, equality checking, etc.) become computational effects. If we allow the user to control the effects, say through the mechanism of Plotkin and Pretnar&#8217;s handlers for algebraic effects, we obtain a very flexible proof assistant capable of dealing with a variety type theories.