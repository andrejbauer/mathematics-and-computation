---
id: 86
title: An object-oriented language Boa
date: 2008-05-07T00:32:33+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/2008/05/07/an-object-oriented-language-boa/
permalink: /2008/05/07/an-object-oriented-language-boa/
categories:
  - Programming languages
  - Software
---
I have added another language, called _Boa_, to the [Programming Languages Zoo](http://www.andrej.com/plzoo/). It is an object-oriented language with the following features:

  * integers and booleans as base types,
  * first-class functions,
  * dynamically typed,
  * objects are extensible records with mutable fields,
  * there are no classes, instead we can define &#8220;prototype&#8221; objects and extend them  
    to create instances.

<!--more-->

In many respects the language is a bit like a combination of Python and Javascript, which explains its name. It was interesting to see the students&#8217; reaction to the language. The only object-oriented language they knew previously was java, so the lack of classes bothered them. They were amused by the fact that since &#8220;everything is an object&#8221; we can extend an integer with a function to get an object which behaves both as an integer and as a function (we did not learn about intersection types), like this:

> <pre>Boa&gt; let x = 42 with (fun x -&gt; x + 1000)
x = 42 with &lt;fun&gt;
Boa> x + 10
52
Boa&gt; x 17
1017
Boa&gt; x x
1042
</pre>

Isn&#8217;t that cute?
