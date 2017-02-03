**Title**: Pandoc

**Author**: Will Kearney, Boston University Study Group

**Level**: Novice

**Prerequisites**: You should be comfortable running programs from the command line. Some experience with writing in Markdown or LaTeX is helpful, but not necessary.

**Tech and Materials**:

To follow along with all of the examples, you'll need [to install pandoc](http://pandoc.org/installing.html), have a functioning LaTeX installation, and, for the slideshow examples, initialize the reveal.js git submodule within this directory:

```
git submodule init util/reveal.js/3.3.0
git submodule update
```

Windows users who need LaTeX should look into [MikTeX](http://miktex.org/), Mac users should look at [MacTeX](https://tug.org/mactex/), and Linux users should try installing [TeX Live](http://www.tug.org/texlive/). You may need to install some LaTeX packages which you can install on Unix platforms with `tlmgr`.

**Time to Complete**: Once you have the software up and running, you should be able to work through these examples in half an hour to an hour.

**Summary and Objectives**: Pandoc is a tool for converting text between different formats. It is particularly useful in academic contexts when you would like to write a manuscript in your favorite format, but need to send it to collaborators in their preferred formats. It can also output slideshows and simple, static websites. 

The goal of this lesson is to get you thinking about your writing workflow and how pandoc can help. We'll work through a few examples. By the end of the lesson, you should be able to run some simple Markdown files through pandoc and turn them into websites, slideshows and nicely-formatted manuscripts.
