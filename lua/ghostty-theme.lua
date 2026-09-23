-- Colorscheme built at startup from the Ghostty theme, so Neovim and the
-- terminal show identical colors and no palette is defined here. It reads the
-- `theme` line of the Ghostty config, loads that theme file, and derives the
-- highlight roles from its 16 colors.
local M = {}

local home = vim.env.HOME
local config_home = vim.env.XDG_CONFIG_HOME or (home .. "/.config")
local resources = vim.env.GHOSTTY_RESOURCES_DIR or "/Applications/Ghostty.app/Contents/Resources/ghostty"

-- Ghostty loads these in order; a later file overrides an earlier one.
local config_files = {
  config_home .. "/ghostty/config",
  config_home .. "/ghostty/config.ghostty",
  home .. "/Library/Application Support/com.mitchellh.ghostty/config",
  home .. "/Library/Application Support/com.mitchellh.ghostty/config.ghostty",
}

local function read_pairs(path, on_pair)
  local f = io.open(path, "r")
  if not f then
    return false
  end
  for line in f:lines() do
    local key, value = line:match("^%s*([%w%-]+)%s*=%s*(.-)%s*$")
    if key then
      on_pair(key, (value:gsub('^"(.*)"$', "%1")))
    end
  end
  f:close()
  return true
end

-- Returns { light = name, dark = name } from `light:A,dark:B` or a single name.
local function theme_names()
  local value
  for _, path in ipairs(config_files) do
    read_pairs(path, function(key, v)
      if key == "theme" then
        value = v
      end
    end)
  end
  if not value then
    return nil
  end
  local light, dark = value:match("light:([^,]+)"), value:match("dark:([^,]+)")
  if light or dark then
    return { light = vim.trim(light or dark), dark = vim.trim(dark or light) }
  end
  return { light = value, dark = value }
end

local function read_theme(name)
  local candidates = { name, config_home .. "/ghostty/themes/" .. name, resources .. "/themes/" .. name }
  local t = { palette = {} }
  for _, path in ipairs(candidates) do
    if name:sub(1, 1) == "/" or path ~= name then
      local found = read_pairs(path, function(key, v)
        if key == "palette" then
          local i, hex = v:match("^(%d+)%s*=%s*(#?%x+)$")
          if i then
            t.palette[tonumber(i)] = hex
          end
        else
          t[key] = v
        end
      end)
      if found and t.background and t.foreground and #t.palette >= 15 then
        return t
      end
    end
  end
  return nil
end

local function rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

local function mix(a, b, t)
  local r1, g1, b1 = rgb(a)
  local r2, g2, b2 = rgb(b)
  local function ch(x, y)
    return math.floor(x + (y - x) * t + 0.5)
  end
  return string.format("#%02x%02x%02x", ch(r1, r2), ch(g1, g2), ch(b1, b2))
end

local function luminance(hex)
  local function lin(c)
    c = c / 255
    return c <= 0.03928 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4
  end
  local r, g, b = rgb(hex)
  return 0.2126 * lin(r) + 0.7152 * lin(g) + 0.0722 * lin(b)
end

local function contrast(a, b)
  local la, lb = luminance(a), luminance(b)
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05)
end

-- Moves a color toward the foreground until it reaches `min` contrast on bg.
local function readable(color, bg, fg, min)
  local c = color
  for step = 1, 10 do
    if contrast(c, bg) >= min then
      break
    end
    c = mix(color, fg, step / 10)
  end
  return c
end

