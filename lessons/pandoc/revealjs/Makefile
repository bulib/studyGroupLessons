all: build
	pandoc -s -o build/presentation.html -t revealjs --slide-level=2 --variable theme=simple --variable revealjs-url="../../../../util/reveal.js/3.3.0" presentation.md

build:
	mkdir -p build

clean:
	rm -rf build
