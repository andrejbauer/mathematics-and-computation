---
id: 623
title: 'Programming with effects II: Introducing eff'
date: 2010-09-27T23:30:58+02:00
author: Matija Pretnar
layout: post
guid: http://math.andrej.com/?p=623
permalink: /2010/09/27/programming-with-effects-ii-introducing-eff/
categories:
  - Computation
  - Eff
  - Guest post
  - Programming
  - Software
  - Tutorial
---
**[UPDATE 2012-03-08: since this post was written eff has changed considerably. For updated information, please visit the [eff page](/eff/).]**

****This is a second post about the programming language eff. We covered the theory behind it in a [previous post](http://math.andrej.com/2010/09/27/programming-with-effects-i-theory/). Now we turn to the programming language itself.

Please bear in mind that eff is an academic experiment. It is not meant to take over the world. Yet. We just wanted to show that the theoretical ideas about the algebraic nature of computational effects can be put into practice. Eff has many superficial similarities with Haskell. This is no surprise because there is a precise connection between algebras and monads. The main advantage of eff over Haskell is supposed to be the ease with which computational effects can be combined.

<!--more-->

### Installation

If you have [Mercurial](http://mercurial.selenic.com/) installed (type `hg` at command prompt to find out) you can get eff like this:

<pre class="brush: bash; gutter: false; title: ; notranslate" title="">$ hg clone http://hg.andrej.com/eff/ eff
</pre>

Otherwise, you may also download the latest source as a [`.zip`](http://hg.andrej.com/eff/archive/tip.zip) or [`.tar.gz`](http://hg.andrej.com/eff/archive/tip.tar.gz), or [visit the repository with your browser](http://hg.andrej.com/eff/) for other versions. Eff is released under the [simplified BSD License](http://www.opensource.org/licenses/bsd-license.php).

To compile eff you need [Ocaml](http://www.ocaml.org/) 3.11 or newer (there is an incompatibility with 3.10 in the Lexer module), [ocamlbuild](http://brion.inria.fr/gallium/index.php/Ocamlbuild), and [Menhir](http://gallium.inria.fr/~fpottier/menhir/) (which are both likely to be bundled with Ocaml). Put the source in a suitable directory and compile it with `make` to create the Ocaml bytecode executable `eff.byte`. When you run it you get an interactive shell without line editing capabilities. If you never make any typos that should be fine, otherwise use one of the line editing wrappers, such as [rlwrap](http://utopia.knoware.nl/~hlub/rlwrap/) or [ledit](http://pauillac.inria.fr/~ddr/ledit/). A handy shortcut `eff` runs `eff.byte` wrapped in rlwrap.

### Syntax

Eff has Python-like syntax, with mandatory indentation. Tabs are not allowed in indentation, only spaces. The syntax is likely to change in the future.

### The basics

Before digging into the effects, let us look at some examples of purely functional code. Throughout the post, we present the examples as if they were written in the interactive toplevel. For example:

<pre class="brush: plain; gutter: false; highlight: [2]; title: ; notranslate" title="">>>> 1 + 2
3
</pre>

You can also write code in a file and run it with eff, but in this case you should use the `check` command described below to see some output.

First, we have basic integer arithmetic with integers of unbounded size, booleans, strings, together with the basic operations:

<pre class="brush: plain; gutter: false; highlight: [2,4,9]; title: ; notranslate" title="">>>> (1379610 + 9) * 80618151420468743021
111222333444555666777888999
>>> 1 == 2
False
>>> if 1 < 2:
...   "one is less" ^ " than two"
... else:
...   "you must be kidding"
"one is less than two"
</pre>

We have tuples, lists, variants and records, all of which can be decomposed with pattern matching:

<pre class="brush: plain; gutter: false; highlight: [3,5,8,12,15]; title: ; notranslate" title="">>>> (_, a, b) = (3, 4, 5)
>>> (a, b, a + b)
(4, 5, 9)
>>> 1 :: [2, 3, 4, 5] @ [6, 7, 8]
[1, 2, 3, 4, 5, 6, 7, 8]
>>> Tree l r = Tree (Leaf 4) (Tree (Leaf 5) (Leaf 6))
>>> r
Tree (Leaf 5) (Leaf 6)
>>> z = (re = 1, im = 5)
>>> (re = x, im = _) = z
>>> x
1
>>> (a, Foo (re = x), _) = ("banana", Foo (re=4, im=10), ["some", "stuff"])
>>> (a, x)
("banana",  4)
</pre>

$\lambda$-abstraction is written like in Python, except you can start a block after the colon:

<pre class="brush: plain; gutter: false; highlight: [2,8,10]; title: ; notranslate" title="">>>> (lambda x: (x, x + 1)) 5
(5, 6)
>>> f = lambda x (y, z):
...         a = x + y
...         b = z + a
...         a * b
>>> f 1
<fun>
>>> f 1 (2, 3)
18
</pre>

You can use patterns in $\lambda$-abstractions and write `lambda p q r: e` instead of `lambda p: lambda q: lambda r: e`. Note that eff is an expression-based language. There is no `return` command to return the result, even though for clarity we wrote explicit $\mathtt{return}$'s the previous post.

Recursive definitions are formed with `def`. Mutually recursive definitions are formed with `def`...`and`...`and`... In the following example we also see how to write match statements:

<pre class="brush: plain; gutter: false; highlight: [9]; title: ; notranslate" title="">>>> def is_odd n:
...     match n:
...         case 0: False
...         case n: is_even (n - 1)
... and is_even n:
...     if n == 0: True
...     else: is_odd (n - 1)
>>> is_odd 1234
False
</pre>

Recursive definitions need not define functions:

<pre class="brush: plain; gutter: false; highlight: [3]; title: ; notranslate" title="">>>> def one_two_three : [1, 2, 3] @ one_two_three
>>> one_two_three
[1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, ...]
</pre>

For more examples, look at the file `prelude.eff`, which is loaded into eff before anything else happens.

### How to use effects

One of eff's built-in effects are references (mutable store). To create a new reference instance `x` with initial value 5 we use the `with` statement:

<pre class="brush: plain; gutter: false; highlight: [6,7]; title: ; notranslate" title="">>>> with ref 5 as x:
...     a = x.lookup ()
...     x.update (a + 3)
...     x.update (x.lookup() + x.lookup())
...     x.lookup()
Warning: Implicit sequencing between L4, 15-27 and L4, 28-37
16
</pre>

In the above code `ref` is a function which accepts a value and returns an effect. The `with` creates a new instance of an effect and calls it `x`. The scope of the effect is the body of the `with` statement, i.e., `x` is a _local_ effect.

You will notice that eff prints a warning when it detects an ambiguous order of execution of operations. Sometimes it thinks that a piece of code contains effects when it actually does not and prints spurious warnings. You can use `pure e` to indicate that `e` does not contain any effects. We hope to get rid of `pure` once we have a type system for eff. Yes, eff currently does not check types. It does not seem easy to come up with a good type system for eff. We have found that the lack of types invites one to try all sorts of crazy things.

From now on, we are not going to show these warnings. If you do not like them, you can turn them off by passing the option `--careless` when starting eff.

We can create and mix several instances of `ref` (can you tell how many sequencing warnings would we get?):

<pre class="brush: plain; gutter: false; highlight: [6]; title: ; notranslate" title="">>>> with ref 5 as x:
...     with ref 10 as y:
...         a = x.lookup () + y.lookup ()
...         x.update (a + y.lookup ())
...         x.lookup ()
25
</pre>

If only one instance of an effect is needed, we need not give it a name. So we can have one nameless global `ref` instance:

<pre class="brush: plain; gutter: false; highlight: [4]; title: ; notranslate" title="">>>> with ref 5:
...    update (lookup () + 7)
...    lookup ()
12
</pre>

### How to define effects

In eff we can define our own effects with the `effect` statement:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">effect e:
   operation op_1 x: h_1(x)
   operation op_2 x: h_2(x)
   ...
   return x: r(x)
   finally x: f(x)
</pre>

The above code defines an effect `e` with operations $\mathtt{op}\_1, \mathtt{op}\_2, \ldots$ which are handled by the code $h\_1, h\_2, \ldots$, respectively. The `return` clause tells us how to handle (pure) values. The `finally` clause tells us what should be done with the value, returned from the `with` statement that uses the effect `e`. In other words, it defines a wrapper which tells us how to “run” the effect as well as how to “get out” of it (compare to Haskell's [runState](http://www.haskell.org/haskellwiki/State_Monad) for the state monad).

If you leave out the `return` or `finally` clauses it is assumed that they are identity functions.

#### User-defined references

Let us convert the reference example from the [first post](http://math.andrej.com/2010/09/27/programming-with-effects-i-theory/) to eff code. Since eff already has a builtin effect called `ref` we call our references `myref`:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">>>> effect myref s_initial:
...         operation lookup (): (lambda s: yield s s)
...         operation update s_new: (lambda s: yield () s_new)
...         return x: (lambda s: x)
...         finally f: f s_initial
</pre>

or, more concisely but equivalently:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">>>> effect myref s_initial:
...     operation lookup () s: yield s s
...     operation update s_new s: yield () s_new
...     return x s: x
...     finally f: f s_initial
</pre>

This is the definition of a function `myref` which maps `s_initial` to an effect. The effect has two operations, `lookup` and `update`, which are handled just like the algebraic operations $\mathtt{lookup}$ and $\mathtt{update}$ from the previous post. Because we use the generic effect notation we cannot refer to the continuation directly, but rather indirectly with the keyword `yield`.

Recall that a program which uses a reference of type $S$ and returns a value of type $T$ is in fact a map $S \to T$. The `finally` clause tells us what should be done with such a function, namely it should be applied to the initial state. In other words, `finally` is just syntactic sugar for a wrapper around the `with` statement, so

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">>>> with myref 5:
...     some code
</pre>

is equivalent to

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">>>> (with myref_without_finally:
...     some code) 5
</pre>

Let us check how our references mix with the builtin ones:

<pre class="brush: plain; gutter: false; highlight: [6]; title: ; notranslate" title="">>>> with myref 100 as u:
...     with ref 10 as z:
...         u.update (u.lookup () + z.lookup ())
...         z.update (u.lookup () + z.lookup ())
...         (u.lookup (), z.lookup ())
(110, 120)
</pre>

Exactly as we would have expected. We can create any number of local references. We can even store them in a list, and they will work correctly as long as they do not escape the scope of their declaration.

#### Choice

As the next example we define a choice operation. In general such an operation is given some values (in our case two, but it could be a list) and it is supposed to choose one of them. There are many different criteria according to which we might make a choice: randomly, non-deterministically, so that the end result is minimized, etc.

Let us first define a boring choice, which always chooses the first value:

<pre class="brush: plain; gutter: false; highlight: [7]; title: ; notranslate" title="">>>> effect left_choice:
...     operation choose (a, _): yield a
>>> with left_choice:
...     x = choose (3, 2)
...     y = choose (5, 10)
...     x + y
8
</pre>

Observe how we used `yield` to pass the result of the operation back to the continuation. It may take a bit of getting used to `yield` if you are not familiar with continuations.

A more interesting kind of choice is “magical” choice with always selects that value which leads to the least possible end result:

<pre class="brush: plain; gutter: false; highlight: [10]; title: ; notranslate" title="">>>> effect min_choice:
...     operation choose (a, b):
...         l = yield a
...         r = yield b
...         min l r
>>> with min_choice:
...     x = choose (3, 2)
...     y = choose (5, 10)
...     x + y
7
</pre>

Notice how we used `yield` twice in order to test both possibilities: what happens if we choose `a` and what happens if we choose `b`. The end result is a kind of depth-first search. Another test case:

<pre class="brush: plain; gutter: false; highlight: [6]; title: ; notranslate" title="">>>> with min_choice:
...     x = choose (3, 4)
...     y = choose (5, 6)
...     z = choose (10, 1)
...     x * x - y * z * x + z * z * z - y * y * x
-151
</pre>

It should be possible to write all sorts of “choose” and “search” operators in eff that allow the programmer to write backtracking code with seemingly magical choice operators.

What if we wanted to collect _all_ possible results rather than just a particular one? No problem:

<pre class="brush: plain; gutter: false; highlight: [11]; title: ; notranslate" title="">>>> effect all_choices:
...     operation choose (a, b):
...         l = yield a
...         r = yield b
...         l @ r
...     return v: [v]
>>> with all_choices:
...     x = choose (3, 2)
...     y = choose (5, 10)
...     x + y
[8, 13, 7, 12]
</pre>

In this case, the operation first yields its left argument to the continuation and gets back a list `l` of possible results. It repeats the same with its right argument to get back a list `r`, and returns the concatenated list `l @ r`. The `return` clause tells us that a pure value gives just one choice.

### Handlers

When we define an effect we tell how its operations are handled by default. We may also wrap a piece of code in a handler that temporarily redefines the behavior of operations. Here is a handler which intercepts lookups to reference `z` and always adds `1` to the actual value:

<pre class="brush: plain; gutter: false; highlight: [11]; title: ; notranslate" title="">>>> with ref 10 as z:
...     y = z.lookup ()
...     handle:
...         z.update 100
...         x = z.lookup ()
...         (x, y)
...     with:
...         operation z.lookup ():
...             a = z.lookup () # this calls the outer lookup
...             yield (a + 1)
(101, 10)
</pre>

### Exceptions

Eff does not have builtin exceptions. The $\mathtt{fail}$ exception could be defined like this:

<pre class="brush: plain; gutter: false; highlight: [11,17]; title: ; notranslate" title="">>>> effect maybe:
...     operation fail(): Nothing
...     return x: Just x
...
>>> with maybe:
...     a = 5
...     b = 6
...     fail ()
...     a + b
...
Nothing
>>> with maybe:
...     a = 5
...     b = 6
...     a + b
...
Just 11
</pre>

We are reminded of Haskell's Maybe monad, and not without reason. The cool thing is that exceptions act like exceptions within their scope and like optional values outside the scope. Thus we can handle exceptions inside their scope just as expected:

<pre class="brush: plain; gutter: false; highlight: [10]; title: ; notranslate" title="">>>> with maybe:
...     a = 5
...     handle:
...         b = 6
...         fail ()
...         a + b
...     with:
...         operation fail(): 42
...
Just 42
</pre>

We can also have a version of `maybe` with default values:

<pre class="brush: plain; gutter: false; highlight: [10,16]; title: ; notranslate" title="">>>> effect default x:
...     operation fail(): x
...
>>> with default 42:
...     a = 5
...     b = 6
...     fail ()
...     a + b
...
42
>>> with default 42:
...     a = 5
...     b = 6
...     a + b
...
11
</pre>

### I/O

Eff has a builting effect `io` with operations `print_value`, `print_string` and `read_string` which print to standard output and read from standard input. If you want to print something out you should not forget to first tell eff that you want to use the `io` effect:

<pre class="brush: plain; gutter: false; highlight: [2,5,6]; title: ; notranslate" title="">>>> print_string "Hello, world!"
Runtime error: Name print_string is not defined. (L1, 1-12)
>>> with io: print_string "Hello, world!"
...
Hello, world!
()
</pre>

Having to write “`with io`” all the time is annoying, so eff allows you to declare globally in a file (but not in the interactive shell) that you will use `io`:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">with io ...
</pre>

This is the same as writing `with io:` and indenting the rest of the file. Of course, there is nothing special about `io`. You can declare any effect instance for the rest of the file in the same way.

If you are using `io` for printing debugging information, don't! Eff has a special command `check` just for that purpose:

<pre class="brush: plain; gutter: false; highlight: [3,6,10,11]; title: ; notranslate" title="">>>> check: "Hello, world!"
...
"Hello, world!"
>>> check: 1 + 2 + 3
...
6
>>> with io:
...     check: print_string "Hello, world"
...
Operation print_string "Hello, world" (global)
()
</pre>

The last example requires explanation: since `check` is intended for debugging it never handles operations. Instead it tells you that an operation occurred.

Let us write an effect which redirects output to a string:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">>>> effect print_to_string:
...   operation print_string x c: yield () (c ^ x)
...   return () c: c
...   finally f: f ""
</pre>

We can use it to collect output to a string:

<pre class="brush: plain; gutter: false; highlight: [6]; title: ; notranslate" title="">>>> a = (with print_to_string:
...          print_string "Hello, world!"
...          print_string "And good bye.")
...
>>> a
"Hello, world!And good bye."
</pre>

For some reason people find the following example surprising:

<pre class="brush: plain; gutter: false; highlight: [9,10,11,12]; title: ; notranslate" title="">>>> with io:
...   print_string "Please enter your name:"
...   response = handle with print_to_string:
...                      print_string "Hello "
...                      print_string (read_string ())
...                      print_string "!"
...   print_string response
...
Please enter your name:
Matija
Hello Matija!
()
</pre>

The mystery disappears when we realize that `print_string` on lines 4 and 6 get handled by `print_to_string`.

This is probably sufficient for a first introduction. We are still exploring the possibilities and we will post them when we think of something cool. For example, we know that delimited continuations are definable in eff (rather easily, since continuations are lurking around anyhow), as well as transactional memory and many other cool effects.
