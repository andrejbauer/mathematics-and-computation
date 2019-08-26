---
id: 453
title: Proof of negation and proof by contradiction
date: 2010-03-29T17:00:04+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=453
permalink: /2010/03/29/proof-of-negation-and-proof-by-contradiction/
bfa_ata_body_title:
  - Proof of negation and proof by contradiction
bfa_ata_display_body_title:
  - ""
bfa_ata_body_title_multi:
  - Proof of negation and proof by contradiction
bfa_ata_meta_title:
  - ""
bfa_ata_meta_keywords:
  - ""
bfa_ata_meta_description:
  - ""
categories:
  - Logic
  - Tutorial
---
I am discovering that mathematicians cannot tell the difference between &#8220;proof by contradiction&#8221; and &#8220;proof of negation&#8221;. This is so for good reasons, but conflation of different kinds of proofs is bad mental hygiene which leads to bad teaching practice and confusion. For reference, here is a short explanation of the difference between proof of negation and proof by contradiction.<!--more-->

By the way, this post is something I have been meaning to write for a while. It was finally prompted by Timothy Gowers&#8217;s blog post [&#8220;When is proof by contradiction necessary?](http://gowers.wordpress.com/2010/03/28/when-is-proof-by-contradiction-necessary/)&#8221; in which everything seems to be called &#8220;proof by contradiction&#8221;.

As far as I can tell, &#8220;proof by contradiction&#8221; among ordinary mathematicians means any proof which starts with &#8220;Suppose &#8230;&#8221; and ends with a contradiction. But two kinds of proofs are like that:

**Proof of negation** is an inference rule which explains how to prove a negation:

> _To prove $\lnot \phi$, assume $\phi$ and derive absurdity._

The rule for proving negation is the same classically and intuitionistically. I mention this because I have met ordinary mathematicians who think intuitionistic proofs are never allowed to reach an absurdity.

**Proof by contradiction**, or _reductio ad absurdum_, is a different kind of animal. As a reasoning principle it says:

> _To prove $\phi$, assume $\lnot \phi$ and derive absurdity._

As a proposition the principle is written $\lnot \lnot \phi \Rightarrow \phi$, which can be proved from the law of excluded middle (and is in fact equivalent to it). In intuitionistic logic this is not a generally valid principle.

Admittedly, the two reasoning principles look very similar. A classical mathematician will quickly remark that we can get either of the two principles from the other by plugging in $\lnot \phi$ and cancelling the double negation in $\lnot \lnot \phi$ to get back to $\phi$. Yes indeed, but the cancellation of double negation is _precisely_ the reasoning principle we are trying to get. These really _are different_.

I blame the general confusion on the fact that an informal proof of negation looks almost the same as an informal proof by contradiction. In order to prove $\lnot \phi$ a mathematician will typically write:

> _&#8220;Suppose $\phi$. Then &#8230; bla &#8230; bla &#8230; bla, which is a contradiction. QED.&#8221;_

In order to prove $\phi$ by contradiction a mathematician will typically write:

> _&#8220;Suppose $\lnot \phi$. Then &#8230; bla &#8230; bla &#8230; bla, which is a contradiction. QED.&#8221;_

The difference will be further obscured because the text will typically state $\lnot \phi$ in an equivalent form with negation pushed inwards. That is, if $\phi$ is something like $\exists x, \forall y, f(y) < x$ and the proof goes by contradiction then the opening statement will be &#8220;Suppose for every $x$ there were a $y$ such that $f(y) \geq x$.&#8221; With such &#8220;optimizations&#8221; we really cannot tell what is going on by looking just at the proof. We have to take into account the surrounding context (such as the original statement being proved).

A second good reason for the confusion is the fact that both proof principles _feel_ the same when we try to use them. In both cases we assume something believed to be false and then we hunt down a contradiction. The difference in placement of negations is not easily appreciated by classical mathematicians because their brains automagically cancel out double negations, just like good students automatically cancel out double negation signs.

Keeping all this in mind, let us look at Timothy Gower&#8217;s blog examples.

#### Irrationality of $\sqrt{2}$

The first example is irrationality of $\sqrt{2}$. Because &#8220;$\sqrt{2}$ is irrational&#8221; is _by definition_ the same as &#8220;$\sqrt{2}$ is not rational&#8221; we are clearly talking about a proof of negation. There is a theorem about normal forms of proofs in intuitionistic logic which tells us that every proof of a negation can be rearranged so that it ends with the inference rule cited above. In this sense the method of proof &#8220;assume $\sqrt{2}$ is rational, &#8230;, contradiction&#8221; is unavoidable.

