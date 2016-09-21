slides:
	pandoc -s -o index.html \
		-t revealjs \
		--template=template.html \
		-V revealjs-url="../../../util/reveal.js/3.3.0" \
		--slide-level=2 \
		-V hlss=zenburn \
		-V theme=simple \
		-V transition=linear \
		-V slideNumber=true \
		-i \
		restful-curl.md
pdf:
	pandoc -o restful-curl.pdf restful-curl.md
