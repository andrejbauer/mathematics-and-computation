---
id: 1825
title: Intermediate truth values
date: 2015-07-30T10:16:50+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1825
permalink: /2015/07/30/intermediate-truth-values/
categories:
  - Constructive math
  - Gems and stones
  - Logic
---
I have not written a blog post in a while, so I decided to write up a short observation about truth values in intuitionistic logic which sometimes seems a bit puzzling.

Let $\Omega$ be the set of truth values (in Coq this would be the setoid whose underlying type is $\mathsf{Prop}$ and equality is equivalence $\leftrightarrow$, while in HoTT it is the h-propostions). Call a truth value $p : \Omega$ **intermediate** if it is neither true nor false, i.e., $p \neq \bot$ and $p \neq \top$. Such a &#8220;third&#8221; truth value $p$ is proscribed by excluded middle.

The puzzle is to explain how the following two facts fit together:

  1. **&#8220;There is no intermediate truth value&#8221;** is an intuitionistic theorem.
  2. **There are models of intuitionistic logic with many truth values.**

<!--more-->

Mind you, excluded middle says &#8220;every truth value is either $\bot$ or $\top$&#8221; while we are saying that there is no truth value different from $\bot$ and $\top$:  
$$\lnot \exists p : \Omega \,.\, (p \neq \top) \land (p \neq \bot).$$  
Coq proves this:

<pre class="brush: plain; title: ; notranslate" title="">Theorem no_intermediate: ~ exists p : Prop, ~ (p &lt;-&gt; True) /\ ~ (p &lt;-&gt; False).
Proof.
  firstorder.
Qed.
</pre>

Note that we replaced $=$ with $\leftrightarrow$ because equality on $\Omega$ is equivalence on $\mathsf{Prop}$ in Coq (this would not be neccessary if we used HoTT where h-propositions enjoy an extensionality principle). You should also try proving the theorem by yourself, it is easy.

A model of intuitionistic mathematics with many truth values is a sheaf topos $\mathsf{Sh}(X)$ over a topological space $X$, so long as $X$ has more than two open sets. The global points of the sheaf of truth values $\Omega$ are the open subsets of $X$, and more generally the elements of $\Omega(U)$ are the open subsets of $U$.

So, if we take an intermediate open set $\emptyset \subset U \subset X$, should it not be an intermediate truth value? Before reading on you should stop and think for yourself.

Really, stop reading.

Let us calculate which open set (truth value) is  
$$(U \neq \top) \land (U \neq \bot).$$  
Because $U = \top$ is equivalent to $U$ and $U = \bot$ to $\lnot U$ our formula is equivalent to  
$$\lnot U \land \lnot\lnot U.$$  
Remembering that negation is topological exterior we get  
$$\mathsf{Ext}(U) \cap \mathsf{Ext}(\mathsf{Ext}(U))$$  
which is empty,  
$$\emptyset.$$  
Indeed, $U$ is _not_ a counterexample!

We have here a typical distinction between _internal_ and _external_ language:

  * The mathematicians inside the topos think and speak _locally_. They ask not &#8220;Is this statement true?&#8221; but &#8220;_Where_ is this statement true?&#8221; If you aks them a yes/no question they will answer by giving you an open subset of $X$. They will conclude that $U \neq \top$ holds on the exterior of $U$, and $U \neq \bot$ on the double exterior of $U$, and that nowhere are they true both together. 
  * The mathematicians outside the topos (that&#8217;s us) understand $(U \neq \top) \land (U \neq \bot)$ differently: it is about comparing the open set $U$ to the open sets $X$ and $\emptyset$ as elements of the topology of $X$. For them &#8220;yes&#8221; and &#8220;no&#8221; are valid answers, and no other. 

By the way, the mathematicians on the inside also think that &#8220;yes&#8221; and &#8220;no&#8221; are valid answers, and there is no other – that is precisely the statement &#8220;there is no intermediate truth value&#8221; – but they think of it as &#8220;holding everywhere on $X$&#8221;.

There are of course many situations where the difference between iternal and external language may create confusion. For example, if $X = \mathbb{N}$ is a countable discrete space then the object of natural numbers is the sheaf of _all_ maps into $\mathbb{N}$, of which there are uncountably many. Thus on the outside we &#8220;see&#8221; that there are uncountably many natural numbers in $\mathsf{Sh}(X)$. Those on the inside would of course disagree. This is an amusing situation, sort of a reverse of [Skolem&#8217;s paradox](https://en.wikipedia.org/wiki/Skolem%27s_paradox).
