---
id: 745
title: Subgroups are equalizers, constructively?
date: 2010-11-10T11:09:49+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=745
permalink: /2010/11/10/subgroups-are-equalizers-constructively/
categories:
  - General
---
[**Edit 2010-11-12:** Given the gap in my “proof”, I am changing the title of the post to a question.]

I would like to record the following fact, which is hard to find on the internet: _every subgroup is an equalizer, constructively_. In other words, all monos in the category of groups are regular, constructively. It is interesting that this fact fails if we work in a meta-theory with “poor quotients”.

<!--more-->The usual proof that every subgroup is an equalizer uses classical logic, see for example 7H(a) on page 129 of  

[“Abstract and Concrete Categories - the Joy of Cats”](http://katmat.math.uni-bremen.de/acc/) by Jiri Adámek, Horst Herrlich, George E. Strecker. A [question on MathOverflow](http://mathoverflow.net/questions/41208/are-all-group-monomorphisms-regular-constructively/) motivated me to try to find a constructive proof. In the end it was found by [Monic Win](http://mathoverflow.net/users/9823/monic-win). I reproduce the proof here and also make a couple of further comments.

> **Theorem:** _Every [subgroup](http://en.wikipedia.org/wiki/Subgroup) is an [equalizer](http://en.wikipedia.org/wiki/Equaliser_(mathematics))._
> 
> ___Proof._ A subroup is the equalizer of its cokerenel pair. QED.
> 
> That is a bit cryptic. Let's spell out the details. Consider a subgroup $H$ of a group $G$.  Let $ G *_H G$ be the [free product with amalgamation](http://en.wikipedia.org/wiki/Free_product_of_groups#Generalization:_Free_product_with_amalgamation) of $G$ with respect to the inclusion $H \to G$. Concretely, $G \*_H G$ is the quotient group $(G \* G)/N$ of the [free product](http://en.wikipedia.org/wiki/Free_product) $G \* G$ with respect to the least normal subgroup $N$ that contains elements of the form $\iota\_1(x) \iota\_2(x)^{-1}$ for $x \in H$, where $\iota\_1, \iota\_2 : G \to G \* G$ are the canonical inclusions. Let $q : G \* G \to (G \* G)/N$ be the canonical quotient map and define $f  = q \circ \iota\_1$ and $g = q \circ \iota\_2$. We claim that $H$ is the equalizer of $f$ and $g$: $$H = \{ x \in G \mid f(x) = g(x) \}.$$ If $x \in H$ then $\iota\_1(x) \iota\_2(x)^{-1} \in N$, hence $f(x) g(x)^{-1} = q(\iota\_1(x) \iota\_2(x)^{-1}) = 1\_K$ and so $f(x) = g(x)$. Conversely, suppose $x \in G$ is such that $f(x) = g(x)$. Then $1\_K = f(x) g(x)^{-1} = q(\iota\_1(x) \iota\_2(x)^{-1})$, hence $\iota\_1(x) \iota\_2(x)^{-1} \in N$. The proof is constructive. QED again.

However, the story does not end here. There seems to be a counter-example to the above theorem in the category of  numbered sets (also known as partial [numberings](http://en.wikipedia.org/wiki/Numbering_(computability_theory))). The internal logic of this category is intuitionistic first-order logic with Number choice and Markov principle. Consider the group $G = \mathbb{Z}\_2^\omega$ (countable product of copies of $\mathbb{Z}\_2$) and the subgroup $$H = \lbrace a \in G \mid \exists n \in \mathbb{N} . \forall m \geq n . a\_m = 0\rbrace.$$ In the category of numbered sets all equalizers are $\lnot\lnot$-stable. So, if $H$ were an equalizer this would imply, for all $a \in G$, $\lnot\lnot (a \in H) \Rightarrow a \in H$, which amounts to $$\forall a \in \mathbb{Z}\_2^\omega . (\lnot \forall n \in \mathbb{N} . \exists m \geq n . a\_m = 1) \Rightarrow \exists n \in \mathbb{N} . \forall m \geq n . a\_m = 0$$ where we used Markov principle (can you spot it?). A realizer for the above statement is (a code of) a computable function that accepts (a code of) a total computable function $a : \mathbb{N} \to \lbrace 0, 1 \rbrace$ which does _not_ attain value $1$ infinitely often, and outputs a number $n$ such that $a(m) = 0$ for all $m \geq n$.  Clearly, such a realizer cannot exist as it would allows us to implement the Halting Oracle. Therefore, $H$ is not an equalizer.

What is going on? Well, numbered sets have slightly odd quotients. If $R$ is an equivalence relation on a numbered set $A$  and $q : A \to A/R$ is the canonical quotient map onto the quotient $A/R$ then in numbered sets $q(x) = q(y)$ implies only $\lnot\lnot R(x,y)$, rather than the expected $R(x,y)$. (In the parlance of category theory we say that numbered sets are a regular category which is not [exact in the sense of Barr](http://en.wikipedia.org/wiki/Regular_category#Exact_.28effective.29_categories).) In the proof of our theorem we have a quotient map $q : G \* G \to (G \* G)/N$ and we used the fact that $q(\iota\_1(x)) = q(\iota\_2(x))$ implies $\iota\_1(x) \iota\_2(x)^{-1} \in N$, whereas in numbered sets we are only allowed to conclude $\lnot\lnot (\iota\_1(x) \iota\_2(x)^{-1} \in N)$. Consequently,  in numbered sets the equalizer of $f, g : G \to (G * G)/N$ is the $\lnot\lnot$-closure of $H$, which is in general larger than $H$. The mystery is resolved (for those who are still following), and the counter-example in numbered sets shows that having just a regular category at the meta-level is not enough to conclude that every subgroup is an equalizer. This may have some relevance for minimalist type theories in which quotients misbehave.
