---
id: 928
title: Running a classical proof with choice in Agda
date: 2011-05-10T23:17:36+02:00
author: Martin Escardo
layout: post
guid: http://math.andrej.com/?p=928
permalink: /2011/05/10/running-a-classical-proof-with-choice-in-agda/
categories:
  - Computation
  - Constructive math
  - Guest post
  - Logic
  - Programming
  - Tutorial
---
As a preparation for my part of a joint tutorial _Programs from proofs_ at [MFPS 27](http://129.81.170.14/~mfps/MFPS27/MFPS_XXVII.html) at the end of this month with [Ulrich Berger](http://www.cs.swan.ac.uk/~csulrich/), [Monika Seisenberger](http://www.cs.swan.ac.uk/~csmona/), and [Paulo Oliva](http://www.eecs.qmul.ac.uk/~pbo/), I&#8217;ve developed in [Agda](http://wiki.portal.chalmers.se/agda/pmwiki.php) some things we&#8217;ve been doing together.

Using

  * [Berardi-Bezem-Coquand functional](http://projecteuclid.org/DPubS?service=UI&version=1.0&verb=Display&handle=euclid.jsl/1183745524)<a>, or alternatively,</a>
  * [Berger-Oliva modified bar recursion](http://journals.cambridge.org/action/displayAbstract?fromPage=online&aid=439279&fulltextType=RA&fileId=S0960129506005093), or alternatively,
  * [Escardo-Oliva countable product of selection functions](http://journals.cambridge.org/action/displayAbstract?fromPage=online&aid=7423096&fulltextType=RA&fileId=S0960129509990351),

for giving a proof term for classical countable choice, we prove the classical infinite pigeonhole principle in Agda: every infinite boolean sequence has a constant infinite subsequence, where the existential quantification is classical (double negated).

As a corollary, we get the finite pigeonhole principle, using Friedman&#8217;s trick to make the existential quantifiers intuitionistic.

This we can run, and it runs fast enough. The point is to illustrate in Agda how we can get witnesses from classical proofs that use countable choice. The finite pigeonhole principle has a simple constructive proof, of course, and hence this is really for illustration only.

The main Agda files are

  * [InfinitePigeon](http://www.cs.bham.ac.uk/~mhe/pigeon/html/InfinitePigeon.html)
  * [FinitePigeon](http://www.cs.bham.ac.uk/~mhe/pigeon/html/FinitePigeon.html)
  * [Examples](http://www.cs.bham.ac.uk/~mhe/pigeon/html/Examples.html)

These are Agda files converted to html so that you can navigate them by clicking at words to go to their definitions. A [zip file](http://www.cs.bham.ac.uk/~mhe/pigeon/Pigeon.zip) with all Agda files is available. Not much more information is available [here](http://www.cs.bham.ac.uk/~mhe/pigeon/).

The three little modules that implement the Berardi-Bezem-Coquand, Berger-Oliva and Escardo-Oliva functionals disable the termination checker, but no other module does. The type of these functionals in Agda is the [J-shift principle](http://portal.acm.org/citation.cfm?id=1876437), which generalizes the double-negation shift.