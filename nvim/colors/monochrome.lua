vim.cmd("hi clear")
vim.o.termguicolors = true
vim.g.colors_name = "monochrome"

local set = vim.api.nvim_set_hl

-- Base
set(0, "Normal",       { fg = "#ffffff", bg = "#000000" })
set(0, "NormalFloat",  { fg = "#ffffff", bg = "#0a0a0a" })
set(0, "CursorLine",   { bg = "#111111" })
set(0, "Visual",       { bg = "#2a2a2a" })
set(0, "LineNr",       { fg = "#444444" })
set(0, "CursorLineNr", { fg = "#ffffff", bold = true })

-- Borders
set(0, "FloatBorder",  { fg = "#444444", bg = "#0a0a0a" })
set(0, "WinSeparator", { fg = "#222222" })

-- Syntax
set(0, "Comment",      { fg = "#666666", italic = true })
set(0, "String",       { fg = "#dddddd" })
set(0, "Number",       { fg = "#bbbbbb" })
set(0, "Keyword",      { fg = "#ffffff", bold = true })
set(0, "Function",     { fg = "#ffffff", bold = true })
set(0, "Type",         { fg = "#cccccc" })
set(0, "Identifier",   { fg = "#ffffff" })

-- Search
set(0, "Search",       { fg = "#000000", bg = "#ffffff" })
set(0, "IncSearch",    { fg = "#000000", bg = "#cccccc" })

-- Diagnostics
set(0, "DiagnosticError", { fg = "#999999" })
set(0, "DiagnosticWarn",  { fg = "#bbbbbb" })
set(0, "DiagnosticInfo",  { fg = "#dddddd" })

-- Popup menu
set(0, "Pmenu",        { fg = "#ffffff", bg = "#111111" })
set(0, "PmenuSel",     { fg = "#000000", bg = "#ffffff" })