I want to make two further remarks. The first one is that the usual proof of irrationality of $\sqrt{2}$ is intuitionistically valid. Let me spell it out:

> **Theorem:** _$\sqrt{2}$ is not rational._
> 
> _Proof._ Suppose $\sqrt{2}$ were equal to a fraction $a/b$ with $a$ and $b$ relatively prime. Then we would get $a^2 = 2 b^2$, hence $a^2$ is even and so is $a$. Write $a = 2 c$ and plug it back in to get $2 c^2 = b^2$, from which we conclude that $b$ is even as well. This is a contradiction since $a$ and $b$ were assumed to be relatively prime. QED.

No proof by contradiction here!

My second remark is that this particular example is perhaps not good for discussing proofs of negation because it reduces to inequality of natural numbers, which is a decidable property. That is, as far as intuitionistic logic is concerned, equality and inequality of natural numbers are both equally &#8220;positive&#8221; relations. This is reflected in various variants of the proof given by Gowers on his blog, some of which are &#8220;positive&#8221; in nature.

The situation with reals is different. There we could define the so-called _apartness_ relation $x \# y$ to mean $x < y \lor y < x$. The negation of apartness is equality, but the negation of equality is not apartness, at least not intuitionistically (classically of course this whole discussion is a triviality). A proof of inequality $x \neq y$ of real numbers $x$ and $y$ may thus proceed in two ways:

  1. The _direct_ way: assume $x = y$ and derive absurdity
  2. Via apartness: prove $x \# y$ and conclude that $x \neq y$

Note that the proof of $x \# y \Rightarrow x \neq y$ still involves the usual proof of negation in which we assume $x \# y \land x = y$ and derive absurdity.

#### A continuous map on $[0,1]$ is bounded

The second example is the statement that a continuous map $f : [0,1] \to \mathbb{R}$ is bounded. The direct proof uses the Heine-Borel property of the closed interval to find a finite cover of $[0,1]$ such that $f$ is bounded on each element of the cover. There is also a proof by contradiction which goes as follows:

> Suppose $f$ were unbounded. Then we could find a sequence $(x\_n)\_n$ in $[0,1]$ such that the sequence $(f(x\_n))\_n$ is increasing and unbounded (this uses Countable Choice, by the way). By Bolzano-Weierstras there is a convergent subsequence $(y\_n)\_n$ of $(x\_n)\_n$. Because $f$ is continuous the sequence $(f(y\_n))\_n$ is convergent, which is impossible because it is a subsequence of the increasing and unbounded sequence $(f(x\_n))\_n$. QED.

Can we turn this proof into one that does not use contradiction (but still uses Bolzano-Weierstrass)? Constructive mathematicians are well versed in doing such things. Essentially we have to look at the supremum of $f$, like Timothy Gowers does, but without actually referring to it. The following proof is constructive and direct.

> **Theorem:** _If every sequence in a separable space $X$ has a convergent subsequence, then every continuous real map on $X$ is bounded._
> 
> _Proof._ Let $(x\_n)\_n$ be a dense sequence in $X$ and $f : X \to \mathbb{R}$ continuous. For every $n$ there is $k$ such that $f(x\_k) \geq \max(f(x\_1), &#8230;, f(x\_n)) &#8211; 1$. By Countable Choice there is a sequence $(k\_n)\_n$ such that $f(x\_{k\_n}) \geq \max(f(x\_1), &#8230;, f(x\_n)) &#8211; 1$ for every $n$. Let $(z\_n)\_n$ be a convergent subsequence of $(x\_{k\_n})\_n$ and let $z$ be its limit. Because $f$ is continuous there is $d > 0$ such that $f(z\_n) \leq f(z) + d$ for all $n$. Consider any $x \in X$. Because $f$ is continuous and $(x\_n)\_n$ is dense there is $x\_i$ such that $f(x) \leq f(x\_i) + 1$. Observe that there is $j$ such that $f(x\_{k\_i})  &#8211; 1 \leq f(z\_j)$. Now we get $$f(x) \leq f(x\_i) + 1 \leq \max(f(x\_1), &#8230;, f(x\_i)) + 1 \leq f(x\_{k\_i}) + 2 \leq f(z\_j) + 3 < f(z) + d + 3.$$ We have shown that $f(z) + d + 3$ is an upper bound for $f$. QED.

I am pretty sure with a bit more work we could show that $f$ attains its supremum, and in fact this must have been proved by someone constructively.

The moral of the story is: proofs by contradiction can often be avoided, proofs of negation generally cannot, and if you think they are the same thing, you will be confused.