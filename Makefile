SRCS := agentic-protocols.md a2a-transport-protocol-support.md
PDFS := $(SRCS:.md=.pdf)

PANDOC_OPTS := \
	--pdf-engine=xelatex \
	--lua-filter=mermaid-filter.lua \
	--variable mainfont="DejaVu Sans" \
	--variable monofont="DejaVu Sans Mono" \
	--variable geometry:margin=1in \
	--syntax-highlighting=tango

.PHONY: all clean

all: $(PDFS)

agentic-protocols.pdf: agentic-protocols.md ag-ui-architecture.svg protocol-stack.svg
	pandoc $(PANDOC_OPTS) -o $@ $<

a2a-transport-protocol-support.pdf: a2a-transport-protocol-support.md
	pandoc $(PANDOC_OPTS) -o $@ $<

clean:
	rm -f $(PDFS)
