# Changelog

All notable changes to this document are tracked here.

## [0.2.0] - 2025-02-25

### Changed
- Replaced all 10 ASCII art diagrams with rendered diagrams
  - 8 diagrams use inline Mermaid (rendered to PNG via `mermaid-filter.lua`)
  - 2 diagrams use hand-crafted SVG (`ag-ui-architecture.svg`, `protocol-stack.svg`)
- Added `mermaid-filter.lua` Pandoc Lua filter for Mermaid-to-PNG rendering at build time
- Updated `Makefile` with `--lua-filter=mermaid-filter.lua` and SVG dependencies

### Known Issues
- Diagram 6 (AGP Gateway): Domain B arrow direction does not match original
- Diagram 7 (LMOS Platform): Connection lines between components added beyond original
- Diagram 8 (AG-UI SVG): SSE arrowhead direction needs review
- Diagram 9 (AP2 Payment Flow): Extra steps added beyond original
- Diagram 10 (Protocol Stack SVG): Missing "via task delegation" sublabel

## [0.1.0] - 2025-02-23

### Added
- Initial document covering 15 agentic AI protocols across 5 categories
- ASCII art diagrams for all architecture and workflow illustrations
- Comparative analysis table and protocol stack reference
- Full reference list with 27 sources
- Makefile-based PDF build via pandoc/XeLaTeX
