---
id: 217
title: Mathematically Structured but not Necessarily Functional Programming
date: 2009-05-29T08:16:18+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=217
permalink: /2009/05/29/mathematically-structured-but-not-necessarily-functional-programming/
categories:
  - Computation
  - Constructive math
  - Programming
  - RZ
  - Talks
---
These are the slides and the extended abstract from my [MSFP](http://msfp.org.uk/) 2008 talk. Apparently, I forgot to publish them online. There is a discussion on the [Agda](http://wiki.portal.chalmers.se/agda/) mailing list to which the talk is somewhat relevant, so I am publishing now.

**Abstract:** Realizability is an interpretation of intuitionistic logic which subsumes the Curry-Howard interpretation of propositions as types, because it allows the realizers to use computational effects such as non-termination, store and exceptions. Therefore, we can use realizability as a framework for program development and extraction which allows any style of programming, not just the purely functional one that is supported by the Curry-Howard correspondence. In joint work with [Christopher A. Stone](http://www.cs.hmc.edu/~stone/) we developed RZ, a tool which uses realizability to translate specifications written in constructive logic into interface code annotated with logical assertions. RZ does not extract code from proofs, but allows any implementation method, from handwritten code to code extracted from proofs by other tools. In our experience, RZ is useful for specification of non-trivial theories. While the use of computational effects does improve efficiency it also makes it difficult to reason about programs and prove their correctness. We demonstrate this fact by considering non-purely functional realizers for a Brouwerian continuity principle.

**Download:** [msfp2008-slides.pdf](/wp-content/uploads/2009/05/msfp2008-slides.pdf), [msfp2008-abstract.pdf](/wp-content/uploads/2009/05/msfp2008-abstract.pdf)