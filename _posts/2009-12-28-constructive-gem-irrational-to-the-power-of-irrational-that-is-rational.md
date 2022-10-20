---
id: 410
title: 'Constructive gem: irrational to the power of irrational that is rational'
date: 2009-12-28T09:03:37+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=410
permalink: /2009/12/28/constructive-gem-irrational-to-the-power-of-irrational-that-is-rational/
categories:
  - Gems and stones
  - Constructive math
---
The following argument is [often cited](http://en.wikipedia.org/wiki/Law_of_the_excluded_middle#Examples) as an example of the necessity of the law of excluded middle and classical logic. We are supposed to demonstrate the existence of two irrational numbers $a$ and $b$ such that their power $a^b$ is rational. By the law of excluded middle, $\sqrt{2}^{\sqrt{2}}$ is rational or not. If it is rational, take $a = b = \sqrt{2}$, otherwise take $a = \sqrt{2}^{\sqrt{2}}$ and $b = \sqrt{2}$. In either case $a^b$ is rational. Let us think about this for a moment, from constructive point of view.

<!--more-->The law of excluded middle is supposed to be used in an essential way here because we do not know whether $\sqrt{2}^{\sqrt{2}}$ is rational. As a matter of fact, it is irrational, so the “essential” use stems from our supposed ignorance, not from a genuine mathematical fact. The argument therefore demonstrates that the law of excluded middle is an excellent way of supporting one's ignorance (which can be good in many ways, just like good programming languages support programmer's laziness).

But how hard is it to give a concrete example of two irrational numbers $a$ and $b$ such that $a^b$ is rational? Not hard at all! Take $a = \sqrt{2}$ and $b = 2 \log\_2 3$. It is easy to prove that both are irrational, in fact showing that $b$ is irrational is easier than showing that $a$ is. And we have $a^b = 2^{\log\_2 3} = 3$. After seeing this _constructive_ argument, the _classical_ one looks even sillier and just an uneccesary complication. The moral of the story is that constructive mode of thinking should be the default because it produces simpler and concrete mathematics. Only switch to the classical mode if you really have to (and even then, don't).
