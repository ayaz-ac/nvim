-- Colorschemes generated from the Ghostty theme files of the same name, so
-- Neovim and the terminal show identical colors. Palettes come from
-- /Applications/Ghostty.app/Contents/Resources/ghostty/themes/{Breadog,Breeze}.
local M = {}

-- Builds every highlight group from a palette. `p.ansi` holds the 16 terminal
-- colors copied verbatim from Ghostty. The named roles (red, blue, ...) pick
-- which of those two shades reads best on this background: Breeze inverts the
-- usual convention and keeps its brighter colors in the normal 1-6 slots. The
-- remaining shades (cursorline, floats, borders) are tinted from the
-- background, because Ghostty has no equivalent for them.
function M.load(name, p)
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

-- Tracks the terminal light/dark mode and matches Ghostty's theme setting
-- (light:Breadog,dark:Breeze). Neovim subscribes to DEC mode 2031 and
-- re-queries OSC 11, so 'background' updates live when the macOS appearance
-- flips at day/night -- no polling needed.
function M.follow_terminal()
  local function apply()
    local want = vim.o.background == "light" and "breadog" or "breeze"
    -- Setting the colorscheme also sets 'background', which re-enters this
    -- callback; bail out when we are already on the right one.
    if vim.g.colors_name ~= want then
      vim.cmd.colorscheme(want)
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