-- Each color has a normal (1-6) and a bright (9-14) slot. Which one reads
-- best depends on the theme, so the higher-contrast slot takes the main role.
local function palette(t)
  local bg, fg = "#" .. t.background:gsub("#", ""), "#" .. t.foreground:gsub("#", "")
  local ansi = {}
  for i = 0, 15 do
    ansi[i] = t.palette[i] and ("#" .. t.palette[i]:gsub("#", "")) or fg
  end

  local p = {
    ansi = ansi,
    background = luminance(bg) < 0.18 and "dark" or "light",
    bg = bg,
    fg = fg,
  }
  for i, role in ipairs({ "red", "green", "yellow", "blue", "magenta", "cyan" }) do
    local main, alt = ansi[i], ansi[i + 8]
    if contrast(alt, bg) > contrast(main, bg) then
      main, alt = alt, main
    end
    p[role] = readable(main, bg, fg, 4.5)
    p[role .. "_alt"] = readable(alt, bg, fg, 3.5)
  end

  p.bg_alt = mix(bg, fg, 0.07)
  p.bg_float = mix(bg, fg, 0.04)
  local sel = t["selection-background"] and ("#" .. t["selection-background"]:gsub("#", ""))
  -- Some themes invert fg/bg for selections; Visual keeps the text color, so
  -- fall back to a tint when the theme selection would hide the text.
  p.selection = (sel and contrast(sel, fg) >= 3) and sel or mix(bg, fg, 0.2)
  p.border = mix(bg, fg, 0.25)
  p.comment = readable(ansi[8], bg, fg, 3.5)
  p.muted = mix(bg, fg, 0.35)
  p.diff_add = mix(bg, p.green, 0.18)
  p.diff_change = mix(bg, p.yellow, 0.15)
  p.diff_delete = mix(bg, p.red, 0.18)
  p.diff_text = mix(bg, p.yellow, 0.3)
  return p
end

