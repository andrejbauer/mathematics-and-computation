---
id: 12
title: How many is two?
date: 2005-05-16T00:07:43+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/2005/05/15/how-many-is-two/
permalink: /2005/05/16/how-many-is-two/
categories:
  - Constructive math
  - Logic
  - Tutorial
---
In constructive mathematics even very small sets can be quite a bit more interesting than in classical mathematics. Since you will not believe me that sets with at most one element are very interesting, let us look at the set of truth values, which has “two” elements.

<!--more-->

A _truth value_ is represented by a sentence, such as \`2 + 3 = 5\` or \`forall x in R exists n in N . x < n\`. (Recall that there are no free parameters in a sentence; when we do allow free parameters we speak of _propositions_, so \`x^2 + y^2 = z^2\` and \`exists x in R . x^2 = y\` are propositions, not sentences). Sentences \`p\` and \`q\` represent the same truth value if they are logically equivalent. The set of all truth values is usually denoted by \`Omega\`.

How many elements does \`Omega\` have? The constants \`TT\` and \`\_|\_\` which represent truth and falsehood, respectively, are truth values. So we have \`TT in Omega\` and \`\_|\_ in Omega\`. That's two elements. In classical logic, these are the only two, by which we mean that every \`p in Omega\` is equal either to \`TT\` or to \`\_|\_\` (because either \`p\` or \`not p\`). In constructive logic, however, this is not the case. But this does not mean there is a third truth value, which is different from both \`TT\` and \`\_|\_\`! How can that be? In order to explain this properly, we must be careful about what it means for a set to have “two elements”: For a set \`A\`, say that:

  * _\`A\` has_ _two elements in the strong sense_ if there are \`x, y in A\` such that \`x != y\` and, for all \`z in A\` either \`z = x\` or \`z = y\`.
  * _\`A\` has_ _two elements in the weak sense_ if there are \`x, y in A\` such that \`x != y\` and, for all \`z in A\` it is not the case that \`z\` is distinct from both \`x\` and \`y\`.

To a classically trained mind there is no difference between the two senses of having two elements. Computationally speaking, however, there is a difference:

  * \`A\` has two elements in the strong sense if we can compute \`x in A\` and \`y in A\` such that \`x != y\`, and there is an algorithm for deciding, given any \`z in A\`, whether \`z = x\` or \`z = y\`.
  * \`A\` has two elements in the weak sense if we can compute \`x in A\` and \`y in A\` such that \`x != y\`, and there is no \`z in A\` that is distinct from both \`x\` and \`y\` (but there may be no algorithm for deciding, given \`z in A\`, whether it equals \`x\` or \`y\`).

Clearly, having two elements in the strong sense requires more (a decision procedure) than having two elements in the weak sense. In classical logic \`Omega\` has two elements in the strong sense. In constructive logic it has two elements in the weak sense, which we can prove as follows. Take \`x = TT\` and \`y = \_|\_\`. Given any \`z in Omega\` we must prove \`not (z != x and z != y)\`, which is logically equivalent to \`not (not z and not not z)\`, which is true (exercise, someone post a solution please).

Does this mean that constructive logic denies that \`Omega\` has two elements in the strong sense? No, it leaves the question unanswered, because constructive logic is “backward compatible” with classical logic.

You may have been thinking all along that \`Omega\` is the same thing as the type `bool` that many programming languages have. This is not the case. First of all, unless your programming language is very limited, `bool` has ___three_ elements: `true`, `false` and “undefined”, which is represented by a diverging expression such as `while true do done; true`. But even if we discount the udefined value, `bool` is only a subset of \`Omega\`, namely the set of _decidable_ truth values, which is usually denoted by \`2\`:

> \`2 = {p in Omega ; p or not p}\`.

What are the elements of \`2\`? Since \`TT or not TT = TT or \_|\_ = TT\` and \`\_|\_ or not \_|\_ = \_|\_ or TT = TT\` we have \`TT in 2\` and \`\_|\_ in 2\`. And given any \`p in 2\`, we know that \`p or not p\`. If \`p\` then \`p = TT\`, and if \`not p\` then \`p = \_|\_\`. We have proved that \`2\` has two elements in the strong sense.

To add to the confusion, there is also the set of classical truth values,

> \`Omega_c = {p in Omega ; p iff not not p}\`.

It consists of those truth values that satisfy the rule Reductio ad Absurdum (proof by contradiction).  
Since \`not not TT = not \_|\_ = TT\` and \`not not \_|\_ = not TT = \_|\_\` we see that \`TT in Omega\_c\` and \`\_|_ in Omega_c\`. We thus have a chain of inclusions

> \`2 sube Omega_c sube Omega\`.

Having three possibly distinct sets, all of which have “two elements”, arranged like this seems useless and unnecessarily complicated. But this is really quite useful, actually. The smallest one, \`2\`, is the datatype `bool` that we all know from programming. The middle one, \`Omega_c\`, is “classical logic sitting inside constructive logic”. So even though we might not accept classical logic, we still have it at our disposal. The largest one, \`Omega\`, is useful because, well, because it is the set of truth values.

Your brain may still object to all of this. In classical mathematics, \`2 = Omega_c = Omega\`, end of story. While you were taught in school that this is the case, it is not what you personally believe, at least not if you are a programmer. Remembering that \`2\` is the datatype `bool`, the assumption \`2 = Omega\` means “we can compute with truth values”. If this is really so, we should be able to write programs that compute the basic logical operations on \`Omega\`, yes? And so indeed logical disjunction, conjunction and negation are usually easily available as operations in typical programming languages. But let us not forget that \`forall\` and \`exists\` are also logical operations. Why are they not available in typical programming languages? If you are correct in your belief that \`2 = Omega\`, you should be able to write a program that takes as input a boolean function \`f : NN -> 2\` and outputs the truth value \`forall n in N. f(n)\`. Can you do it?
