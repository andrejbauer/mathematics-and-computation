---
id: 1874
title: Agda Writer
date: 2015-11-07T13:06:55+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1874
permalink: /2015/11/07/agda-writer/
categories:
  - Software
  - Teaching
---
My student [Marko Koležnik](https://github.com/markokoleznik) is about to finish his Master's degree in Mathematics at the University of Ljubljana. He implemented **[Agda Writer](http://markokoleznik.github.io/agda-writer/)**, a graphical user interface  for the Agda proof assistant on the OS X platform. As he puts it, the main advantage of Agda Writer is _no Emacs_, but the list of cool features is a bit longer:

  * **bundled Agda:** it comes with preinstalled Agda so there is **zero installation effort **(of course, you can use your own Agda as well).
  * **UTF-8 keyboard shortcuts:** it is super-easy to enter UTF-8 characters by typing their LaTeX names, just like in Emacs. It trumps Emacs by converting ASCII arrows to their UTF8 equivalents on the fly. In the preferences you can customize the long list of shortcuts to your liking.
  * the usual features expected on OS X are all there: **auto-completion**, **clickable error messages and goals**, etc.

Agda Writer is open source. Everybody is welcome to help out and participate on the [Agda Writer repository](https://github.com/markokoleznik/agda-writer).

Who is Agda Writer for? Obviously for students, mathematicians, and other potential users who were not born with Emacs hard-wired into their brains. It is great for teaching Agda as you do not have to spend two weeks explaining Emacs. The only drawback is that it is limited to OS X. Someone should write equivalent Windows and Linux applications. Then perhaps proof assistants will have a chance of being more widely adopted.
