---
id: 194
title: On programming language design
date: 2009-04-11T18:29:03+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=194
permalink: /2009/04/11/on-programming-language-design/
categories:
  - General
  - Programming
  - Tutorial
---
In a recent post I claimed that [Python&#8217;s lambda construct is broken](/2009/04/09/pythons-lambda-is-broken/). This attracted [some](/2009/04/09/pythons-lambda-is-broken/#comment-11485) [angry](/2009/04/09/pythons-lambda-is-broken/#comment-11486) [responses](/2009/04/09/pythons-lambda-is-broken/#comment-11499) by people who thought I was confused about how Python works. Luckily there were also many useful responses from which I learnt. This post is a response to [comment 27](/2009/04/09/pythons-lambda-is-broken/#comment-11501), which asks me to say more about my calling certain design decisions in Python crazy.

<!--more-->Language design is like architecture. The architect is bound by the rules of nature, he has to take into account the properties of the building materials, and he must never forget the purpose that the building will serve. Likewise, the designer of a programming language is bound by the theorems of computability theory, he must take into account the properties of the underlying hardware, and he must never forget that the language is used by programmers.

When I teach the theory of programming languages, I tell my students that there is a design principle from which almost everything else follows:

> _&#8220;Programmers are just humans: forgetful, lazy, and they make every mistake imaginable.&#8221;_

Therefore, it is the task of the designer to make a programming language which counters these deficiencies. A language must not be too complex, lest the programmer forget half of it. A language must support the programmer&#8217;s laziness by providing lots of useful libraries, and by making it possible to express ideas directly and succinctly. The language must allow good organization of source code, otherwise the programmer will use the copy-paste method. The language must try really hard to catch programming mistakes, especially the mundane ones that happen to everyone all the time. When it finds a mistake, it must point to the true reason for it, preferably with an error message that humans understand.

You will notice that so far I have not said a word about efficiency. If this were the year 1972 we would talk about efficiency first and forget about the programmers, because 37 years ago hardware and processing time were the scarcest resources. Today we live in different times when the most expensive resource is development time. In 1972 it was a _good_ design decision to implement arrays in C so that they did not carry with them information about their lengths (save a couple of bytes on each array), it was a _good_ decision not to check for out-of-bounds errors in array indexing (save a couple of CPU cycles), and it was a _good_ decision not to have garbage collection (it didn&#8217;t work well anyhow). From today&#8217;s point of view all these decisions were horrible mistakes. Buffer overflows, which are a consequence of missing out-of-bounds checks, cost the industry huge amounts of money every year, while lack of automated garbage collection results in memory leaks that cause programs to be unstable.

Of course, even today C might be just the right tool for your specific task. I am not saying that memory efficiency and speed are not important. They are not _as important_ as they used to be. The first objective in a programming language design today should be friendliness to programmers. A lot is known about how to write an optimizing compiler and how to generate efficient code, so usually the design of the language does not prevent generation of efficient compiled or interpreted code.

People do not make bad design decisions because they are evil or stupid. They make them because they judge that the advantages of the decision outweigh the disadvantages. What they often do not see is that they could have achieved the same advantages in a different way, without introducing the disadvantages. Therefore, it is very important to get the order right: _first_ make sure the design avoids the disadvantages, _then_ think about how to get the advantages back.

Let us now apply these principles to several examples.

### Undefined values (NULL, null, undef, None)

Suppose we want a language with references (pointers in C). The principle tells us that it is a bad idea to allow invalid references because programmers _will_ create them. Indeed, most recently designed languages, say Java and Python, do not allow you to write obviously risky things, such as

> <pre>int *p = (int *)0xabcdef;</pre>

Unfortunately, many designers have still not learnt that the special `NULL` pointer or `null` object is an equally bad idea. Python&#8217;s `None`, perl&#8217;s `undef`, and SQL&#8217;s `NULL` all fall in the same category. I can hear you list lots of advantages of having these. But stick to the principle: `NULL` is wrong because it causes horrible and tricky mistakes which appear even after the program was tested thoroughly. You cannot introduce `NULL` into the language and tell the programmer to be careful about it. The programmer is not capable of being careful! There is plenty of evidence to support this sad fact.

Therefore _NULL, null, None and undef must go._ I shall collectively denote these with Python&#8217;s `None`. Of course, if we take away None, we must put something else back in. To see what is needed, consider the fact that `None` is intended as a special constant that signifies &#8220;missing value&#8221;. Problems occur when a given value could be either &#8220;proper&#8221; or &#8220;missing&#8221; and the programmer forgets to consider the case of missing value. The solution is to design the language in such a way that the programmer is always forced to consider both possibilities.

For example, Haskell does this with the datatype [`Maybe`](http://en.wikibooks.org/wiki/Haskell/Hierarchical_libraries/Maybe), which has two kinds of values:

  * `Nothing`, meaning &#8220;missing value&#8221;
  * `Just x`, meaning &#8220;the value is `x`&#8220;

The _only_ way to use such a value in Haskell is to consider _both_ cases, otherwise the compiler complains. The language is forcing the programmer to do the right thing. Is this annoying? You will probably feel annoyed if you are used to ugly hacks with `None`, but a bit of experience will quickly convince you that the advantages easily outweigh your tendency for laziness. By the way, Haskell actually supports your laziness. Once you tell it that the type of a value is `Maybe`, it will find for you all the places where you need to be careful about `Nothing`. C, Java, Python, and perl stay silent and let you suffer through your own mistaken uses of `NULL`&#8216;s, `null`&#8216;s, `None`&#8216;s, and `undef`&#8216;s.

Other languages that let you have the data type like Haskell&#8217;s `Maybe` are ML and Ocaml because they have [sum types](http://en.wikipedia.org/wiki/Sum_type). Pascal, Modula-2 and C have broken sum types because they require the programmer to handle the tag by hand.

### Everything is an object (or list, or array)

Many languages are advertised as &#8220;simple&#8221; because in them everything is expressed with just a couple of basic concepts. Lisp and scheme programmers proudly represent all sorts of data with conses and lists. Fortran programmers implement linked lists and trees with arrays. In Java and Python &#8220;everything is an object&#8221;, more or less.

It is good to have a simple language, but it is not good to sacrifice its expressiveness to the point where most of the time the programmer has to encode the concepts that he really needs indirectly with those available in the language. Programmers cannot do such things reliably, and the compiler cannot help them with the task because it does not know what is in programmer&#8217;s head.

Let us look at a typical example in scheme. Suppose we would like to represent binary trees in which the nodes are labeled with integers. In scheme we might do this by representing the empty tree as `()`, and use a three-element list `(k l r)` to represent a tree whose root is labeled by `k`, the left subtree is `l`, and the right subtree is `r`. A [quick search on Google](http://www.google.si/search?q=scheme+binary+tree) shows that this is a popular way of implementing trees in scheme. It&#8217;s simple, it&#8217;s cool, it&#8217;s easy to explain to the students, but scheme will have no idea whatsoever what you&#8217;re doing. There are a number of trivial mistakes which can be made with such a representation, and scheme won&#8217;t detect them (at best you will get a runtime error): you might write `(l k r)` instead of `(k l r)`, you might mistakenly pass a four-element list to a function expecting a tree, you might mistakenly think that the integer `42` is a valid representation of the tree `(42 () ())`, you might mistakenly try to compute the left subtree of the empty tree, etc. And remember, the programmer _will_ make all these mistakes.

With objects the situation is somewhat better. In Java we would define a class Tree with three attributes `root`, `left`, and `right`. It will be impossible to build a tree with a missing attribute, or too many attributes. But we will hit another problem: how to represent the empty tree? There are several choices none of which is ideal:

  1. the empty tree is `null`: this is the worst solution, as any Java programmer knows
  2. we define a class `Tree` and subclasses `EmptyTree` and `NodeTree` represent the two different kinds of tree
  3. we add a fourth attribute `empty` of type boolean which tells us whether the tree is empty

There are probably other options. The first solution is horrible, as every Java programmer knows, because it leads to many `NullPointerExceptions`. The second solution is probably the most &#8220;object-orientedly correct&#8221; but people find it impractical, as it spreads code around in two classes. When I taught java I lectured the third solution, but that one has the big disadvantage that the programmer is responsible for checking every time whether a tree is empty or not.

A decent programming language should help with the following common problems regarding binary trees:

  1. Prevent the construction of an invalid tree, such as one with missing parts, or dangling pointers.
  2. Prevent _at compile time_ access to a component which is not there. For example, the compiler should detect the fact that the programmer is trying to access the left subtree of the empty tree.
  3. Make sure the programmer never forgets to consider both possibilities&#8211;the empty tree and the non-empty tree.

The above scheme representation does not help with the first problem. A C implementation with pointers would allow dangling pointers. An object-oriented solution typically won&#8217;t help with the second and the third problems.

You might wonder what it is that I want. The answer is that the programming language should have built-in _inductive data types_, because that&#8217;s what binary trees are. In Haskell, which has inductive data types, trees are defined directly in terms of their structure:

> <pre>data Tree = Empty | Node Int Tree Tree</pre>

This expresses the definition of trees _directly_: a tree is either empty or a node composed of an integer and two trees. Haskell will be able to catch all the common problems listed above. Other languages supporting this sort of definition are ML, Ocaml, F#, and interestingly Visual Prolog (I am told by Wikipedia).

We might ask for more. Suppose we wanted to implement [binary search trees](http://en.wikipedia.org/wiki/Binary_search_tree). Then we would require that the left subtree only contains nodes that are smaller than the root, and the right subtree only nodes that are larger than the root. Can a programming language be designed so that this property is guaranteed? Yes, for example the compiler could insert suitable checks into the code so that anomalies are detected during execution as soon as they occur. This might be nice for debugging purposes, but what is production code supposed to do if it discovers an anomalous data structure during its execution? Ignore it? Raise an exception? It is much more useful to know _before_ the program is run that the data structure will never be corrupted. Here we hit against a law of nature: there is no algorithm that would analyze an arbitrary piece of code and determine whether it will only produce valid search trees. It is a fact of life. If you really want to check that your programs are correct you will have to help the compiler. There are excellent tools for doing that, such as [Coq](http://coq.inria.fr/) and [Agda](http://wiki.portal.chalmers.se/agda/)&#8211;have a look to see how programmers might develop their code in the future.

### Confusing definitions and variables

A _definition_ binds an identifier to a particular _fixed_ value. A _variable_ or a _mutable value_ is a memory location which holds a value that can be read and changed. These two notions should not be confused. Unfortunately, traditional programming languages only provide variables, so many programmers don&#8217;t even understand what definitions are. Java tries to fix this with the [final](http://en.wikipedia.org/wiki/Final_(Java)) declaration, and C++ with the const declaration, but these are not used by programmers as much as they could be (which is a typical sign of dubious design decisions).

Using variables instead of definitions is wrong for a number of reasons. First, if the compiler knows which identifiers are bound to immutable values it can optimize the code better. It can, for example, decide to store the value in a register, or to keep around several copies without worrying about synchronization between them (think threaded applications). Second, if we allow the programmer to change a value which is supposed to be constant, then he will do so.

If you observe how variables are typically used, you will see several distinct uses:

  * often a variable is only assigned to once and is used as an (immutable) definition
  * a variable in a loop or list comprehension ranges over the elements of a list, or a collection of objects
  * a variable stores the current state and is genuinely mutable

Should loop counters be mutable? I think not. Code that changes the loop counter in the body of the loop is confusing and error prone. If you want to fiddle with counters, use the while loop instead. So in two out of three cases we want our variables to be immutable, but the popular programming languages only give us variables. That&#8217;s silly. We should design the language so that the _default_ case is an immutable value. If the programmer wants a mutable value, he should say so explicitly. This is just the opposite of what Java and C++ do. An example of a language that is designed this way is [ML](http://en.wikipedia.org/wiki/Standard_ML) and [ocaml](http://www.ocaml.org/). In Haskell you have to jump through hoops to get mutable values (now I am going to hear it from a monad aficionado, please spare me an unnecessary burst of anger).

### Out of scope variables

I thought I would not have to explain why undefined identifiers are a bad a idea, but the reader in [comment 27](/2009/04/09/pythons-lambda-is-broken/#comment-11501) explicitly asked about this.

If a programmer refers to an undefined name then an error should be reported. Concretely, I claimed that Python should complain about the following definition:

> <pre>def f(n): return i + n</pre>

What is `i`? Pythonists will quickly point out that `i` will be defined later, and how deferred definitions are useful because they allows us to define mutually recursive functions. Indeed, Java and Haskell also accept mutually recursive definitions. But unlike Python they make sure that nothing is missing at the time of definition, whereas Python will only complain when the above function `f` is used. To be honest, Python kindly displays the correct error message showing that the trouble is with the definition of `f`. But why should this be a runtime error when the mistake can easily be detected at compile time? Actually, this question leads to a more general question, which I consider next.

### When should mistakes be discovered?

Should programming bugs be discovered by the programmer or by the user? The answer seems pretty clear. Therefore, a language should be designed so that as many programming errors as possible are discovered early on, that is _before_ the program is sent to the user. In fact, in order to speed up development (remember that the development time is expensive) the programmer should be told about errors without having to run the program and directing its execution to the place where the latest code change actually gets executed.

This philosophy leads to the design of _statically_ checked languages. A typical feature of such a language is that all the types are known at compile time. In contrast, a dynamically typed languages checks the types during runtime. Java, Haskell and ocaml are of the former kind, scheme, javascript and Python of the latter.

There are situations in which a statically checked language is better, for example if you&#8217;re writing a program that will control a laser during eye surgery. But there are also situations in which maximum flexibility is required of a program, for example programs that are embedded in web pages. The web as we know it would not exist if every javascript error caused the browser to reject the entire web page (try finding a page on a major web site that does not have any javascript errors).

Let me also point out that _testing_ cannot replace good language design. Testing is very important, but it should be used to discover problems that cannot be discovered earlier in the development cycle.

I used to think that statically checked languages are better for teaching because they prevent the students from doing obviously stupid things. About two years ago I changed my mind. The students learn much better by doing stupid things than by being told by an oppressive compiler that their programs are stupid. So this year I switched to Python. The students are happier, and so am I (because I don&#8217;t have to explain that code must be properly indented). Python does not whine all the time. Instead it lets them explore the possibilities, and by discovering which ones crash their programs they seem to understand better how the machine works.