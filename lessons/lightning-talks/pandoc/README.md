To follow along with the lesson, you'll need [to install pandoc](http://pandoc.org/installing.html).

If you've just cloned this repository and want to make the reveal.js slides (`make slides`), you'll need to initialize the reveal.js submodule. From the studyGroupLessons directory

```
git submodule init util/reveal.js/3.3.0
git submodule update
```

Upon doing that, `make slides` should produce a self-contained reveal.js slideshow in `example.html`.
