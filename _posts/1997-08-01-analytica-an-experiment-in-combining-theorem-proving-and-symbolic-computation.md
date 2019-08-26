---
id: 17
title: 'Analytica &mdash; An Experiment in Combining Theorem Proving and Symbolic Computation'
date: 1997-08-01T00:01:08+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=17
permalink: /1997/08/01/analytica-an-experiment-in-combining-theorem-proving-and-symbolic-computation/
categories:
  - Publications
---
with [Edmund Clarke](http://www.cs.cmu.edu/~emc/) and Xudong Zhao. 

**Abstract:** Analytica is an automatic theorem prover for theorems in elementary analysis. The prover is written in Mathematica language and runs in the [Mathematica](http://www.wolfram.com/) environment. The goal of the project is to use a powerful symbolic computation system to prove theorems that are beyond the scope of previous automatic theorem provers. The theorem prover is also able to deduce correctness of certain simplification steps that would otherwise not be performed. We describe the structure of Analytica and explain the main techniques that it uses to construct proofs. Analytica has been able to prove several non-trivial theorems. In this paper, we show how it can prove a series of lemmas that lead to Bernstein approximation theorem. 

**Published in:** Journal of Automated Reasoning, Vol. 21, no.3 (1998) 295-325 

**Download:** [analytica.pdf](/data/analytica.pdf "Analytica - An Experiment in Combining Theorem Proving and Symbolic Computation"), [analytica.ps.gz](/data/analytica.ps.gz "Analytica - An Experiment in Combining Theorem Proving and Symbolic Computation") 

**Source code:** [analytica.tar.gz](/data/analytica.tar.gz "Analytica theorem prover") contains the source code for Analytica. It works under Mathematica 2.2.2. I do not plan to port it to a newer version of Mathematics. If you do that, please let me know.