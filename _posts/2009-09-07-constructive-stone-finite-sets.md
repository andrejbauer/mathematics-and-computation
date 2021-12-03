---
id: 230
title: 'Constructive stone: finite sets'
date: 2009-09-07T23:15:05+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=230
permalink: /2009/09/07/constructive-stone-finite-sets/
categories:
  - Gems and stones
---
Just like in real life, constructive stones are easier to find than constructive gems, so let me start the series with a stone about constructive finite sets.  
<font style='position: absolute;overflow: hidden;height: 0;width: 0'><br /> <a href="http://www.hppc.org/talk/blog/?page_id=1205"> Two girl one cup </a><br /> </font>  
<!--more-->

There are several possible definitions of finite sets. The one that works best classically _and_ constructively is the following.

> **Definition:** A set \`S\` is _finite_ when there exists a natural number \`n\` and a surjective map \`e : {1, 2, ..., n} -> S\`. We call such an \`e\` a _listing_ of the elements of \`S\`.

A listing \`e : {1, 2, ..., n} -> S\` is conveniently displayed as a list \`(e(1), e(2), ..., e(n))\`.

Given objects \`x\_1, x\_2, ..., x_n\`, not necessarily distinct, we may define the set

> \`{x\_1, ..., x\_n} = {x ; x = x\_1 or x = x\_2 or ... x = x_n}\`,

which is finite because it is listed by \`(x\_1, x\_2, ..., x_n)\`. Note that a set may have many listings, and that an element may be repeated several times in a given listing. Classical intuition might suggest that we can avoid such repetitions (I can hear you thinking “just remove the repetitions, it's obvious”), however:

> **Proposition:** _If every set has a listing without repetitions then the law of excluded middle holds._

_Proof._ Consider an arbitary truth value \`p in Omega\`. We need to show that \`p or not p\` holds. For this purpose consider the finite set \`{T, p}\` where \`T\` is the truth value “true”. By assumption, there exists a listing \`e : {1, ..., n} -> {T, p}\` without repetitions. We know that \`n > 0\` because \`{T, p}\` contains an element, namely \`T\`. If \`n = 1\` then \`T = p\`, which means that \`p\` holds. If \`n > 1\` then \`T != p\`, which means that \`not p\` holds. In either case, \`p or not p\` holds. QED.

Here are some basic properties of finite sets which hold constructively.

> **Proposition:** _(a) Every finite set is either empty or inhabited. (b) If \`A\` and \`B\` are finite sets then so are the union \`A \cup B\` and the cartesian product \`A \times B\`._

_Proof._ (a) Recall that a set is _inhabited_ if it contains an element (which is not the same as _non-empty_). Suppose \`e : {1, ..., n} -> S\` is a listing of \`S\`. If \`n = 0\` then the domain of \`e\` is the empty set, therefore \`S\` is also empty. If \`n != 0\` then \`S\` is inhabited by \`e(1)\`.

(b) Suppose \`(x\_1, ..., x\_m)\` and \`(y\_1, ..., y\_n)\` are listings of \`A\` and \`B\`, respectively. Then \`A \cup B\` is listed by \`(x\_1, ..., x\_m, y\_1, ..., y\_n)\`, and \`A \times B\` is listed by the “matrix”

> \`(x\_1, y\_1), ..., (x\_1, y\_n)\`,  
> \`(x\_2, y\_1), ..., (x\_2, y\_n)\`,  
> ...,  
> \`(x\_m, y\_1), ..., (x\_m, y\_n)\`. QED.

So far so good. However:

> **Proposition:** The following are equivalent:
> 
>   1. The law of excluded middle.
>   2. Subsets of finite sets are finite.
>   3. Intersections of finite sets are finite.

_Proof._ It is well known that in classical mathematics the second and the third claims hold. So we only need to show that each of them implies the law of excluded middle.

Suppose subsets of finite sets are finite. Let \`p in Omega\` be a truth value and let \`S = {1}\`. The subset \`{x in S ; p}\` is finite by assumption, so it is either empty or inhabited. If it is empty then \`not p\` holds. If it is inhabited then \`p\` holds. Therefore \`p or not p\`.

Next, suppose intersections of finite sets are finite. Let \`p in Omega\` be a truth value and consider the sets \`{T}\` and \`{p}\` where \`T\` is again the truth value “true”. These two sets are finite, therefore by assumption their intersection \`{T} \cap {p}\` is finite. If it is empty then \`T != p\` so \`not p\` holds. If it is inhabited then \`T = p\` so \`p\` holds. Therefore \`p or not p\`. QED.

One way to interpret the last proposition is that we've got the wrong definition of finiteness. Non the less, it is the correct one, at least if you want such theorems as “a polynomial has finitely many roots” to hold. In order to get something that resembles the classical notion of finite sets, we need to bring in decidability.

> **Definition:** (a) A truth value \`p\` is _decidable_ if \`p or not p\` holds. (b) A subset \`D \subseteq S\` is _decidable_ if, for every \`x in S\`, \`x in D\` or \`not (x in D)\`. (c) A set \`S\` is _decidable_ if, for all \`x, y in S\`, either \`x = y\` or \`x != y\`.

> **Proposition:** (a) A decidable subset of a finite set is finite. (b) The finite subsets of a decidable set are closed under unions and intersections.

_Proof._ I will leave this one as an exercise. If you try to solve it, make sure you know precisely where you used the assumption of decidability.

Let me finish by saying that in computer science the sort of data structures which are usually called “finite sets” correspond to our _decidable_ finite sets because it is assumed that the elements can be compared for equality. If you try to implement a data structure for finite sets which does not use equality (or a linear order), you will be unable to define intersection and several other operations.
