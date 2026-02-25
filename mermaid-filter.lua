-- mermaid-filter.lua
-- Pandoc Lua filter: renders ```mermaid code blocks to PNG via mmdc

local counter = 0

function CodeBlock(block)
  if not block.classes[1] or block.classes[1] ~= "mermaid" then
    return nil
  end

  counter = counter + 1
  local tmpdir = os.getenv("TMPDIR") or "/tmp"
  local input_file = tmpdir .. "/mermaid-input-" .. counter .. ".mmd"
  local output_file = tmpdir .. "/mermaid-output-" .. counter .. ".png"

  -- Write mermaid source to temp file
  local f = io.open(input_file, "w")
  f:write(block.text)
  f:close()

  -- Render with mmdc
  local cmd = string.format(
    "mmdc -i %s -o %s -s 2 --backgroundColor white --theme neutral 2>&1",
    input_file, output_file
  )
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  local ok = handle:close()

  if not ok then
    io.stderr:write("mermaid-filter: mmdc failed for block " .. counter .. "\n")
    io.stderr:write(result .. "\n")
    return nil  -- leave original code block on failure
  end

  -- Return image element; use width attribute if specified
  local width = block.attributes["width"] or "85%"
  local caption = block.attributes["caption"] or ""
  local attr = pandoc.Attr("", {}, {{"width", width}})
  local img = pandoc.Image({pandoc.Str(caption)}, output_file, caption, attr)
  return pandoc.Para({img})
end
