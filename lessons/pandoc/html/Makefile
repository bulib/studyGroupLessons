all: build figs css
	pandoc -s -o build/website.html --section-divs -c style.css website.md

css: build
	cp style.css build/

figs: build
	cp -R images build/

build:
	mkdir -p build

clean:
	rm -rf build
