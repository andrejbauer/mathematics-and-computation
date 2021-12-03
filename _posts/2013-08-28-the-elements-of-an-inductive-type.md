---
id: 1535
title: The elements of an inductive type
date: 2013-08-28T16:13:19+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1535
permalink: /2013/08/28/the-elements-of-an-inductive-type/
categories:
  - Constructive math
  - Type theory
  - Tutorial
---
In the HoTT book [issue 460](https://github.com/HoTT/book/issues/460) a question by _gluttonousGrandma_ (where do people get these nicknames?) once more exposed a common misunderstanding that we tried to explain in [section 5.8](http://books.google.si/books?id=LkDUKMv3yp0C&lpg=PA3&dq=homotopy%20type%20theory&pg=PA166#v=onepage&q&f=false) of the book (many thanks to Bas Spitters for putting the book into Google Books so now we can link to particular pages). Apparently the following belief is widely spread, and I admit to holding it a couple of years ago:

> An inductive type contains exactly those elements that we obtain by repeatedly using the constructors.

If you believe the above statement you should keep reading. I am going to convince you that the statement is unfounded, or that at the very least it is preventing you from understanding type theory.

<!--more-->

Let us consider the most famous inductive type, the natural numbers $\mathtt{nat}$. It has two constructors:

  * the constant $0$, called _zero_
  * the unary constructor $S$, called _successor_

So one expects that the elements of $\mathtt{nat}$ are $0$, $S(0)$, $S(S(0))$, ..., and no others. If our type theory is good enough, we can prove a meta-theorem:

> **Metatheorem:** Every closed term of type $\mathtt{nat}$ is of the form $S(S(\cdots S(0) \cdots ))$.

(Incidentally, before another reddit visitor finds it productive to interpret “is of the form” as syntactic equality, let me point out that obviously I mean definitional equality.) This can be a very, very misleading metatheorem if you read it the wrong way. Suppose I told you:

> **Metatheorem:** There are countably many closed terms of type $\mathtt{nat} \to \mathtt{nat}$.

Would you conclude that the type of functions $\mathtt{nat} \to \mathtt{nat}$ is countable? How would that reconcile with the usual [diagonalization proof](http://math.andrej.com/2007/04/08/on-a-proof-of-cantors-theorem/) that $\mathtt{nat} \to \mathtt{nat}$ is uncountable?

Notice that I am carefully labeling above as “metatheorems”. That is because they are telling us something about the _formal language_ that we are using to speak about mathematical objects, _not_ about mathematical objects themselves. We must look at the objects themselves, that is, we must _interpret_ the type in a _model_.

Let us call a model _exotic_ if not every element of (the interpretation of) $\mathtt{nat}$ is obtained by finitely many uses of the successor constructor, starting from zero. Here are some _non-exotic_ models:

  * In set theory the natural numbers are just the usual ones $\mathbb{N}$.
  * In the category of topological spaces and continuous maps the natural numbers are the usual ones, equipped with the discrete topology. (Exercise: why not the indiscrete topology?)
  * In the [syntactic category](http://ncatlab.org/nlab/show/syntactic+category) whose objects are types and whose morphisms are expressions, quotiented by provably equality, the above meta theorem tells us that there are no exotic numbers.

And here are some exotic models:

  * Consider the category of [pointed sets](http://ncatlab.org/nlab/show/pointed+set). Recall that a pointed set $(A, a)$ is a set $A$ with a chosen element $a \in A$, called the _point_.  A morphism $f : (A, a) \to (B, b)$ is a function $f : A \to B$ which preserves the point, $f(a) = b$. Computer scientists can think of the points as special “error” values. You might try to take $(\mathbb{N}, 0)$ as the interpretation of $\mathtt{nat}$. But this cannot be right because that would force $0$ to be always mapped to the point. In fact, the correct thing is to _adjoin_ a new point $\bot$ to $\mathbb{N}$, so we get  $(\mathbb{N} \cup \lbrace \bot \rbrace, \bot)$. The exotic element  $\bot$ does not create any trouble because all morphisms are forced to map it to the point.
  * Consider the [category of sheaves](http://ncatlab.org/nlab/show/category+of+sheaves) on a topological space $X$. The type $\mathtt{nat}$ corresponds to the sheaf of continuous maps into $\mathbb{N}$, where $\mathbb{N}$ is equipped with the discrete topology. The elements corresponding to $0$, $S(0)$, $S(S(0))$, etc. are the constant maps. If $X$ is connected then these are all of them, but otherwise there are going to me many more continuous maps $X \to \mathbb{N}$. For example, if $ X = 2 = \lbrace 0, 1 \rbrace$  is the discrete space on two points, then the object of natural numbers in sheaves on $X$ will constists of _pairs_ of natural numbers because $\mathsf{Sh}(2) = \mathsf{Set} \times \mathsf{Set}$.
  * It would be a crime not to mention the [non-standard models](http://en.wikipedia.org/wiki/Non-standard_model_of_arithmetic), historically the first exotic models (I hope that's correct).  In these the natural numbers obtain many new exotic elements through the [ultrapower](http://en.wikipedia.org/wiki/Ultrapower) construction. (To fit these into our scheme you need to consider the entire set-theoretic model formed by an ultrapower, not just an ultrapower of $\mathbb{N}$.)

In all of these $\mathtt{nat}$ gains new elements through a process of _completion_ which makes sure that the structure obtained has certain properties. In the case of pointed sets the completion process makes sure that there is a distinguished point. In the case of sheaves the completion process is [sheafification](http://ncatlab.org/nlab/show/sheafification), which makes sure that the natural numbers are described by local information. I do not know what the ultrapower construction is doing in terms of it being a completion. (The ultrapower is really a two-step process: first we take a power and then a quotient by an ultrafilter. The power is just a special case of sheaves, so that is a completion process. But in what sense is quotienting a completion process?)

The situation is a bit similar to that of _freely generated_ algebraic structures. The group freely generated by a single generator (constructor) is $\mathbb{Z}$, because in addition to the generator we have to throw in its inverse, square, cube, etc. These are _not_ equal to the generator because there is a group with an element which is not equal to its own inverse, square, cube, etc. If the freely generated group is to be free it must make equal only those things which all groups make equal.

It is therefore better to think of an inductive type as _freely generated._ The generation process throws in everything that can be obtained by successive applications of the constructors, and possibly more, depending on what our model looks like.

Once you convince yourself that the natural numbers really can contain exotic elements, and that this is not just some sort of pathology cooked up by logicians, it should be easier to believe that the identity types may be non-trivial.

Let me further address two issues. The first one is this: in type theory we can _prove_ that every natural number is either zero or a successor of something. Does this not exclude the exotic elements? For instance, in sheaves on the discrete space on two points, how is the element $(0, 42)$ either zero or a successor? It is not zero, because that would be $(0, 0)$, but it is not a successor either because its first component is $0$. Ah, but we must remember the _local character_ of sheaves: in order to establish a disjunction it is sufficent to establish it locally on the elements of a cover. In the case of $\mathsf{Sh}(2)$ we just have to do it separately on each component: the first component of $(0, 42)$ is zero, and the second one is a successor, so all is fine. There is a difference between the _internal_ statement “every number is zero or a successor” and its external meaning.

The second issue is a bit more philosophical. You might dislike certain models, and because of that you deny or ignore arguments that employ them. The reasons for disliking models vary: some people just ignore things they do not know about (“Oh sheaves, I do not know about those, but here is what happens in sets.”), some insist on doing things in certain ways (“We shall only truly understand the Univalence axiom when we have a computational re-interpretation of it in type theory”), and some just believe what they were taught (“Classical set theory suffices for all of mathematics”).

There are any number of theorems in logic which tell us that _the “unintended” models are unavoidable_ (recall for instance the [Löwenheim-Skolem theorem](http://en.wikipedia.org/wiki/L%C3%B6wenheim%E2%80%93Skolem_theorem)). Instead of turning a blind eye to them we should accept them because they allow us to complete an important process in mathematics:

  1. Based on previous mathematical experience, formulate a theory. Examples: 
      * from drawing lines and points, formulate some [geometric axioms](http://en.wikipedia.org/wiki/Projective_geometry#Axioms_of_projective_geometry),
      * from high-school math class, formulate some [arithmetical laws](http://en.wikipedia.org/wiki/Tarski's_high_school_algebra_problem),
      * from ideas of what computation is about, formulate type theory.
  2. Look for other models, even if they are not “desired”. Examples: 
      * discover non-Euclidean geometries,
      * discover [exponential fields](http://en.wikipedia.org/wiki/Exponential_field),
      * discover homotopy-theoretic models of type theory.
  3. Study the new models to gain new mathematical experience.
