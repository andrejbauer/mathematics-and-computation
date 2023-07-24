---
title: Continuity principles and the KLST theorem
author: Andrej Bauer
layout: post
categories:
  - Constructive math
  - Synthetic computatibility
---

On the occasion of Dieter Spreen's 75th birthday there will be a Festschrift in the [Journal of Logic and Analysis](http://logicandanalysis.org/index.php/jla). I have submitted a paper *“Spreen spaces and the synthetic Kreisel-Lacombe-Shoenfield-Tseitin theorem”*, available as a preprint [arXiv:2307.07830](https://arxiv.org/abs/2307.07830),  that develops a constructive account of Dieter's generalization of a famous theorem about continuity of computable functions. In this post I explain how the paper fits into the more general topic of continuity principles.

<!--more-->

A **continuity principle** is a statement claiming that all functions from a given class are continuous. A silly example is the statement

> *Every map $f : X \to Y$ from a discrete space $X$ is continuous.*

The dual

> *Every map $f : X \to Y$ to an indiscrete space $Y$ is continuous.*

is equally silly, but these two demonstrate what we mean.

In order to find more interesting continuity principles, we have to look outside classical mathematics.
A famous continuity principle was championed by Brouwer:

> **Brouwer's continuity principle:** *Every $f : \mathbb{N}^\mathbb{N}\to \mathbb{N}$ is continuous.*

Here continuity is taken with respect to the discrete metric on $\mathbb{N}$ and the complete metric on $\mathbb{N}^\mathbb{N}$ defined by

$$\textstyle d(\alpha, \beta) = \lim_n 2^{-\min \lbrace k \in \mathbb{N} \,\mid\, k = n \lor \alpha_k \neq \beta_k\rbrace}.$$

The formula says that the distance between $\alpha$ and $\beta$ is $2^{-k}$ if $k \in \mathbb{N}$ is the least number such that $\alpha_k \neq \beta_k$. (The limit is there so that the definition works constructively as well.) Brouwer's continuity principle is valid in the [Kleene-Vesley topos](https://ncatlab.org/nlab/show/function+realizability).