-- Builds every highlight group from a palette. The shades Ghostty has no
-- equivalent for (cursorline, floats, borders) are tinted from the background.
local function apply_palette(name, p)
  vim.cmd.highlight("clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd.syntax("reset")
  end
  vim.o.background = p.background
  vim.g.colors_name = name

  for i = 0, 15 do
    vim.g["terminal_color_" .. i] = p.ansi[i]
  end

  local hl = {
    Normal = { fg = p.fg, bg = p.bg },
    NormalNC = { fg = p.fg, bg = p.bg },
    NormalFloat = { fg = p.fg, bg = p.bg_float },
    FloatBorder = { fg = p.border, bg = p.bg_float },
    FloatTitle = { fg = p.blue, bg = p.bg_float, bold = true },
    Cursor = { fg = p.bg, bg = p.fg },
    lCursor = { fg = p.bg, bg = p.fg },
    CursorLine = { bg = p.bg_alt },
    CursorColumn = { bg = p.bg_alt },
    ColorColumn = { bg = p.bg_alt },
    LineNr = { fg = p.muted },
    CursorLineNr = { fg = p.yellow, bold = true },
    SignColumn = { bg = p.bg },
    FoldColumn = { fg = p.muted, bg = p.bg },
    Folded = { fg = p.comment, bg = p.bg_alt },
    WinSeparator = { fg = p.border },
    VertSplit = { fg = p.border },
    StatusLine = { fg = p.fg, bg = p.bg_alt },
    StatusLineNC = { fg = p.comment, bg = p.bg_alt },
    TabLine = { fg = p.comment, bg = p.bg_alt },
    TabLineSel = { fg = p.fg, bg = p.bg, bold = true },
    TabLineFill = { bg = p.bg_alt },
    WinBar = { fg = p.comment, bg = p.bg },
    WinBarNC = { fg = p.muted, bg = p.bg },
    Visual = { bg = p.selection },
    VisualNOS = { bg = p.selection },
    Search = { fg = p.bg, bg = p.yellow },
    IncSearch = { fg = p.bg, bg = p.yellow_alt },
    CurSearch = { fg = p.bg, bg = p.yellow_alt },
    Substitute = { fg = p.bg, bg = p.red },
    MatchParen = { fg = p.yellow_alt, bold = true },
    Pmenu = { fg = p.fg, bg = p.bg_float },
    PmenuSel = { fg = p.fg, bg = p.selection, bold = true },
    PmenuSbar = { bg = p.bg_alt },
    PmenuThumb = { bg = p.border },
    PmenuKind = { fg = p.magenta, bg = p.bg_float },
    PmenuExtra = { fg = p.comment, bg = p.bg_float },
    NonText = { fg = p.muted },
    EndOfBuffer = { fg = p.bg },
    Whitespace = { fg = p.muted },
    SpecialKey = { fg = p.muted },
    Conceal = { fg = p.comment },
    Directory = { fg = p.blue, bold = true },
    Title = { fg = p.blue, bold = true },
    ErrorMsg = { fg = p.red },
    WarningMsg = { fg = p.yellow_alt },
    ModeMsg = { fg = p.fg, bold = true },
    MoreMsg = { fg = p.green },
    Question = { fg = p.green },
    MsgArea = { fg = p.fg },
    QuickFixLine = { bg = p.bg_alt, bold = true },
    WildMenu = { fg = p.bg, bg = p.blue },

    Comment = { fg = p.comment, italic = true },
    Constant = { fg = p.magenta },
    String = { fg = p.green },
    Character = { fg = p.green },
    Number = { fg = p.magenta },
    Boolean = { fg = p.magenta },
    Float = { fg = p.magenta },
    Identifier = { fg = p.fg },
    Function = { fg = p.blue },
    Statement = { fg = p.magenta_alt },
    Conditional = { fg = p.magenta_alt },
    Repeat = { fg = p.magenta_alt },
    Label = { fg = p.magenta_alt },
    Operator = { fg = p.cyan },
    Keyword = { fg = p.magenta_alt },
    Exception = { fg = p.red },
    PreProc = { fg = p.cyan },
    Include = { fg = p.magenta_alt },
    Define = { fg = p.magenta_alt },
    Macro = { fg = p.cyan },
    Type = { fg = p.yellow_alt },
    StorageClass = { fg = p.yellow_alt },
    Structure = { fg = p.yellow_alt },
    Typedef = { fg = p.yellow_alt },
    Special = { fg = p.cyan },
    SpecialComment = { fg = p.comment, bold = true },
    Delimiter = { fg = p.fg },
    Underlined = { fg = p.blue, underline = true },
    Bold = { bold = true },
    Italic = { italic = true },
    Todo = { fg = p.bg, bg = p.yellow_alt, bold = true },
    Error = { fg = p.red },

    DiffAdd = { fg = p.green, bg = p.diff_add },
    DiffChange = { fg = p.yellow_alt, bg = p.diff_change },
    DiffDelete = { fg = p.red, bg = p.diff_delete },
    DiffText = { fg = p.yellow_alt, bg = p.diff_text },
    Added = { fg = p.green },
    Changed = { fg = p.yellow_alt },
    Removed = { fg = p.red },

    DiagnosticError = { fg = p.red },
    DiagnosticWarn = { fg = p.yellow_alt },
    DiagnosticInfo = { fg = p.blue_alt },
    DiagnosticHint = { fg = p.cyan_alt },
    DiagnosticOk = { fg = p.green_alt },
    DiagnosticUnderlineError = { sp = p.red, undercurl = true },
    DiagnosticUnderlineWarn = { sp = p.yellow_alt, undercurl = true },
    DiagnosticUnderlineInfo = { sp = p.blue_alt, undercurl = true },
    DiagnosticUnderlineHint = { sp = p.cyan_alt, undercurl = true },
    DiagnosticUnderlineOk = { sp = p.green_alt, undercurl = true },
    DiagnosticVirtualTextError = { fg = p.red },
    DiagnosticVirtualTextWarn = { fg = p.yellow_alt },
    DiagnosticVirtualTextInfo = { fg = p.blue_alt },
    DiagnosticVirtualTextHint = { fg = p.cyan_alt },

    LspReferenceText = { bg = p.bg_alt },
    LspReferenceRead = { bg = p.bg_alt },
    LspReferenceWrite = { bg = p.bg_alt, underline = true },
    LspInlayHint = { fg = p.muted, bg = p.bg_alt },
    LspSignatureActiveParameter = { fg = p.yellow_alt, bold = true },

    ["@variable"] = { fg = p.fg },
    ["@variable.builtin"] = { fg = p.red },
    ["@variable.parameter"] = { fg = p.blue_alt },
    ["@variable.member"] = { fg = p.cyan },
    ["@constant"] = { fg = p.magenta },
    ["@constant.builtin"] = { fg = p.magenta, bold = true },
    ["@module"] = { fg = p.yellow_alt },
    ["@string.escape"] = { fg = p.cyan },
    ["@function"] = { fg = p.blue },
    ["@function.builtin"] = { fg = p.blue_alt },
    ["@function.method"] = { fg = p.blue },
    ["@constructor"] = { fg = p.yellow_alt },
    ["@keyword"] = { fg = p.magenta_alt },
    ["@keyword.operator"] = { fg = p.magenta_alt },
    ["@type"] = { fg = p.yellow_alt },
    ["@type.builtin"] = { fg = p.yellow_alt, italic = true },
    ["@property"] = { fg = p.cyan },
    ["@attribute"] = { fg = p.cyan },
    ["@tag"] = { fg = p.magenta_alt },
    ["@tag.attribute"] = { fg = p.cyan },
    ["@tag.delimiter"] = { fg = p.comment },
    ["@punctuation.bracket"] = { fg = p.fg },
    ["@punctuation.delimiter"] = { fg = p.comment },
    ["@punctuation.special"] = { fg = p.cyan },
    ["@comment.error"] = { fg = p.bg, bg = p.red },
    ["@comment.warning"] = { fg = p.bg, bg = p.yellow_alt },
    ["@comment.todo"] = { fg = p.bg, bg = p.blue_alt },
    ["@comment.note"] = { fg = p.bg, bg = p.cyan_alt },
    ["@markup.heading"] = { fg = p.blue, bold = true },
    ["@markup.link"] = { fg = p.blue_alt, underline = true },
    ["@markup.raw"] = { fg = p.green },
    ["@markup.list"] = { fg = p.cyan },
    ["@diff.plus"] = { fg = p.green },
    ["@diff.minus"] = { fg = p.red },

    GitSignsAdd = { fg = p.green },
    GitSignsChange = { fg = p.yellow_alt },
    GitSignsDelete = { fg = p.red },

    TelescopeNormal = { fg = p.fg, bg = p.bg_float },
    TelescopeBorder = { fg = p.border, bg = p.bg_float },
    TelescopeTitle = { fg = p.bg, bg = p.blue, bold = true },
    TelescopeSelection = { bg = p.selection, bold = true },
    TelescopeMatching = { fg = p.yellow_alt, bold = true },
    TelescopePromptPrefix = { fg = p.magenta_alt },

    NeoTreeNormal = { fg = p.fg, bg = p.bg_alt },
    NeoTreeNormalNC = { fg = p.fg, bg = p.bg_alt },
    NeoTreeWinSeparator = { fg = p.border, bg = p.bg_alt },
    NeoTreeDirectoryName = { fg = p.blue },
    NeoTreeDirectoryIcon = { fg = p.blue },
    NeoTreeRootName = { fg = p.magenta_alt, bold = true },
    NeoTreeGitModified = { fg = p.yellow_alt },
    NeoTreeGitAdded = { fg = p.green },
    NeoTreeGitDeleted = { fg = p.red },
    NeoTreeIndentMarker = { fg = p.muted },

    MiniIndentscopeSymbol = { fg = p.border },
    MiniCursorword = { bg = p.bg_alt },
    MiniCursorwordCurrent = { bg = p.bg_alt },

    WhichKey = { fg = p.magenta_alt },
    WhichKeyGroup = { fg = p.blue },
    WhichKeyDesc = { fg = p.fg },
    WhichKeySeparator = { fg = p.comment },
    WhichKeyFloat = { bg = p.bg_float },
  }

  for group, spec in pairs(hl) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end

-- Loads the Ghostty theme for the current 'background'. Returns false when
-- no Ghostty theme is found, so the caller can keep another colorscheme.
function M.load()
  local names = theme_names()
  local name = names and names[vim.o.background]
  local t = name and read_theme(name)
  if not t then
    return false
  end
  apply_palette("ghostty", palette(t))
  vim.g.ghostty_theme = name
  return true
end

-- Tracks the terminal light/dark mode and matches Ghostty's `light:A,dark:B`
-- theme setting. Neovim subscribes to DEC mode 2031 and re-queries OSC 11, so
-- 'background' updates live when the macOS appearance flips at day/night.
function M.follow_terminal()
  local function apply()
    local names = theme_names()
    -- Loading sets 'background', which re-enters this callback; bail out when
    -- the right theme is already loaded.
    if names and vim.g.colors_name == "ghostty" and vim.g.ghostty_theme == names[vim.o.background] then
      return
    end
    if not M.load() then
      vim.cmd.colorscheme("default")
    end
  end

  apply()

  vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "background",
    callback = apply,
    desc = "Match colorscheme to terminal light/dark mode",
  })
end

return M
