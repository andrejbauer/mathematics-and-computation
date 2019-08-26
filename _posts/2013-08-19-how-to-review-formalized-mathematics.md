---
id: 1462
title: How to review formalized mathematics
date: 2013-08-19T14:10:34+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1462
permalink: /2013/08/19/how-to-review-formalized-mathematics/
categories:
  - Coq
  - General
---
Recently I reviewed a paper in which most proofs were done in a proof assistant. Yes, the machine guaranteed that the proofs were correct, but I still had to make sure that the authors correctly formulated their definitions and theorems, that the code did not contain hidden assumptions, that there were no unfinished proofs, and so on.

In a typical situation an author submits a paper accompanied with some source code which contains the formalized parts of the work. Sometimes the code is enclosed with the paper, and sometimes it is available for download somewhere. **_It is easy to ignore the code!_** The journal finds it difficult to archive the code, the editor naturally focuses on the paper itself, the reviewer trusts the authors and the proof assistant, and the authors are tempted not to mention dirty little secrets about their code. If the proponents of formalized mathematics want to avert a disaster that could destroy their efforts in a single blow, they must adopt a set of rules that will ensure high standards. There is much more to trusting a piece of formalized mathematics than just running it through a proof checker.

<!--more-->

Before I say anything about reviewing formalized mathematics, let me just point out that being anonymous does not give the referee the right to be impolite or even abusive. A good guiding principle is to never write anything in a review that you would not say to the author&#8217;s face. You can be harsh and you can criticize, but do it politely and ground your opinions in arguments. After all, you expect no less of the author.

Let us imagine  a submission to a journal in which the author claims to have checked proofs using a computer proof assistant or some other such tool. Almost everything I write below follows from the simple observation that _**the code contains proofs  and that proofs are an essential part of the paper**_. If as a reviewer or an editor you are ever in doubt, just imagine how you would act if the formalized part were actually an appendix written informally as ordinary math.

Here is a set of guidelines that I think should be followed when formalized mathematics is reviewed.

### The rules for the author

  1. _Enclose the code with the paper submission._
  2. _Provide information on how to independently verify the correctness of the code._
  3. _License the code so that anyone who wants to check the correctness of the proofs is free to do so._
  4. _Provide explicit information on what parts of the code correspond to what parts of the paper._

Comments:

  1. It is not acceptable to just provide a link where the code is available for download, for several reasons: 
      * When the anonymous reviewer downloads the code, he will give away his location and therefore very likely his identity. The anonymity of the reviewer must be respected. While there are methods that allow the reviewer to download the code anonymously, it is not for him to worry about such things.
      * There is no guarantee that the code will be available from the given link in the future. Even if the code is on Github or some other such established service, in the long run the published paper is likely going to outlive the service.
      * It must be perfectly clear which version of the code goes with the paper. Code that is available for download is likely going to be updated and change, which will put it out of sync with the paper. The author is of course always free to mention that the code is _also_ available on some web site.
  2. Without instructions on how to verify correctness of the code, the reviewer and the readers may have a very hard time figuring things out. The information provided must: 
      * List the prerequisites: which proof assistant the code works with and which libraries it depends on, with exact version information for all of them.
      * Include step-by-step instructions on how to compile the code.
      * Provide an outline of how the code is organized.
  3. Formalized mathematics is a form of software. I am not a copyright expert, but I suspect that the rules for software are not the same as those for published papers. Therefore, the code should be licenced separately. I strongly urge everybody to release their code under an open source license, otherwise the evil journals will think of ways to hide the code from the readers, or to charge extra for access to the code.
  4. The reviewer must check that all theorems stated in the paper have actually been proved in the code. To make his job possible the author should make it clear how to pair up the paper theorems with the machine proofs. It is _not_ easy for the reviewer to wade through the code and try to figure out what is what. Imagine a paper in which all proofs were put in an appendix but they were not numbered, so that the reader would have to figure out which theorem goes with which proof.

### The rules for the reviewer

  1. _Review the paper part according to established standards._
  2. _Verify that the code compiles as described in the provided instructions._
  3. _Check that the code correctly formulates all the definitions._
  4. _Check that the code proves each theorem stated in the paper and that the machine version of the theorem is the same as the paper version._
  5. _Check that the code does not contain unfinished proofs or hypotheses that are not stated in the paper._
  6. _Review the code for quality._

Comments:

  1. Of course the reviewer should not forget the traditional part of his job.
  2. It is absolutely critical that the reviewer independently compile the code. This may require some effort, but skipping this step is like not reading proofs.
  3. Because the work is presented in two separate parts, the paper and the code, there is potential for mismatch. It is the job of the reviewer to make sure that the two parts fit together. The reviewer can reject the paper if he cannot easily figure out which part of the code corresponds to which part of the paper.
  4. The code is part of the paper and is therefore subject to reviewing. Just because a piece of code is accepted by a proof checker, that does not automatically make it worthy. Again, think how you would react to a convoluted paper proof which were nevertheless correct. You would most definitely comment on it and ask for an improvement.

### The rules for the journal

  1. _The journal must archive the code and make it permanently available with the paper, under exactly the same access permissions as the paper itself._

This is an extremely difficult thing to accomplish, so the journal should do whatever it can. Here are just two things to worry about:

  1. It is unacceptable to make the code less accessible than the paper because the code _is_ the paper.
  2. The printed version of the journal should have the code enclosed on a medium that lasts as long as paper.
  3. If the code is placed on a web site, it is easy for it do disappear in the future when the site is re-organized.

### The rules for the editor

  1. _The editor must find a reviewer who is not only competent to judge the math, but can also verify that the code is as advertised._
  2. _The editor must make sure that the author, the journal, and the reviewer follow the rules._

Comments:

  1. It may be quite hard to find a reviewer that both knows the math and can deal with the code. In such as a case the best strategy might be to find two reviewers whose joint abilities cover all tasks. But it is a very bad idea for the two reviewers to work independently, for who is going to check that the paper theorems really correspond to the computer proofs? It is not enough to just have a reviewer run the code and report back as &#8220;it compiles&#8221;.
  2. In particular, the editor must: 
      * insist that the code be enclosed with the paper
      * convince the journal that the code be archived appropriately
      * require that the reviewer explicitly describe to what extent he verified the code: did he run it, did he check it corresponds to the paper theorems, etc? (See the list under &#8220;The rules for the reviewer&#8221;.)

### Can we trust formalized mathematics?

I think the answer is _not without a diligent reviewing process._ While a computer verified proof can instill quite a bit of confidence in a mathematical result, there are things that the machine simply cannot check. So even though the reviewer need not check the proofs themselves, there is still a lot for him to do. Trust is in the domain of humans. Let us not replace it with blind belief in the power of machines.