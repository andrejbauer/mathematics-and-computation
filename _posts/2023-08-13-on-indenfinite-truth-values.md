---
title: On indefinite truth values
author: Andrej Bauer
layout: post
categories:
  - Logic
---

In a discussion following a [MathOverflow answer](https://mathoverflow.net/a/452512/1176) by [Joel Hamkins](https://jdh.hamkins.org), [Timothy Chow](http://timothychow.net) and I got into a chat about what it means for a statement to “not have a definite truth value”. I need a break from writing the paper on countable reals (coming soon in a journal near you), so I thought it would be worth writing up my view of the matter in a blog post.

<!--more-->

How are we to understand the statement “the Riemann hypothesis (RH) does not have a definite truth value”?

Let me first address two possible explanations that in my view have no merit.

First, one might suggest that “RH does not have a definite truth value” is the same as “RH is neither true nor false”.
This is nonsense, because “RH is neither true nor false” is the statement $\neg \mathrm{RH} \land \neg\neg\mathrm{RH}$, which is just false by [the law of non-contradiction](https://en.wikipedia.org/wiki/Law_of_noncontradiction). No discussion here, I hope. Anyone claiming “RH is neither true nor false” must therefore mean that they found a paradox.

Second, it is confusing and even harmful to drag into this discussion syntactically invalid, ill-formed, or otherwise corrupted statements. To say something like “$(x + ( - \leq 7$ has no definite truth value” is meaningless. The notion of truth value does not apply to arbitrary syntactic garbage. And even if one thinks this is a good idea, it does not apply to RH, which is a well-formed formula that can be assigned meaning.

Having disposed of ill-fated attempts, let us ask what the precise mathematical meaning of the statement might be. It is important to note that we are discussing semantics. The *truth value* of a sentence $P$ is an element $I(P) \in B$ of some Boolean algebra $(B, 0, 1, {\land}, {\lor}, {\lnot})$, assigned by an interpretation function $I$. (I am assuming classical logic, but nothing really changes if we switch to intuitionistic logic, just replace Boolean algebras with Heyting algebras.) Taking this into account, I can think of three ways of explaining “RH does not have a definite truth value”:

1. The truth value $I(\mathrm{RH})$ is neither $0$ nor $1$. (Do not confuse this meta-statement with the object-statement $\neg \mathrm{RH} \land \neg\neg\mathrm{RH}$.) Of course, for this to happen one has to use a Boolean algebra that contains something other than $0$ and $1$.

2. The truth value of $I(\mathrm{RH})$ varies, depending on the model and the interpretation function. An example of this phenomenon is the [continuum hypothesis](https://en.wikipedia.org/wiki/Continuum_hypothesis), which is true in some set-theoretic models and false in others. 

3. The interpretation function $I$ fails to assign a truth value to $\mathrm{RH}$.

Assuming we have set up sound and complete semantics, the first and the second reading above both amount to undecidability of RH. Indeed, if the truth value of RH is not $1$ across all models then RH is not provable, and if it is not fixed at $0$ then it is not refutable, hence it is undecidable. Conversely, if RH is undecidable then its truth value in the [Lindenbaum-Tarski algebra](https://en.wikipedia.org/wiki/Lindenbaum–Tarski_algebra) is neither $0$ nor $1$. We may quotient the algebra so that the value becomes true or false, as we wish.

The third option says that one has got a lousy interpretation function and should return to the drawing board.

In some discussions “RH does not have a definite truth value” seems to take on an anthropocentric component. The truth value is indefinite because knowledge of it is lacking, or because there is a cognitive barrier to comprehending the statement, etc. I find these just as unappealing as the [Brouwerian counterexamples](https://en.wikipedia.org/wiki/Constructive_proof#Brouwerian_counterexamples) arguing in favor of intuitionistic logic.

The only realm in which I reasonably comprehend “$P$ does not have a definite truth value” is pre-mathematical, or even philosophical. It may be the case that $P$ refers to pre-mathematical concepts lacking precise formal description, or whose existing formal descriptions are considered problematic. This situation is similar to the third one above, but cannot be just dismissed as technical deficiency. An illustrative example is Solomon Feferman's [Does mathematics need new axioms?](https://doi.org/10.1080/00029890.1999.12005017) and the discussion found therein on the meaningfulness and the truth value of the continuum hypothesis. (However, I am not aware of anyone seriously arguing that the mathematical meaning of Riemann hypothesis is contentious.)

So, what do I mean by “RH does not have a definite truth value”? Nothing, I would never say that and I do not understand what it is supposed to mean. RH clearly has a definite truth value, in each model, and with some luck we are going to find out which one. (To preempt a counter-argument: the notion of “standard model” is a mystical concept, while those stuck in an “intended model” suffer from lack of imagination.)

