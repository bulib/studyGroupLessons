% Transforming writing with pandoc
% Will Kearney
% 09/21/2016

# The Problem

##

###Say you're writing up a manuscript...

...for a journal article (or your thesis or a blog or a presentation ...), and you want to have some nice looking mathematics in it. Your choice of tool is obvious: use TeX in one of its many forms.

##

###You can write out all sorts of cool math

##

```
\begin{equation}
\frac{\partial C}{\partial t} = \nabla \cdot \left(D\nabla C\right)
- u\cdot{} \nabla C + S(\mathbf{x},t)
\end{equation}
```

$$
\frac{\partial C}{\partial t} = \nabla \cdot \left(D\nabla C\right) -
u\cdot{} \nabla C + S(\mathbf{x},t)
$$

##

$$
\begin{aligned}
\dot{x} &= \sigma(y-x) \\
\dot{y} &= \rho x - y - xz \\
\dot{z} &= -\beta z + xy
\end{aligned}
$$

##

### But wait!

First you have to send it to your advisor (or collaborators, etc.) for comments and edits. Maybe not all of your collaborators have your skill at TeX. Maybe they would prefer using Microsoft Word's "track changes" to git or the like. What are you to do?

# Enter pandoc

##

### What is pandoc?

Pandoc is a Haskell library and application which converts files between various markup formats

##

### What can pandoc read and write?

##

![Pandoc's input and output formats](http://pandoc.org/diagram.jpg){height=500px}

##

### How do I get pandoc?

- Check your package manager
- [Pandoc's install page](http://pandoc.org/installing.html)
- If you are a Haskeller and want the source, use [stack](http://haskellstack.org) (`stack install pandoc`)

##

### How do I use pandoc?

```
pandoc -o example.tex example.md
pandoc -o example.pdf example.md
pandoc -o example.docx example.md
pandoc -s -o example.html example.md
pandoc -s -o example.html -t revealjs example.md
```

# Markdown

##

### You can use pandoc to convert TeX to docx

##

### But you can also write everything in Markdown

##

### A simple, human-readable markup syntax


```
### This is a header
You can **bold** or *italicize*.
[Link to things](http://pandoc.org)
![Insert images](http://pandoc.org/diagram.jpg)

- You can do lists
- Just like this

> As are blockquotes
> Four score and seven years ago...
```

##

### This is a header
You can **bold** or *italicize*.

[Link to things](http://pandoc.org)

![Insert images](http://www.bu.edu/brand/files/2012/10/BU-Master-Logo.gif)

- You can do lists
- Just like this

> As are blockquotes.
> Four score and seven years ago...

##

### Pandoc extends Markdown

`````
```
This is a fenced code block
```
You can use raw TeX: $E=mc^2$

$$
R_{\mu \nu} - \frac{1}{2}R g_{\mu \nu} + \Lambda g_{\mu \nu}
= \frac{8\pi G}{c^4}T_{\mu \nu}
$$

And footnotes![^1]

[^1]: Very convenient, but don't use these for citations

Instead, use pandoc's citation format [@Macfarlane_2015]

`````

## 

```
This is a fenced code block
```
You can use raw TeX: $E=mc^2$

$$
R_{\mu \nu} - \frac{1}{2}R g_{\mu \nu} + \Lambda g_{\mu \nu}
= \frac{8\pi G}{c^4}T_{\mu \nu}
$$

And footnotes![^1]

[^1]: Very convenient, but don't use these for citations

Instead, use pandoc's citation format [@Macfarlane_2015]
