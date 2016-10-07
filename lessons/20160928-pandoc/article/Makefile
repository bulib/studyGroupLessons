all: legends.tex build
	pandoc --filter pandoc-citeproc --template includes/discharge.template --include-after build/legends.tex -o build/discharge.pdf discharge.md metadata.yaml 2> pandoc.log

tex: build
	pandoc -s --filter pandoc-citeproc --template includes/discharge.template -o build/discharge.tex discharge.md metadata.yaml 2> pandoc.log

discharge_png.md: build
	sed s/.pdf/.png/g discharge.md > build/discharge_png.md

doc: discharge_png.md build
	pandoc -s --filter pandoc-citeproc -o build/discharge.docx build/discharge_png.md metadata.yaml 2> pandoc.log

legends.tex: build
	pandoc -o build/legends.tex legends.md

supplemental: build
	pandoc -s --variable graphics=true -o build/supplemental.pdf --template includes/discharge.template supplemental.md metadata.yaml

build:
	mkdir -p build

clean:
	rm -rf build