In the [effective topos](https://ncatlab.org/nlab/show/effective+topos) we have the following continuity principle:

> **KLST continuity principle:** *Every map $f : X \to Y$ from a complete separable metric space $X$ to a metric space
> $Y$ is continuous.*

The letters K, L, S, and T are the initials of
[Georg Kreisel](https://en.wikipedia.org/wiki/Georg_Kreisel),
[Daniel Lacombe](https://mathgenealogy.org/id.php?id=290439),
[Joseph R. Shoenfield](https://en.wikipedia.org/wiki/Joseph_R._Shoenfield), and
[Grigori Tseitin](https://en.wikipedia.org/wiki/Grigori_Tseitin),
who proved various variants of this theorem in the context of computability theory (the above version is closest to Tseitin's).

A third topos with good continuity principles is Johnstone's [topological topos](https://doi.org/10.1112/plms/s3-38.2.237), see Section 5.4 of Davorin Lešnik's [PhD dissertaton](https://arxiv.org/abs/2104.10399) for details.

There is a systematic way of organizing such continuity principles with [synthetic topology](https://ncatlab.org/nlab/show/synthetic+topology). Recall that in synthetic topology we start by axiomatizing an object $\Sigma \subseteq \Omega$ of “open truth values”, called a [dominance](https://ncatlab.org/nlab/show/dominance), and define the **intrinsic topology** of $X$ to be the exponential $\Sigma^X$. This idea is based on an observation from traditional topology: the topology a space $X$ is in bijective correspondence with continuous maps $\mathcal{C}(X, \mathbb{S})$, where $\mathbb{S}$ is the [Sierpinski space](https://en.wikipedia.org/wiki/Sierpiński_space).

Say that a map $f : X \to Y$ is **intrinsically continuous** when the invese image map $f^\star$ maps intrinsically open sets to intrinsically open sets.

> **Intrinsic continuity principle:** *Every map $f : X \to Y$ is intrinsically continuous.*

*Proof.* The inverse image $f^\star(U)$ of $U \in \Sigma^Y$ is $U \circ f \in \Sigma^X$. □

Given how trivial the proof is, we cannot expect to squeeze much from the intrinsic continuity principle. In classical mathematics the principle is trivial because there $\Sigma = \Omega$, so all intrinsic topologies are discrete.

But suppose we knew that the intrinsic topologies of $X$ and $Y$ were **metrized**, i.e., they coincided with metric topologies induces by some metrics $d_X : X \times X \to \mathbb{R}$ and $d_Y : Y \times Y \to \mathbb{R}$. Then the intrinsic continuity principle would imply that every map $f : X \to Y$ is continuous  with respect to the metrics. But can this happen? In “[Metric spaces in synthetic topology](https://doi.org/10.1016/j.apal.2011.06.017)” by Davorin Lešnik and myself we showed that in the Kleene-Vesley topos the intrinsic topology of a complete separable metric space is indeed metrized. Consequently, we may factor Brouwer's continuity principles into two facts:

1. Easy general fact: the intrinsic continuity principle.
2. Hard specific fact: in the Kleene-Vesley topos the intrinsic topology of a complete separable metric space is metrized.

Can we similarly factor the KLST continuity principle? I give an affirmative answer in the [submitted
paper](https://arxiv.org/abs/2307.07830), by translating Dieter Spreen's “[On Effective Topological
Spaces](https://doi.org/10.2307/2586596)” from computability theory and numbered sets to synthetic topology. What comes
out is a new topological separation property:

> **Definition:** A **Spreen space** is a topological space $(X, \mathcal{T})$ with the following separation property:
> if $x \in X$ is separated from an overt $T \subseteq X$ by an intrinsically open subset, then it is already separated
> from it by a $\mathcal{T}$-open subset.

Precisely, a Spreen space $(X, \mathcal{T})$ satisfies: if $x \in S \in \Sigma^X$ and $S$ is disjoint from an overt $T \subseteq X$, then there is an open $U \in \\mathcal{T}$ such that $x \in U$ and $U \cap T = \emptyset$. The synthetic KLST states:

> **Synthetic KLST continuity principle:** *Every map from an overt Spreen space to a pointwise regular space is pointwise continuous.*

The proof is short enough to be reproduced here. (I am skipping over some details, the important one being that we require
open sets to be intrinsically open.)

*Proof.* Consider a map $f : X \to Y$ from an overt Spreen space $(X, \mathcal{T}_X)$ to a regular space $(Y, \mathcal{T}_Y)$. Given any $x \in X$ and $V \in \mathcal{T}_Y$ such that $f(x) \in V$, we seek $U \in \mathcal{T}_X$ such that $x \in U \subseteq f^\star(V)$. Because $Y$ is regular, there exist disjoint $W_1, W_2 \in \mathcal{T}_Y$ such that $x \in W_1 \subseteq V$ and $V \cup W_2 = Y$. The inverse image $f^\star(W_1)$ contains $x$ and is intrinsically open. It is also disjoint from $f^\star(W_2)$, which is overt because it is an intrinsically open subset of an overt space. As $X$ is a Spreen space, there exists $U \in \mathcal{T}_X$ such that $x \in U$ and $U \cap f{*}(W_2) = \emptyset$, from which $U \subseteq V$ follows. □

Are there any non-trivial Spreen spaces? In classical mathematics every Spreen space is discrete, so we have to look elsewhere. I show that they are plentiful in synthetic computability:

> **Theorem (synthetic computability):** *Countably based sober spaces are Spreen spaces.*

Please consult the paper for the proof.

There is an emergent pattern here: take a theorem that holds under very special circumstances, for instance in a specific topos or in the presence of anti-classical axioms, and reformulate it so that it becomes generally true, has a simple proof, but in order to exhibit some interesting instances of the theorem, we have to work hard. What are some other examples of such theorems? I know of one, namely [Lawvere's fixed point theorem](https://ncatlab.org/nlab/show/Lawvere%27s+fixed+point+theorem). It took some effort to produce non-trivial examples of it, once again in synthetic computability, see [On fixed-point theorems in synthetic computability](https://math.andrej.com/2019/11/07/on-fixed-point-theorems-in-synthetic-computability/).
