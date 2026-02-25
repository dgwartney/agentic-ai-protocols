SRC := agentic-protocols.md
PDF := $(SRC:.md=.pdf)

PANDOC_OPTS := \
	--pdf-engine=xelatex \
	--lua-filter=mermaid-filter.lua \
	--variable mainfont="DejaVu Sans" \
	--variable monofont="Courier New" \
	--variable geometry:margin=1in \
	--syntax-highlighting=tango \
	--toc \
	--toc-depth=3

.PHONY: all clean

all: $(PDF)

$(PDF): $(SRC) ag-ui-architecture.svg protocol-stack.svg
	pandoc $(PANDOC_OPTS) -o $@ $<

clean:
	rm -f $(PDF)
