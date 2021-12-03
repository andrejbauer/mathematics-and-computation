---
id: 706
title: How eff handles built-in effects
date: 2010-09-28T23:03:41+02:00
author: Matija Pretnar
layout: post
guid: http://math.andrej.com/?p=706
permalink: /2010/09/28/how-eff-handles-built-in-effects/
categories:
  - Eff
  - Guest post
---
**[UPDATE 2012-03-08: since this post was written eff has changed considerably. For updated information, please visit the [eff page](/eff/).]**

From some of the responses we have been getting it looks like people think that the `io` effect in eff is like `unsafePerformIO` in Haskell, namely that it causes an effect but pretends to be pure. This is _not_ the case. Let me explain how eff handles built-in effects.

<!--more-->

### What does the `io` handler do?

The `io` handler does not print anything. It handles operations `print_string`, `read_string`, and `read_string` by triggering further operations, for example `print_string` triggers `PRINT_STRING` (which is not a valid operation name in eff, so programmers can't do the same thing). Have a look at `builtin.ml` in the [repository](http://hg.andrej.com/eff/).

There are only a handful of such built-in operations. Currently they are `RAISE`, `PRINT_STRING`, `PRINT_VALUE` and `READ_STRING`, see the file `toplevel.ml` (at the moment the interpreter is a bit fishy about handling native references, but we promise to fix that soon). We try to keep their number small, as these are the gates to actual real-world effects.

Now, `PRINT_STRING` and the others are treated just as any other operation. Since no user-defined handler can possibly handle them (they have invalid eff names), they float up to the toplevel. The piece of theory which guarantees this is the equation which says that when $h$ does not handle the operation $f$ then $$h (f (p, k)) = f (p, h \circ k).$$

### Who does all the printing then?

So what the toplevel sees is an element of the free algebra over the built-in operations. In order to do something sensible with this free algebra, eff wraps the computation in a special built-in handler that handles the built-in operations. This is the handler that triggers the actual hardware effects and yields back their results to continuations. It is the only non-pure part of eff.

The programmer cannot escape the toplevel handler, and neither can he somehow invoke it secretly to get something like `unsafePerformIO`. It is always wrapped around your computation, on the outside.

The only reason we could think of for having `unsafePerformIO` is to give the programmer a hack with which he can shoot himself in the foot. So we decided that all I/O should be handled in a tightly controlled way, just like other effects. But since we also understand that programmers need a hack that allows them to easily print debugging info (until there is a debugger), we provided the `check` statement for that purpose.

### Can other operations float unhandled all the way to the toplevel?

Yes, this is possible when an operation escapes its handler. The easiest way to do this is to send an operation outside of its scope in a closure. For example, consider an operation `kaboom`:

<pre class="brush: plain; gutter: false; highlight: [8]; title: ; notranslate" title="">>>> effect bomb:
...     operation kaboom(): BigExplosion
... with bomb:
...     a = 5
...     kaboom()
...     a + 4
...
BigExplosion
</pre>

So far no surprises, the operation was handled. But now:

<pre class="brush: plain; gutter: false; highlight: [5]; title: ; notranslate" title="">>>> f = (with bomb:
...          lambda (): kaboom ())
... f ()
...
Runtime error: Uncaught operation kaboom () (global). (L3, 1-3)
</pre>

Because the operation `kaboom` was triggered in line 3, which is outside of the scope of its handler, it propagated to the toplevel. What is eff supposed to do with it? We decided it is best to report a runtime error. Once we have a type system, eff should be able to report at compile time that an operation might end up being unhandled.

### But I want my programs to be pure!

You are out of luck then. If a program is _absolutely_ pure, you need not run it since it won't cause an observable effect. Even in Haskell the program is required to be in the `IO` monad. After all, the only way for a program to communicate with the outside world is through a computational effect.

It is a good idea to concentrate all real-world computational effects just in one place, without cheating, and treat them in the same way as user-defined effects, as far as that is feasible. It should then be possible to devise a type system which can guarantee that certain effects do not happen, just like in Haskell. The algebraic semantics of eff is such a type system, but at a semantic level. What we need now is a useful implementation of it.
