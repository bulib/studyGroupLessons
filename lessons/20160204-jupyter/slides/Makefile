## Markdown extension (e.g. md, markdown, mdown).
MEXT = md
## All markdown files in the directory above working directory
SRC = ../1_introduction.md
### Location of reveal.js
RJS = reveal.js
RJSTEMPLATE = default.revealjs

HTML=$(SRC:.md=.html)
all:	$(HTML)
html:	clean $(HTML)

%.html:	%.md
		@echo "Converting $< to HTML"
		pandoc -t revealjs -i \
			--standalone \
			--template=$(RJSTEMPLATE) \
 			-V hlss=zenburn \
			-V revealjs-url=$(RJS) \
			-V theme=simple \
			-V transition=linear \
			-V slideNumber=true \
			-V center=true \
			-o $(notdir $@) "$<"

clean:
	rm -f *.html
