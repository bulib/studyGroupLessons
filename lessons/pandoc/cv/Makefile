pdf: tex
	TEXINPUTS="build:" pdflatex -output-directory build build/cv.tex
	./bibproc.sh build
	TEXINPUTS="build:" pdflatex -output-directory build build/cv.tex
	TEXINPUTS="build:" pdflatex -output-directory build build/cv.tex

tex: build
	pandoc -o build/cv.tex --template template.tex cv.yaml

build:
	mkdir build

clean:
	rm -rf build
