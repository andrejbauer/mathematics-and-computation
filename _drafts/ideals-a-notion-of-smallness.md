---
title: Ideals as a notion of smallness
author: Andrej Bauer
layout: post
categories:
  - General
  - Tutorial
---

Timothy Gowers has a nice series of [tweets about small sets of reals](https://twitter.com/wtgowers/status/1168797288342405121?s=20). He starts by asking "what is a small set of real numbers"? I answered by tweeting something I heard a long time ago, probably from Dana Scott. But tweets are such an awful medium of communication that I might as well record the observation here.

<!--more-->

There are many notions of smallness:

* [finite sets](https://en.wikipedia.org/wiki/Finite_set)
* [countable sets](https://en.wikipedia.org/wiki/Countable_set)
* [meager sets](https://en.wikipedia.org/wiki/Meagre_set)
* [null sets](https://en.wikipedia.org/wiki/Null_set)
* [nowhere dense sets](https://en.wikipedia.org/wiki/Nowhere_dense_set)

Each of these conveys a way in which a set is "small". Notice that they all satisfy the following criteria:

1. The empty set is small.
2. Not every set is small.
3. A subset of a small set is small.
4. The union of two small sets is small.

These are precisely the requirements in the definition of an ideal, in the set-theoretic sense:

> **Definition:** An **ideal** on a set $X$ is a collection of subsets $I \subseteq P(X)$ such that:
> 1. $\emptyset \in I$,
> 2. $X \not\in I$,
> 3. if $A \subseteq B$ and $B \in I$ then $A \in I$,
> 4. if $A \in I$ and $B \in I$ then $A \cup B \in I$.

