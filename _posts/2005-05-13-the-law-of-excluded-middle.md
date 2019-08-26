---
id: 11
title: The Law of Excluded Middle
date: 2005-05-13T11:35:03+02:00
author: Andrej Bauer
excerpt: What constructive mathematics actually says about the law of excluded middle.
layout: post
guid: http://math.andrej.com/2005/05/13/the-law-of-excluded-middle/
permalink: /2005/05/13/the-law-of-excluded-middle/
categories:
  - Constructive math
  - Tutorial
---
Ordinary mathematicians usually posses a small amount of knowledge about logic. They know their logic is _classical_ because they believe in the _Law of Excluded Middle (LEM)_:

> _For every proposition \`p\`, either \`p\` or \`not p\` holds._ 

To many this is a self-evident truth. Therefore they cannot understand why someone would reject such a law, and a useful one at that, since many neat proofs depend on it. An equivalent law of logic is _reductio ad absurdum_ or _proof by contradiction_:

> _For every proposition \`p\`, if \`not p\` does not hold, then \`p\` holds._ 

Constructive mathematicians do indeed reject LEM. But this does not mean they accept its negation! Unfortunately, many ordinary mathematicians seem to think precisely that, and so naturally they conclude that constructive mathematics is garbage. In fact, both classical and constructive mathematics prove quite easily that the negation of LEM is false. So what do constructive mathematicians believe? 

<!--more-->

To explain this a little better, let me phrase LEM in a form that is suitable for this discussion. Suppose we have a set \`D\` and a property \`P(x)\` which is defined for elements \`x in D\`. Then LEM says that, no matter which \`D\` and \`P\` we consider,

> \`forall x in D . P(x) or not P(x)\`. 

Constructive mathematician says that validity of this statement depends on what \`P\` is. It is fairly difficult to explain to a classical mathematician the reasons for rejecting LEM, because constructive and classical mathematicians use the same words to mean different things. The result is that  
to classical mathematicians the constructive ones are like ascetic monks who took some LSD, while to constructive mathematicians the classical ones are like beings from a two-dimensional world who cannot grasp a third dimension. So take some LSD and imagine yourself sitting inside a sheet of paper. 

Imagine that the set \`D\` in the above formulation of LEM is not just an ordinary set but a metric space, or more generally a topological space. Imagine furthermore that the property \`P\` is restricted to be an open subset of \`D\`, that \`not P\` means the topological exterior of \`P\`, and that \`or\` is union (which it is, actually). So now, is it necesssarily the case that \`P or not P\` covers all of \`D\`? It depends on \`P\`, does it not? For example, if we take \`D = RR\`, the real numbers with the usual metric, and \`P = {x in RR ; x > 0}\` then \`not P = {x in RR ; x < 0}\` so \`P or not P = RR - {0} != RR\`! But if we take \`D = NN\`, the natural numbers with discrete topology, then no matter what \`P\` we choose \`P\` and its exterior cover \`NN\`. 

What constructive mathematicians know is that there are mathematical universes in which sets are like topological spaces and properties are like open sets. In fact, these universes are well-known to classical mathematicans (they are called _toposes_), but they look at them from &#8220;the outside&#8221;. When we consider what mathematicians who live in such a universe see, we discover many fascinating kinds of mathematics, which tend to be constructive. The universe of classical mathematics is special because in it all sets are like discrete topological spaces. In fact, one way of understanding LEM is &#8220;all spaces/sets are discrete&#8221;. Is this really such a smart thing to assume? If for no other reason, LEM should be abandonded because it is quite customary to consider &#8220;continuous&#8221; and &#8220;discrete&#8221; domains in applications in computer science and physics. So what gives mathematicians the idea that all domains are discrete? 

Of course, classical mathematicians will easily produce counter-arguments to my explanation of LEM. They will say that sets are _not_ topological spaces, and that those who want to consider discrete and continuous domains are welcome to use topology. But this advice is like telling  
a cur buyer that he cannot buy the Porche, which is ok because a Yugo with a turbo-thrusther attached to it will get him wherever he wants to go just as fast. Why not let computer scientists use the cool sets of constructive mathematics which already behave like the domains they meet in practice? Why force them to use classical sets which then they have to equip with topologies and metrics to get where they want to be?