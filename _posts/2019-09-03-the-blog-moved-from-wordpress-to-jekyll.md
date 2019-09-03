---
title: The blog moved from Wordpress to Jekyll
author: Andrej Bauer
layout: post
categories:
  - General
---

You may have noticed that lately I have had trouble with the blog. It was dying
periodically because the backend database kept crashing. It was high time I
moved away from Wordpress anyway, so I bit the bullet and ported the blog.

<!--more-->

All in all, it was a typical system administration experience: lots of
installing Ruby and Node.js packages, figuring out which of several equivalent
tools actually is worth using, dealing with scarce and obsolete documentation (a
blog post is *not* a good substitute for proper documentation), etc. But all the
tools are out there, it's just a simple matter of installing them:

* [Jekyll Exporter](https://wordpress.org/plugins/jekyll-exporter/) - an exporter from Wordpress to Jekyll
* [Jekyll](https://jekyllrb.com) - static pages blog, free of databases, with support for Markdown
* [Staticman](https://staticman.net) - a backend for blog comments

I decided to make the blog repository
[`mathematics-and-computation`](https://github.com/andrejbauer/mathematics-and-computation)
public, as there is no good reason to keep it private. In fact, this way people
can contribute by making pull requests (see the
[`README.md`](https://github.com/andrejbauer/mathematics-and-computation/blob/master/README.md).

I will use this post to test the working on the new blog, and especially the
comments, so please excuse silly comments below.
