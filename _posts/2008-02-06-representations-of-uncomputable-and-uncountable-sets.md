---
id: 83
title: Representations of uncomputable and uncountable sets
date: 2008-02-06T12:27:10+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/2008/02/06/representations-of-uncomputable-and-uncountable-sets/
permalink: /2008/02/06/representations-of-uncomputable-and-uncountable-sets/
categories:
  - Computation
  - Tutorial
---
Occasionally I hear claims that uncountable and uncomputable sets cannot be represented on computers. More generally, there are all sorts of misguided opinions about representations of data on computers, especially infinite data of mathematical nature. Here is a quick tutorial on the matter whose main point is:

> It is _meaningless_ to discuss representations of a set by a datatype without also considering operations that we want to perform on the set.

<!--more-->

  
Unless you tell me what it is that you would like to _compute_ about the set, I can represent it whichever way I want. You will never look at my representation because you will never do anything with the elements of your set. By this line of reasoning you can represent any set $X$ simply by the [unit type](http://en.wikipedia.org/wiki/Unit_type), which has a single element $()$. Naturally, you will object that this makes little sense because all elements of $X$ would have the same representation. But that means you _do_ care about the structure of $X$: you are interested in the inequality relation on $X$.

For a less trivial but still silly example, consider the set of all Turing machines. The famous [halting problem](http://en.wikipedia.org/wiki/Halting_problem) asks for an algorithm that decides, given a description of a Turing machine $T$, whether $T$ halts when we run it on the empty tape. Such an algorithm is easy to obtain if all we care about is the halting problem. Simply represent each Turing machine $T$ with a bit which is $1$ if $T$ halts and $0$ if it does not. This way it is really easy to decide whether $T$ halts. Silly? Yes, but it makes a point: it is not the set we really want to represent but a set _together_ with relevant operations on it. What are the relevant operations on Turing machines? Essentially, we want a representation which makes the [u-t-m](http://en.wikipedia.org/wiki/Utm_theorem) and [s-m-n](http://en.wikipedia.org/wiki/Smn_theorem) theorems true. The former says that the representation should be such that we can compute what happens when we apply a Turing machine to an input, and the latter that the [currying](http://en.wikipedia.org/wiki/Currying) operation should be computable. One can prove that any such representation has an undecidable Halting problem. That is much better.

In general, we can make any function $f : X \to Y$ whatsoever computable if we are allowed to change the representation of $X$: represent elements $x in X$ as pairs $(a, b)$ where $a$ represents $x$ (in the original representation of $X$) and $b$ represents $f(x)$ in the representation of $Y$. The function $f$ then becomes easily computable as the first projection: given a pair $(a,b)$ representing $x$, the value $f(x)$ is represented by $b$.

Sometimes it is quite hard to discover which operations on a set are “relevant”. What would you say is the relevant structure of real numbers $\mathbb{R}$? Specialists in computable mathematics disagree about the answer. Everyone wants computable arithmetic operations $+$, $-$, $\times$, $/$ and computable constants $0$ and $1$, but what else? If you say that the relation $<$ should be computable as a function from $\mathbb{R}$ to boolean truth values, you are in [good company](http://en.wikipedia.org/wiki/Blum_Shub_Smale_machine), although you have opted for a rather unrealistic model of real number computation. It is much more reasonable to require that $<$ be computable as a function from $\mathbb{R}$ to [_semidecidable_](http://en.wikipedia.org/wiki/Semidecidable) truth values.  
In essence, the relevant structure of the reals is that of a [Dedekind complete Archimedean ordered field which is also overt, Hausdorff, and locally compact](/2005/07/27/the-dedekind-reals-in-abstract-stone-duality/). No, wait! The relevant structure is that of a [Cauchy complete Archimedean ordered field](/2007/04/12/implementing-real-numbers-with-rz/)! Oh no, I disagree with myself!

At least the good news is that once we have settled the relevant mathematical structure of a set, we can [automatically compute](/rz/) a description of its computer representation.

Remember then, when you see someone claiming that such-and-such set is not representable by a computer, you should always ask “but what _operations_ on the set do you want to compute with?”

### Representing uncountable sets

There are two popular arguments which allegedly show that we cannot represent uncountable sets by computers:

  1. Computers represent everything by finite sequences of 0's and 1's. There are only countably many such sequences, therefore, we cannot represent an uncountable set.
  2. Even if we allow infinite binary streams, we will be able to actually use only the _computable_ ones, and there are only countably many of those.

It is true that there are only countably many finite sequences of 0's and 1's. To be more precise, there are _computably_ countably many such sequences because there is a program that enumerates them. But did you know that a computably countable set may contain subsets which fail to be computably countable? For example, the set of all Turing machines is computably countable, but the subset of those Turing machines which do not halt is not. The first argument relies on the fact that we are talking about _arbitrary_ enumerations, including non-computable ones.

In fact, if we take computability seriously, the second argument immediately fails because the set of computable infinite streams of 0's and 1's is _computably uncountable_ by a famous [diagonal argument](/2007/04/08/on-a-proof-of-cantors-theorem/). (Note that “computably uncountable” is more than “not computably countable”: the former means that given any enumeration we can compute an element outside the enumeration, while the latter just says that there is no enumeration of all elements.) The second argument stands only if we mix “computable” and “non-computable” ingredients in just the right way.

Even if we disregard the theoretical issues about computable vs. non-computable enumerations, we are still left with the question whether _real_ computers “contain” non-computable sequences. Do they? Does the universe? Or do you claim that all streams of 0's and 1's that physicists are able to feed into computers are definitely computable? Perhaps physicists should devise an experiment that would tell us something about existence of non-computable streams. I think we would quickly discover that such an experiment is in principle impossible because we may only ever observe finite prefixes of a binary stream. According to the [Verification principle](http://en.wikipedia.org/wiki/Verification_principle) this makes the question meaningless and any position about its truth an article of faith.

To conclude, let us then say that computers _can_ represent _all_ infinite binary streams of our universe, because computers are equipped with I/O devices that let them interact with the universe. Whether there are uncountably many binary streams in the universe is a matter of faith if you are a human physicist trained in classical logic. If you are a computer the matter is clear: there are computably uncountably many binary streams.

A much more interesting question is whether the space of binary streams is [_compact_](http://en.wikipedia.org/wiki/Compact_space), but that is another story.
