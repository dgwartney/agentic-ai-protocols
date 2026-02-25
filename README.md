# Agentic AI Protocols: A Technical Survey

**Author:** David Gwartney (david.gwartney@gmail.com)

A comprehensive technical survey of the emerging protocol landscape for autonomous AI agents, covering tool interaction, agent-to-agent communication, networking and identity infrastructure, agent-user interaction, and specialized domain protocols.

## Document

The survey is authored in Markdown (`agentic-protocols.md`) and compiled to PDF via pandoc with XeLaTeX. Diagrams are a mix of inline Mermaid (rendered to PNG at build time) and hand-crafted SVG files.

### Protocols Covered

| Category | Protocols |
|----------|-----------|
| Context & Tool Interaction | MCP, TAP, FCP, UTCP |
| Agent-to-Agent Communication | A2A, ACP, OAP |
| Networking & Identity Infrastructure | ANP, AGP, LMOS |
| Agent-User Interaction | AG-UI |
| Specialized Domain | ACP-Commerce, AP2, TDF, Agora |

## Prerequisites

The following tools must be installed to build the PDF:

- [pandoc](https://pandoc.org/) (tested with v3.x)
- [XeLaTeX](https://tug.org/xetex/) (typically via TeX Live or MacTeX)
- [mermaid-cli](https://github.com/mermaid-js/mermaid-cli) (`mmdc`, tested with v11.12.0)
- DejaVu Sans and DejaVu Sans Mono fonts

### macOS (Homebrew)

```bash
brew install pandoc
brew install --cask mactex
npm install -g @mermaid-js/mermaid-cli
```

### Ubuntu/Debian

```bash
sudo apt-get install pandoc texlive-xetex fonts-dejavu
npm install -g @mermaid-js/mermaid-cli
```

## Building

```bash
make
```

This produces `agentic-protocols.pdf` in the project root.

To remove build artifacts:

```bash
make clean
```

### How the Build Works

1. **pandoc** reads `agentic-protocols.md` and applies `mermaid-filter.lua`
2. The Lua filter detects `` ```mermaid `` code blocks, writes each to a temp file, and invokes `mmdc` to render a PNG image
3. SVG diagrams (`ag-ui-architecture.svg`, `protocol-stack.svg`) are referenced as standard Markdown images and embedded by pandoc
4. **XeLaTeX** produces the final PDF with table of contents and syntax highlighting

## Project Structure

```
.
├── Makefile                  # Build configuration
├── agentic-protocols.md      # Survey source document
├── mermaid-filter.lua        # Pandoc Lua filter for Mermaid rendering
├── ag-ui-architecture.svg    # AG-UI architecture diagram (SVG)
├── protocol-stack.svg        # Protocol stack reference diagram (SVG)
├── CHANGELOG.md              # Document change log
└── README.md                 # This file
```

## License

This work is licensed under a [Creative Commons Attribution 4.0 International License (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).

© 2026 David Gwartney (david.gwartney@gmail.com)
