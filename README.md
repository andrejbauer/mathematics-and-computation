# Mathematics and Computation blog

This is the source code for [Mathematics and
computation](http://math.andrej.com/) by [Andrej Bauer](http://www.andrej.com/).
Until August 2019 the blog was hosted on a [Wordpress](https://wordpress.org)
server, but it was then converted to [Jekyll](https://jekyllrb.com).

## Copyright

The authors of the posts have the copyright, but you are encouraged to use and
spread the ideas and the programs in the spirit of academic co-operation.

## Contributing

### How to contribute a new post

While most posts are written by Andrej Bauer, there are occasional guest posts.
If you would like to contribute, please contact me first with your idea. If we
agree, the post will be written in [Markdown](https://www.markdownguide.org)
with full LaTeX math support by [MathJax](https://www.mathjax.org), and
submitted as a pull request.

### Help updating old posts

Ther 141 posts prior to August 2019 were ported from the old Wordpress server by
a series of spells and incantations that converted HTML to Markdown. They are
not perfect, and some still contain the outdated
[ASCIIMath](http://asciimath.org) mathematics. I will gladly accept pull
requests which update some of these. I can offer little more than thanks and an
acknowledgement at the top of the post.

## How to generate the pages

If you are going to contribute a pull request, you might be interested in
generating the blog locally on your computer. Here is the procedure:

1. Prerequisites:

    * [Ruby](https://www.ruby-lang.org/en/) and [Bundler](https://bundler.io)
    * [Jekyll](https://jekyllrb.com)

2. In the repository, run the command `bundle install`.
3. To generate the blog and serve it locally at http://localhost:4000/, run the
   command `bundle exec jekyll serve`.
