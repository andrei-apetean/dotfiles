vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end

vim.o.background = "dark"
vim.g.colors_name = "dusk"

local c = {
  -- Backgrounds
  bg           = "#1d2021",
  bg_hl        = "#292929",
  bg_float     = "#191b1c",
  bg_selection = "#4a4a4a",

  -- Foregrounds
  fg       = "#c9c7c0",
  fg_dim   = "#928374",

  -- Syntax accents
  red      = "#ea6962",  -- keywords, control flow
  peach    = "#e78a4e",  -- storage class, operators, structure
  yellow   = "#d8a657",  -- types
  green    = "#a9b665",  -- functions
  teal     = "#89b482",  -- strings, macros
  blue     = "#7daea3",  -- fields, properties
  mauve    = "#d3869b",  -- numbers, booleans, preprocessor

  -- Diagnostics
  error    = "#ea6962",
  warn     = "#d8a657",
  info     = "#7daea3",
  hint     = "#a9b665",
}

local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- ── Editor UI ─────────────────────────────────
hi("Normal",          { fg = c.fg,      bg = c.bg })
hi("NormalFloat",     { fg = c.fg,      bg = c.bg_float })
hi("NormalNC",        { fg = c.fg_dim,  bg = c.bg })
hi("CursorLine",      { bg = c.bg_hl })
hi("CursorLineNr",    { fg = c.fg,      bold = true })
hi("LineNr",          { fg = c.fg_dim })
hi("SignColumn",      { bg = c.bg })
hi("Visual",          { bg = c.bg_selection })
hi("Search",          { fg = c.bg,      bg = c.warn })
hi("IncSearch",       { fg = c.bg,      bg = c.red })
hi("StatusLine",      { fg = c.fg,  bg = c.bg_hl})
hi("StatusLineNC",    { fg = c.fg,  bg = c.bg })
hi("WinSeparator",    { fg = c.bg_hl })
hi("Pmenu",           { fg = c.fg,      bg = c.bg_float })
hi("PmenuSel",        { fg = c.bg,      bg = c.blue,   bold = true })
hi("PmenuThumb",      { bg = c.fg_dim })
hi("PmenuBorder",     { fg = c.bg_hl,   bg = c.bg_float })
hi("FloatBorder",     { fg = c.bg_hl,   bg = c.bg_float })
hi("PmenuThumb",      { bg = c.fg_dim })
hi("Folded",          { fg = c.fg_dim,  bg = c.bg_hl })
hi("MatchParen",      { fg = c.yellow,  bold = true })
hi("EndOfBuffer",     { fg = c.bg })

-- ── Diagnostics ───────────────────────────────
hi("DiagnosticError",          { fg = c.error })
hi("DiagnosticWarn",           { fg = c.warn })
hi("DiagnosticInfo",           { fg = c.info })
hi("DiagnosticHint",           { fg = c.hint })
hi("DiagnosticOk",             { fg = c.hint })
hi("DiagnosticUnderlineError", { undercurl = true, sp = c.error })
hi("DiagnosticUnderlineWarn",  { undercurl = true, sp = c.warn })
hi("DiagnosticUnderlineInfo",  { undercurl = true, sp = c.info })
hi("DiagnosticUnderlineHint",  { undercurl = true, sp = c.hint })

-- ── Diff ──────────────────────────────────────
hi("DiffAdd",    { fg = c.green })
hi("DiffChange", { fg = c.yellow })
hi("DiffDelete", { fg = c.red })

-- ── Syntax ────────────────────────────────────
hi("Comment",      { fg = c.fg_dim })

hi("Keyword",      { fg = c.red })
hi("Conditional",  { fg = c.red })
hi("Repeat",       { fg = c.red })
hi("Statement",    { fg = c.red })
hi("Typedef",      { fg = c.red })
hi("Exception",    { fg = c.red })
hi("Label",        { fg = c.red })

hi("StorageClass", { fg = c.peach })
hi("Structure",    { fg = c.peach })
hi("Operator",     { fg = c.peach })

hi("Type",         { fg = c.yellow, bold = true })
hi("Function",     { fg = c.green,  bold = true })

hi("String",       { fg = c.teal })
hi("Character",    { fg = c.teal })
hi("Macro",        { fg = c.teal })

hi("Number",       { fg = c.mauve })
hi("Float",        { fg = c.mauve })
hi("Boolean",      { fg = c.mauve })
hi("PreProc",      { fg = c.mauve })
hi("PreCondit",    { fg = c.mauve })
hi("Include",      { fg = c.mauve })
hi("Define",       { fg = c.mauve })

hi("Special",      { fg = c.yellow })
hi("SpecialChar",  { fg = c.yellow })

hi("Identifier",   { fg = c.fg })
hi("Constant",     { fg = c.fg })
hi("Delimiter",    { fg = c.fg_dim })
hi("Error",        { fg = c.error })
hi("Todo",         { fg = c.bg,     bg = c.warn, bold = true })
