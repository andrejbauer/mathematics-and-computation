---
id: 85
title: The Programming Languages Zoo
date: 2008-05-06T12:43:42+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/2008/05/06/the-programming-languages-zoo/
permalink: /2008/05/06/the-programming-languages-zoo/
categories:
  - Programming languages
  - Software
---
I teach [Theory of Programing Languages](http://ucilnica.fmf.uni-lj.si/course/view.php?id=4) (page in Slovene). For the course I implemented languages which demonstrate basic concepts such as parsing, type checking, type inference, dynamic types, evaluation strategies, and compilation. My teaching assistant [Iztok Kavkler](http://www.fmf.uni-lj.si/~kavkler/) contributed to the source code as well. I decided to publish the source code as a [**Programming Language Zoo**](http://www.andrej.com/plzoo/) for anyone who wants to know more about design and implementation of programming languages.  
<!--more-->

The languages are not meant to compete in speed or complexity with their bigger cousins from the real world. On the contrary, they are deliberately very simple, as each language introduces only one or two new basic ideas. You should find the source code useful if you want to learn _the basics_.

It takes time to clean up the code and translate it from Slovene to English, so I am starting with just three languages:

  * **calc** &#8211; a simple calculator
  * **miniml** &#8211; eager purely functional language
  * **minihaskell** &#8211; lazy purely functional language

I have many more in store: a polymorphic functional language, an imperative language, a language with record subtyping, an object-oriented language, miniScheme, and miniProlog. I will eventually clean up the source code and publish it in the [PL Zoo](http://www.andrej.com/plzoo/). In the future I would like to add other languages, as well as demonstrate a variety of compilation and optimization techniques.

All langauges are implemented in [Ocaml](http://www.ocaml.org/).

You are welcome to ask questions and discuss the languages on this blog.
