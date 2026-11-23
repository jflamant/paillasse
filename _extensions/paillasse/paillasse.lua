-- paillasse.lua: turn level-1 headings (# Section) into section divider slides.
--
-- Document options (YAML header):
--   section-divider: false          plain section slides, no coloured background
--   section-divider-color: "#hex"   background colour (default: theme's $divider-bg)
--
-- Per slide: add {.no-divider} to a # heading, or give it your own
-- background (e.g. {background-image="figure.png"}) to opt out.

local enabled = true
local color = "var(--paillasse-divider-bg)"

local function read_options(meta)
  if meta["section-divider"] == false then
    enabled = false
  end
  if meta["section-divider-color"] ~= nil then
    color = pandoc.utils.stringify(meta["section-divider-color"])
  end
end

local function has_background(el)
  for key, _ in pairs(el.attributes) do
    if key:match("^background") or key:match("^data%-background") then
      return true
    end
  end
  return false
end

local function make_divider(el)
  if not enabled or el.level ~= 1 then
    return nil
  end
  if el.classes:includes("no-divider") or has_background(el) then
    return nil
  end
  el.attributes["background-color"] = color
  el.classes:insert("divider")
  return el
end

return {
  { Meta = read_options },
  { Header = make_divider },
}
