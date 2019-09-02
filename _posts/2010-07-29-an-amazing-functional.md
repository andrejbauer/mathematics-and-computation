---
id: 532
title: An amazing functional
date: 2010-07-29T14:37:54+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=532
permalink: /2010/07/29/an-amazing-functional/
categories:
  - Computation
  - News
---
[Martin Escard](http://www.cs.bham.ac.uk/~mhe/)o and [Paulo Oliva](http://www.dcs.qmul.ac.uk/~pbo/) have been working on the _selection monad_ and related functionals. The selection monad \`S(X) = (X -> R) -> X\` is a cousin of the continuation monad \`C(X) = (X -> R) -> R\` and it has a lot of useful and surprising applications. I recommend their recent paper _[&#8220;What Sequential Games, the Tychonoff Theorem and the Double-Negation Shift have in Common&#8221;](http://www.cs.bham.ac.uk/~mhe/papers/msfp2010/)_ which they wrote for [MSFP 2010](http://cs.ioc.ee/msfp/msfp2010/) (if you visit the workshop you get to hear Martin live). They explain things via examples written in Haskell, starting off with the innocently looking functional \`ox\` (which i I am writting as `ox` in Haskell for &#8220;crossed O&#8221;):

> <pre>ox :: [(x -&gt; r) -&gt; x] -&gt; ([x] -&gt; r) -&gt; [x]
ox [] p = []
ox (e : es) p = a : ox es (p . (a:))
   where a = e (\x -&gt; p (x : ox es (p . (x:))))</pre>

It is just four lines of code, so how complicated could it be? Well, read the paper to find out. If you are ready for serious math, have a look at [this paper](http://www.cs.bham.ac.uk/~mhe/papers/selection-escardo-oliva.pdf) instead.
