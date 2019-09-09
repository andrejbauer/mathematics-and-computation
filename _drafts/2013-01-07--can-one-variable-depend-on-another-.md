---
author: admin
title: "\n\t\t\t\tCan one variable depend on another?\t\t"
slug: '-can-one-variable-depend-on-another-'
id: 1413
date: '2013-01-07 21:41:14'
layout: draft
categories:
  - General
---

On [MathOverflow I whined](http://mathoverflow.net/questions/118254/usage-of-set-theory-in-undergraduate-studies/118261) (I really should easy up a bit) about this and that, and among other things I claimed that we should never say to our students that "one variable depends on another" because it is harmful in many respects. And then [John Bentin](http://mathoverflow.net/users/7458/john-bentin) asked: _"If we define (say) $y {:}{=} x^2 + 1$, then what is wrong with saying that (the variable) $y$ depends on (the variable) $x$?"_ Indeed, what is wrong it? Mathematicians are quite bad at handling certain kinds of syntax. They confuse expressions, functions and variables all the time. The best cure I know is functional programming, or even better, a proof assistant. Computers refuse to take the kind of nonsense that we feed to our students, not because they are evil or stupid, but because they cannot understand things that make no sense. Let me show you. A mathematician might say: "Let $y = x^2 + 1$. Then $y$ is a differentiable function." In Coq this would be: [source] Definition y := x * x + 1. [/source] The response is: "`Error: The reference x was not found in the current environment.`" Ok, this is understandable, we need to tell Coq that $x$ ranges over the reals, something that mathematicians are able to guess from the surrounding context. We try again: [source] Require Import Reals. (* Import the reals library. *) Open Scope R_scope. (* Turn on notation for real arithmetic. *) Variable x : R. (* Declare a real variable x. *) Definition y := x * x + 1\. (* Define y. *) [/source] Now it works. But when we ask Coq what $y$, it tells us that it is a real number, not a function: [source] Coq < Check y. y : R [/source] Of course, since $x$ is a real number, also $x^2 + 1$ is a real number, and $y$ is defined to be $x^2 + 1$. If we want to make $y$ into a function, we must instead define it like this: [source] Require Import Reals. Open Scope R_scope. Definition y x := x * x + 1. [/source] Now Coq says that `y` has type `R -> R`. Notice how it is smart enough to tell from the surrounding context that `x` has type `R`, just like mathematicians do. (And that is just a little thing, Coq has become really smart at guessing witheld information that mathematicians usually guess.)