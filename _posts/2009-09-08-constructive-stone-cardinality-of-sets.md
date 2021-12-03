---
id: 249
title: 'Constructive stone: cardinality of sets'
date: 2009-09-08T17:06:51+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=249
permalink: /2009/09/08/constructive-stone-cardinality-of-sets/
categories:
  - Gems and stones
---
Cardinality of sets in constructive mathematics is not as well behaved as in classical mathematics. Cardinalities of finite sets are _not_ natural numbers, and cardinalities are _not_ linearly ordered.

<!--more-->

First of all, constructively we cannot measure the size of finite sets with natural numbers. As soon as we require that the cardinality of singletons be 1, we're in trouble (recall that a set \`S\` is a _singleton_ when there exists an element of \`S\` and, for all \`x, y\`, if \`x in S and y in S\` then \`x = y\`):

> **Proposition:** _Suppose \`c\` is a map which assigns to each finite set a natural number__, such that \`c(S) = 1\` if, and only if, \`S\` is a singleton. Then the law of excluded middle holds._

_Proof._ (Think of \`c\` as a candidate map for measuring cardinality.) Consider an arbitrary truth value \`p in Omega\` and let \`S = {T, p}\` where \`T\` is the truth value “true”. Either \`c(S) = 1\` or \`c(S) != 1\`. If \`c(S) = 1\` then \`S\` is a singleton, therefore \`T = p\` and \`p\` holds. If \`c(S) != 1\` then \`S\` is not a singleton, therefore \`T != p\` and \`not p\` holds. This establishes \`p or not p\`. QED.

(Side remark: _decidable_ finite sets do have a well-defined number of elements, which is a natural number, because every such set has a listing without repetitions. See [this constructive stone](/2009/09/07/constructive-stone-finite-sets/) for details.)

If the natural numbers are not suitable for measuring the size of a finite set, then perhaps some other linear order is?

> **Proposition:** Let \`<\` be an irreflexive relation on a set or class \`P\` such that \`x < y or x = y or y < x\` for all \`x, y in P\`. Suppose \`c\` is a map which assigns to each set a value in \`P\` such that \`c(A) = c(B)\` if, and only if, there is a bijection between \`A\` and \`B\`. Then the law of excluded middle holds.

_Proof._ (Think of \`P\` as the class of cardinal numbers, \`<\` the strict order on them, and \`c\` a candidate cardinality function.) Given any truth value \`p in Omega\`, consider the sets \`A = {T, p}\` and \`B = {T}\`. Either \`c(A) < c(B)\`, or \`c(A) = c(B)\`, or \`c(B) < c(A)\`. If \`c(A) = c(B)\` then \`A\` and \`B\` are in bijective correspondence, therefore \`A\` is a singleton and \`T = p\`, which means that \`p\` holds. If \`c(A) < c(B)\` or \`c(B) < c(A)\` then by irreflexivity of \`<\` we have \`c(A) != c(B)\`, therefore \`A\` is not a singleton and \`T != p\`, which means that \`not p\` holds. In any case, \`p or not p\` holds. QED.

The previous proposition tells us that we cannot hope to have a sensible notion of cardinals ordered by a strict linear order. Perhaps a non-strict linear order can be used to measure cardinalities constructively? The answer is negative:

> **Proposition:** _Let \`<=\` be a partial order on a set or class \`P\` such that \`x <= y or y <= x\` for all \`x, y in P\`. Suppose \`c\` is a map which assigns to each set a value in \`P\` such that \`c(A) <= c(B)\` if, and only if, there is an injection of \`A\` into \`B\`. Then the following non-constructive law holds: \`forall p, q in Omega, (p => q) or (q => p)\`._

_Proof._ Consider arbitrary truth values \`p, q in Omega\`. Let \`S = {1}\`, \`A = {x in S ; p}\` and \`B = {x in S ; q}\`. By assumption, either \`c(A) <= c(B)\` or \`c(B) <= c(A)\`. In the first case we have an injection \`i : A -> B\`, therefore \`p => q\`. Indeed, if \`p\` holds then \`1 in A\` and so \`i(1) = 1 in B\`, hence \`q\` holds. Similarly, if \`c(B) <= c(A)\` then \`q => p\`. In either case, \`(p => q) or (q => p)\`. QED.

The logical law \`(p => q) or (q => p)\` was studied in Michael A. E. Dummett, “A Propositional Calculus with a Denumerable Matrix”, Journal of Symbolic Logic, Vol 24 No. 2 (1959), pp 97-103. It is not provable constructively, and it is implied by the law of excluded middle, see [this Coq library](http://coq.inria.fr/stdlib/Coq.Logic.ClassicalFacts.html#lab17) for proofs.

I would be curious to know if the assumptions of the above proposition imply the law of excluded middle:

> **Question:** _Let \`<=\` be a partial order on a set or class \`P\` such that \`x <= y or y <= x\` for all \`x, y in P\`. Suppose \`c\` is a map which assigns to each set a value in \`P\` such that \`c(A) <= c(B)\` if, and only if, there is an injection of \`A\` into \`B\`. Does the law of excluded middle follow?_

By the way, nothing much changes if in the proposition above we replace the existence of an injection of \`A\` into \`B\` with the existence of a surjection from \`B\` onto \`A\`. That's an exercise for you.

It would be wrong to conclude from this post that cardinality of sets does not make sense constructively. We can still compare sets by their sizes, for example, we could say that \`A\` is smaller than \`B\` when there is an injection of \`A\` into \`B\`. That would give us a reflexive, transitive relation on sets. However, whatever our notion of size is, we cannot expect it to be a linear order: there will always be sets which are incomparable in size.
