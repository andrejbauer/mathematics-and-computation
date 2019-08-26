---
id: 75
title: The hydra game
date: 2008-02-02T03:13:21+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/2008/02/02/the-hydra-game/
permalink: /2008/02/02/the-hydra-game/
bfa_ata_body_title:
  - The hydra game
bfa_ata_display_body_title:
  - ""
bfa_ata_body_title_multi:
  - The hydra game
bfa_ata_meta_title:
  - ""
bfa_ata_meta_keywords:
  - ""
bfa_ata_meta_description:
  - ""
categories:
  - General
  - Logic
---
Today I lectured about the Hydra game by [Laurence Kirby](http://faculty.baruch.cuny.edu/lkirby/) and [Jeff Paris](http://www.maths.manchester.ac.uk/~jeff/) (_Accessible Independence Results for Peano Arithmetic, Kirby and Paris, Bull. London Math. Soc. 1982; 14: 285-293_). For the occasion I implemented the game in Java. I am publishing the code for anyone who wants to play, or use it for teaching.<!--more-->

#### About the game

A hydra is a finite tree, with a root at the bottom. The object of the game is to cut down the hydra to its root. At each step, you can cut off one of the heads, after which the hydra grows new heads according to the following rules:

  * If you cut off a head growing out of the root, the hydra does not grow any new heads.
  * Suppose you cut off a head like this:  
![](/wp-content/uploads/2008/02/hydra1.gif) Delete the head and its neck. Descend down by 1 from the node at which the neck was attached. Look at the subtree growing from the connection through which you just descended. Pick a natural number, say 3, and grow that many copies of that subtree, like this:![](/wp-content/uploads/2008/02/hydra2.gif)

My program grows $n$ copies at step $n$ of the game, which is one possible variant of the game. There are spoilers ahead, so before you read on you should play the game with the <a href="/wp-content/uploads/2008/02/Hydra/hydraApplet.html" target="hydraApplet">Hydra applet</a> (your browser must support Java) and try to win. Is it possible to win? How should you play to win?

Here is a surprising fact:

> **Theorem 1:** You cannot lose!

The proof uses ordinal numbers. To each hydra we assign an ordinal number:

  * A head gets the number $0$.
  * Suppose a node $x$ has sub-hydras $H\_1, \ldots, H\_n$ growing from it. To each sub-hydra we assign its ordinal recursively and order the ordinals in descending order: $\alpha\_1 \geq \alpha\_2 \geq \ldots \geq \alpha\_n$. The ordinal assigned to the node $x$ is $\omega^{\alpha\_1} + \omega^{\alpha\_2} + \cdots + \omega^{\alpha\_n}$. For example, the ordinal corresponding to the hydra from the first picture above is $\omega^{\omega^3 + 1} + 1$. The hydra in the second picture gets the ordinal $\omega^{\omega^2 \cdot 4 + 1} + 1$.
  * By chopping off a head we strictly decrease the ordinal. Because there are no infinite strictly descending sequences of ordinals, the hydra will eventually die, no matter how you chop off heads.

But Theorem 1 is not the punchline. The punchline is this:

> **Theorem 2 (Kirby and Paris):** Any proof technique that proves Theorem 1 is strong enough to prove that Peano arithmetic is consistent.

Consistency of Peano arithmetic is [Hilbert&#8217;s second problem](http://en.wikipedia.org/wiki/Hilbert%27s_second_problem), which was [solved by Gentzen](http://en.wikipedia.org/wiki/Gentzen's_consistency_proof) in 1936.

#### Download the program

The program is written in Java and is available freely under the [BSD License](http://en.wikipedia.org/wiki/Bsd_license). You may:

  * Get the source code from the GitHub [hydra repository](https://github.com/andrejbauer/hydra).
  * Download **a JAR file** [hydra.jar](/wp-content/uploads/2008/02/hydra.jar "hydra.jar"), suitable for running on your computer as a stand-alone application, for which you need [Java Runtime Environment](http://www.java.com/en/download/index.jsp) (JDK will do as well, of course). It should run when you double-click on it (you may have to convince your computer this is not a security risk).
  * **<a href="/wp-content/uploads/2008/02/Hydra/hydraApplet.html" target="hydraApplet">Try the game online</a> **(you may have to convince your browser that this is not a security risk).