---
id: 122
title: A Haskell monad for infinite search in finite time
date: 2008-11-21T23:57:08+02:00
author: Martin Escardo
layout: post
guid: http://math.andrej.com/?p=122
permalink: /2008/11/21/a-haskell-monad-for-infinite-search-in-finite-time/
categories:
  - Computation
  - Constructive math
  - Guest post
---
I show how monads in Haskell can be used to structure infinite search algorithms, and indeed get them for free. This is a follow-up to my blog post [Seemingly impossible functional programs](http://math.andrej.com/2007/09/28/seemingly-impossible-functional-programs/). In the two papers [Infinite sets that admit fast exhaustive search](http://www.cs.bham.ac.uk/~mhe/papers/exhaustive.pdf) (LICS07) and [Exhaustible sets in higher-type computation](http://www.lmcs-online.org/ojs/viewarticle.php?id=395&layout=abstract) (LMCS08), I discussed what kinds of infinite sets admit exhaustive search in finite time, and how to systematically build such sets. Here I build them using monads, which makes the algorithms more transparent (and economic).<!--more-->

### An abstract data type for searchable sets

I want to define a Haskell type constructor `S` such that, for any type `a`, the elements of type `S a` are the searchable subsets of `a`. Thus, `S` is like the powerset constructor in set theory, except that not all subsets are allowed here. Like the powerset construction, `S` will be a monad. Before implementing `S` concretely, I list the operations I would like to be able to perform with searchable sets:

<pre>search :: S a -> (a -> Bool) -> Maybe a
image :: (a -> b) -> S a -> S b
singleton :: a -> S a
union :: S a -> S a -> S a
bigUnion :: S(S a) -> S a</pre>

I adopt the notational convention, borrowed from the list data type, that if `x` is used to denote an element of type `a` then the plural `xs` is used to denote a searchable set of elements of `a`. So, notationally speaking, if `x :: a` then `xs :: S a`.

Given a set `xs :: S a` and a predicate `p :: a -> Bool`, we require that the expression `search xs p` either produces `Just` an example of some `x :: a` in the set `xs :: S a` with `p x = True`, if such an element exists, or else `Nothing`. For a function `f :: a -> b` and a set `xs :: S a`, the expression `image f xs` denotes the `f`-image of the set `xs` in the sense of set theory, that is, the set `ys :: S b` such that `y` $\in$ `ys` iff `f(x)=y` for some `x` $\in$ `xs`. The other operations construct singletons, binary unions, and unions of sets of sets, also in the usual sense of set theory.

### The monad

It is defined from the abstract data type as

<pre>instance Monad S where
  return = singleton
  xs >>= f = bigUnion(image f xs)</pre>

Notice that `xs :: S a` and `f :: a -> S b`, and hence `image f xs :: S S b`.

### Consequences of having a monad

Finite products of searchable sets are searchable:

<pre>times :: S a -> S b -> S(a,b)
xs `times` ys = do x <- xs
                   y <- ys
                   return(x,y)</pre>

That is, the elements of the set ``xs `times` ys`` are the pairs `(x,y)` with `x` $\in$ `xs` and `y` $\in$  `ys`. This turns out to be the same algorithm given in the above two papers, although the definition given there looks very different as it doesn't use monads.

Using lazy lists, the binary product can be iterated to finite and infinite products as follows:

<pre>product :: [S a] -> S[a]
product [] = return []
product (xs:yss) = do x <- xs
                      ys <- product yss
                      return(x:ys)</pre>

Notice that

  1. `xs :: S a` is a set,
  2. `x :: a` is an element of `xs`,
  3. `yss :: [S a]` is a list of sets,
  4. `product yss :: S[a]` is a set of lists,
  5. `ys :: [a]` is a list.

Again, this turns out to be the same infinite product algorithm given in the above papers, more precisely the one given in [[LICS07]](http://www.cs.bham.ac.uk/~mhe/papers/exhaustive.pdf), page 9, or [[LMCS08]](http://www.lmcs-online.org/ojs/viewarticle.php?id=395&layout=abstract), Section 8.1. I am working on a paper addressed to the Haskell and functional programming communities that will spell out this and other claims and details.

#### Haskell's sequence<tt></tt>

However, there is no need to define `product`, because it is already defined in the [Haskell'98 Standard Prelude](http://www.haskell.org/onlinereport/standard-prelude.html) under the name `sequence` (using `foldr` and the monad operations rather than recursion and do-notation, but this makes no difference), and moreover for any monad, not just `S`.

#### Example

The Cantor space of infinite sequences of binary digits, discussed in the previous blog post, can be constructed as follows:

<pre>bit :: S Int
bit = singleton 0 `union` singleton 1

cantor :: S [Int]
cantor = sequence (repeat bit)</pre>

This amounts to

> `cantor` = `bit` $\times$ `bit` $\times$ `bit` $\times \dots$ 

### Quantifiers

Notice that we can existentially and universally quantify over searchable sets in an algorithmic fashion, even when they are infinite, as is the case for the Cantor space:

<pre>forsome, forevery :: S a -> (a -> Bool) -> Bool
forsome xs p = case search xs p of
                 Nothing -> False
                 Just _ -> True
forevery xs p = not(forsome xs (\x -> not(p x))</pre>

Here `forsome xs` and `forevery xs` quantify over the set `xs`:

  1. `forsome xs p = True` iff `p x = True` for some `x` $\in$ `xs`,
  2. `forevery xs p = True` iff `p x = True` for every `x` $\in$ `xs`.

(The function `forsome` is in fact a monad morphism from `S` into the continuation monad.)

#### Contrived examples that nevertheless make a point

Consider the program

<pre>f :: Int -> Int -> Int -> Int
f n2 n1 n0 = 4 * n2 + 2 * n1 + n0

p :: Int -> Bool
p k = forevery cantor (\xs ->
       forsome cantor (\ys ->
         f (xs !! 10) (xs !! 100) (xs !! 1000) ==
         k - f (ys !! 2000) (ys !! 200) (ys !! 20)))</pre>

Then the expressions `p 6`, `p 7` and `p 8` evaluate to `False`, `True` and `False` respectively, together in a fraction of a second using the Glasgow Haskell Interpreter `ghci`, using our implementation of the abstract data type `S` given below.

As another example, consider

<pre>q = forevery cantor (\us ->
     forsome cantor (\vs ->
      forevery cantor (\xs ->
       forsome cantor (\ys ->
        us !! 333 + xs !! 17000 ==
        vs !! 3000 * ys !! 1000))))</pre>

Then `q` evaluates to `True` in less than a second.

These examples are certainly contrived, but they do illustrate that something non-trivial is going on from an algorithmic point of view, as the quantification algorithms have no access to the source code of the predicates they apply to. I'll discuss more meaningful examples another time. (I can use the quantifiers to find bugs in programs for exact real number computation using infinite lazy lists of digits. An application by [Alex Simpson](http://homepages.inf.ed.ac.uk/als/) to integration was mentioned in the previous post.)

### Representation of searchable sets

How should we represent infinite searchable sets to get an implementation of our abstract data type?

#### Obstacles

An infinite searchable set can be uncountable, like the Cantor space, and hence we cannot implement it using a lazy list of its elements. Moreover, this wouldn't help regarding exhaustive search in finite time. It can be argued that the _computable_ elements of the Cantor space form a countable set. However, they are not _computably countable_ (or r.e.), with the very same proof given by Cantor in the non-computable case, by diagonalization. (Exercise: write a Haskell program that given any infinite lazy list of elements of the Cantor space, produces an element that is not in the list. This amounts to an implementation of Cantor's proof of the non-denumerability of the Cantor space.)

#### Almost a solution

The crucial operation we can perform with a searchable set is to search it. Hence it is natural to represent a searchable set by a search function. The following is what this line of reasoning tempted me to do at the beginning of this work:

<pre>newtype S a = S {search :: (a -> Bool) -> Maybe a}</pre>

or, equivalently,

<pre>newtype S a = S ((a -> Bool) -> Maybe a)
search :: S a -> (a -> Bool) -> Maybe a
search(S searcher) = searcher</pre>

This has the advantage that it accounts for the empty set. However, this breaks the theorem that countable products of searchable sets are searchable, precisely because the empty set is present. In fact, if one of the factors is empty, then the product is empty. But an empty set may be present arbitrarily far away in the lazy list of sets, and the search algorithm can only output the first element of the lazy list when it knows that the product is non-empty. Hence it can never output it, because it can never determine non-emptiness of the product. In practice, we get an infinite loop when we run the product algorithm `sequence` if we work with the above implementation of `S`. However, with the exception of countable products, everything we do here works with the above implementation. But infinite products is what is needed to get infinite searchable sets.

#### The solution

Hence we do as we did in the above two papers instead:

<pre>newtype S a = S {find :: (a -> Bool) -> a}</pre>

or, equivalently,

<pre>newtype S a = S ((a -> Bool) -> a)
find :: S a -> (a -> Bool) -> a
find(S finder) = finder</pre>

This forces the sets to be non-empty, but has a defect: it also forces the `find` operator to tell lies when there is no correct element it can choose. We impose a requirement to overcome this: although lies are allowed, one always must have that `find xs p` chooses an element in the set `xs`, and if there is an element `x` $\in$ `xs` with `p(x)=True`, then the answer must be honest. Given this requirement, we can easily check whether `find` is lying, and this is what I do in the implementation of `search`:

<pre>search :: S a -> (a -> Bool) -> Maybe a
search xs p = let x = find xs p
              in if p x then Just x else Nothing</pre>

With this representation of searchable sets, we have a shortcut for the implementation of the existential quantifier

<pre>forsome :: S a -> (a -> Bool) -> Bool
forsome xs p = p(find xs p)</pre>

Also notice that the above implementation of `search` is equivalent to

<pre>search xs p = if forsome xs p then Just(find xs p) else Nothing</pre>

### Implementation of the abstract data type

Given the above representation of searchable sets, we have already implemented the first of the operations that define our abstract data type:

<pre>search :: S a -> (a -> Bool) -> Maybe a
image :: (a -> b) -> S a -> S b
singleton :: a -> S a
union :: S a -> S a -> S a
bigUnion :: S(S a) -> S a</pre>

The others can be implemented as follows:

<pre>image :: (a -> b) -> S a -> S b
image f xs = S(\q -> f(find xs (\x -> q(f x))))</pre>

That is, given a predicate `q :: b -> Bool`, to find `y` $\in$ `f(xs)` such that `q(y)` holds, first find `x` $\in$ `xs` such that `q(f x)` holds, and then apply `f` to this `x`.

<pre>singleton :: a -> S a
singleton x = S(\p -> x)</pre>

Given the requirement of the previous section, we can only answer `x`, and this is what we do. To implement binary unions, I first implement doubletons, and then reduce to arbitrary unions:

<pre>doubleton :: a -> a -> S a
doubleton x y = S(\p -> if p x then x else y)

union :: S a -> S a -> S a
xs `union` ys = bigUnion(doubleton xs ys)</pre>

Arbitrary unions are a bit trickier:

<pre>bigUnion :: S(S a) -> S a
bigUnion xss = S(\p -> find(find xss (\xs -> forsome xs p)) p)</pre>

By definition of union, as in set theory, `x` $\in \bigcup$ `xss` $\iff \exists$ `xs` $\in$ `xss` such that `x` $\in$ `xs`. What our definition says is that, in order to find `x` $\in \bigcup$ `xss` such that `p(x)` holds, we first find `xs` $\in$ `xss` such that `p(x)` holds for some `x` $\in$ `xs`, and then find a specific `x` $\in$ `xs` such that `p(x)` holds.

### That's it, we are done

It remains to make a few remarks. After them you'll find the complete Haskell program, which is embarrassingly short in comparison with the size of this post.

### Algorithms for free

There is a Haskell program called [Djinn](http://permalink.gmane.org/gmane.comp.lang.haskell.general/12747) that, given a Haskell type, automatically gives you a recursion-free Haskell program of that type, provided there is some, and lets you know if there isn't any. All the programs discussed here are correctly guessed by Djinn, just from knowledge of their types, except the binary and infinite product algorithms. For the binary product, Djinn gives four guesses. Only two of them are product algorithms, and one of them is equivalent to the one we have defined (the other is the symmetric version). The infinite product is hopeless, because it crucially relies on recursion. But singleton, image and big union are correctly guessed, with a unique guess each. Moreover, Djinn can directly guess the monad structure, in the sense of Haskell, without the detour via singleton, image and big union, which amount to the definition of monad in the sense of category theory.

Thus, all we have to do in principle is to define the type constructor `S` of the monad: once we have done that, Djinn can tell us what the monad operations are, and the Haskell prelude gives us the infinite product algorithm `sequence`. But this is not what happened historically. And of course, once we do have the product algorithm, we have to show that it does accomplish what we claim. The proof is tricky, and is developed in the above two papers, where the first gives a sketch and the second gives complete details.

### The monad laws

The monad laws are rather laborious to prove. Hence I wrote a [Haskell program](/wp-content/uploads/2008/11/proof.hs) that wrote [the proof](/wp-content/uploads/2008/11/proof-output) for me, as follows. The laws are a set of equations. To prove each one, I calculate the normal form of each side of the equation, and check that they are the same except perhaps for the name of the bound variables. The output of the Haskell program is five pages of chains of equations that one can routinely check if one wants to. Presumably I could have done this using a proof assistant, but I found it quicker to write a proof generator for this specific theorem than to familiarize myself with proof assistants (shame on me).

There are two interesting aspects of the monad `S` that become apparent when we develop this proof: (1) Not all elements of `S a` are search functions, but nevertheless the monad laws hold even when the “junk” elements of `S a` are taken into account. (2) The type of booleans in the definition of `S` can be replaced by any type whatsoever and the monad laws still hold. This second point brings me to my final comment.

### Bar recursion

Before I made the connection with monads [earlier this year](http://www.cs.bham.ac.uk/~mhe/papers/selection.pdf), [Paulo Oliva](http://www.dcs.qmul.ac.uk/~pbo/) discovered that the product algorithm given in [[LICS07]](http://www.cs.bham.ac.uk/~mhe/papers/exhaustive.pdf) is a manifestation of bar recursion, provided we replace the booleans by the integers. See his papers at his web page to get an idea of what bar recursion is and what its applications are. Now, putting this together with the above findings, it follows that the Haskell prelude function `sequence` turns out to be a form of bar recursion (technically known as modified bar recursion). Paulo and I have been working together trying to clarify all these connections from a theoretical point of view, and we are writing a paper with these and other findings, this time addressed to the theoretical computer science and logic communities.

### The complete program

I summarize and rearrange the code discussed above, without the contrived examples:

<pre>newtype S a = S {find :: (a -> Bool) -> a}

search :: S a -> (a -> Bool) -> Maybe a
search xs p = let x = find xs p in if p x then Just x else Nothing

forsome, forevery :: S a -> (a -> Bool) -> Bool
forsome xs p = p(find xs p)
forevery xs p = not(forsome xs (\x -> not(p x)))

singleton :: a -> S a
singleton x = S(\p -> x)

doubleton :: a -> a -> S a
doubleton x y = S(\p -> if p x then x else y)

image :: (a -> b) -> S a -> S b
image f xs = S(\q -> f(find xs (\x -> q(f x))))

bigUnion :: S(S a) -> S a
bigUnion xss = S(\p -> find(find xss (\xs -> forsome xs p)) p)

union :: S a -> S a -> S a
xs `union` ys = bigUnion(doubleton xs ys)

instance Monad S where
  return = singleton
  xs >>= f = bigUnion(image f xs)

times :: S a -> S b -> S(a,b)
xs `times` ys = do x <- xs
                   y <- ys
                   return(x,y)

bit :: S Int
bit = doubleton 0 1

cantor :: S [Int]
cantor = sequence (repeat bit)</pre>

### The making of this work

Here is how I came up with the idea of using monads for this purpose. It emerged from the above two papers, and from the ealier [Barbados notes](http://www.sciencedirect.com/science?_ob=ArticleURL&_udi=B75H1-4DTKG8R-3&_user=10&_rdoc=1&_fmt=&_orig=search&_sort=d&view=c&_acct=C000050221&_version=1&_urlVersion=0&_userid=10&md5=d886d0ea55964190ad6843f28527c49d), that searchable sets are compact in the sense of topology. And I was familiar, from denotational semantics, domain theory and topology, with a number of monads of compact sets, notably the Smyth powerdomain monad and the Vietoris hyperspace modad. So although this took some time to mature and be realized, it was inevitable.

What was a surprise to me is that this monadic view of searchable sets shows that the countable product functional, which implements the countable Tychonoff theorem from topology, and which amounts to modified bar recursion from logic in view of Paulo's discovery (which is in itself a surprise), found its way independently in Haskell via the standard prelude function `sequence`. I don't know whether `sequence` was originally intended to be applied to infinite lists, but it can, and moreover in an interesting way. However, for most monads I considered, including the continuation monad and of course excluding the search monad, the functional `sequence` applied to an infinite list gives rise to a divergent computation.
