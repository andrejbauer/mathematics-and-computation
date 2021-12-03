---
id: 266
title: 'Constructive stone: minima of sets of natural numbers'
date: 2009-09-08T22:58:51+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=266
permalink: /2009/09/08/constructive-stone-minima-of-sets-of-natural-numbers/
categories:
  - Gems and stones
---
I promise I will post a constructive gem soon. This constructive stone came up as a reaction to the [cardinality of finite sets](/2009/09/08/constructive-stone-cardinality-of-sets/) stone. I show that inhabited sets of natural numbers need not have minima, constructively.

<!--more-->

Here is a seemingly reasonable attempt at defining the cardinality of a finite set \`S\`: it is the least \`n\` such that there is a listing \`(x\_1, ..., x\_n)\` of \`S\`. Unfortunately, constructively we cannot show that such a minimal \`n\` exist!

> **Proposition:** If every inhabited subset of \`NN\` has an infimum then the law of excluded middle holds.

_Proof._ I hope you're getting used to the kind of trick we'll use. Consider any truth value \`p in Omega\`. Define the set \`S = {n in NN ; n = 1 or (n = 0 and p)}\`, which is inhabited by 1. Let \`m\` be the infimum of \`S\`. Obviously, \`m <= 1\`. If \`m\` is 1 then \`not p\` holds. If \`m\` is \`0\` then \`p\` holds. In either case, \`p or not p\` holds. QED.

What the proposition is saying is that classical logic is required for \`NN\` to be a complete lattice with respect to \`<=\`. So, if \`NN\` need not be complete, we should complete it and use the completion instead! To be precise, we need to add all the missing infima of inhabited subsets.

Recall that the completion of a poset \`P\` (with respect to infima of inhabited subsets) is the poset of _inhabited upper sets_ \`U(P)\`, ordered by reverse inclusion \`\supseteq\`. A subset \`S \subseteq P\` is an upper set when \`x <= y\` andÂ  \`x in S\` implies \`y in S\`. The poset \`P\` is embedded in \`U(P)\` by the embedding \`u(x) = {y in P ; x <= y}\`.

> **Proposition:** \`U(P)\` is the least poset which has infima of inhabited sets and contains \`P\`, i.e.: if \`K\` is a poset with infima of inhabited subsets and \`f : P -> K\` a monotone map, then there exists a unique extension \`g : U(P) -> K\` along \`u\` which preserves infima of inhabited subsets.

_Proof._ If \`(S\_i)\_i\` is an inhabited family of elements of \`U(P)\` then its infimum in \`U(P)\` is the union \`\bigcup\_i S\_i\` (remember, the ordering is _reverse_ inclusion). The extension \`g : U(P) -> K\` is defined by \`g(S) = \bigwedge {f(x) ; x in S}\`. We leave it as an exercise that \`g\` is the only possibility and that it preserves infima of inhabited sets. QED.

What is \`U(NN)\`? We can imagine that \`S in U(NN)\` represents the minimum of all elements of \`S\`. However, as we just saw, the minimum need not “really be there”. On the other hand, we cannot exhibit a particular \`S\` which is not of the form \`u(n)\` (because everything we do is consistent with classical logic, and classical logic shows that \`u : NN \to U(NN)\` is an isomorphism).

The lattice \`U(NN)\` can be used for computing infima of inhabited subsets of \`NN\`: the infimum of an inhabited \`S \subseteq NN\` is its upper closure \`u(S) = {n in NN ; exists m in S, m <= n}\`. If this looks like cheating to you, you are right. It is cheating in the sense that the infimum of \`S\` is specified by the set of all numbers which are above the infimum. But we are cheating as little as possible, because \`U(NN)\` is the least poset in which such infima exist.

If we restrict attention to inhabited _decidable_ subsets of \`NN\` then we can show that they have minima which are natural numbers. To convince yourself that this is so, just write a little program which accepts a boolean function \`f : NN -> {0,1}\`, a number \`n \in NN\` such that \`f(n) = 1\`, and returns the least \`m \in NN\` such that \`f(m) = 1\`.
