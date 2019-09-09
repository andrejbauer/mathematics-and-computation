---
author: admin
title: "\n\t\t\t\tDependent products and sums as adjoints\t\t"
slug: '-dependent-products-and-sums-as-adjoints-'
id: 2026
date: '2019-03-21 23:22:46'
layout: draft
categories:
  - General
---

Every once in a while someone asks about an accessible explanation of the often cited fact that dependent products and sums are adjoint to substitution, so let us have a look at how this goes in the simplest case, namely the set-theoretic model of dependent type theory.

Let us quickly review the set-theoretic model. Types and contexts are sets. A substitition $$\sigma : \Delta \to \Gamma$$ between contexts is a function between the sets $\Delta$ and $\Gamma$. A dependent type $\Gamma \vdash B \ \mathsf{type}$ is a family of sets $B : \Gamma \to \mathsf{Set}$.

A substitution $\sigma : \Delta \to \Gamma$ acts on $B$ to give a type $\Delta \vdash \sigma^{\star} B \ \mathsf{type}$ where $\sigma^{\star} B = B \circ \sigma$. Let us write $\mathsf{Set}^\Gamma$ for the collection of all families of sets indexed by $\Gamma$. The action of the substitition $\sigma$ may be seen as a mapping $$\sigma^\star : \mathsf{Type}^{\Gamma} \to \mathsf{Type}^{\Delta}.$$ In fact, we can turn $\mathsf{Type}^{\Gamma}$ into a category and $\sigma^\star$ into a functor. A morphism from a family $B : \Gamma \to \mathsf{Set}$ to $C : \Gamma \to \mathsf{Set}$ is a family of maps $f_\gamma : B(\gamma) \to C(\gamma)$, indexed by $\gamma \in \Gamma$ (a type-theorist would point out that $f$ is a dependent function of type $\prod_{\gamma : \Gamma} B(\gamma) \to C(\gamma)$).