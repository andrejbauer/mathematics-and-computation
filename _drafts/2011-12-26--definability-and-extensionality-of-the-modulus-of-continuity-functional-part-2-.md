---
author: admin
title: "\n\t\t\t\tDefinability and extensionality of the modulus of continuity functional, part 2\t\t"
slug: >-
  -definability-and-extensionality-of-the-modulus-of-continuity-functional-part-2-
id: 1101
date: '2011-12-26 10:07:37'
layout: draft
categories:
  - General
---

This is the second part of the proof that in [PCF](http://en.wikipedia.org/wiki/Programming_language_for_Computable_Functions) we cannot define the modulus of continuity functional. In an [earlier post](/2011/07/27/definability-and-extensionality-of-the-modulus-of-continuity-functional/), which you may want to consult, we showed

> **Theorem:** _There is no extensional modulus of continuity functional._

We still need to prove that every total functional which can be defined in PCF is extensional. The proof I know goes via [domain theory](http://en.wikipedia.org/wiki/Domain_theory), but Bob Harper tells me there's a corresponding "operational" proof. Perhaps he'll explain it in a comment. We first need to fix a notion of domain. Luckily, just about anything will do, so let us take the simplest kind of domains. Recall that a _chain_ in a partially ordered set $(P, {\leq})$ is an increasing sequence $x_0 \leq x_1 \leq x_2 \cdots$ and that a poset is _pointed_ if it has a least element $\perp$.

> **Definition:** A _pointed $\omega$-chain complete poset ($\omega$-cppo)_ is a pointed partially ordered set in which every chain has a supremum.

We shall call such posets _domains_. A map between domains is _continuous_ if it preserves suprema of chains. The next step is to give an interpretation of PCF in terms of domains.