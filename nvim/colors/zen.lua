-- TODO: Refactor this file

vim.cmd("highlight clear")

if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end

vim.g.colors_name = "zen"

-- Dark palette (Kanagawa Dragon)
local dark = {
	-- Base
	bg = "#181616",
	bg_light = "#282727",
	bg_lighter = "#393836",
	fg = "#c5c9c5",
	fg_dark = "#a6a69c",
	fg_darker = "#737c73",

	-- UI
	border = "#625e5a",
	cursor_line = "#282727",
	visual = "#394b70",
	pmenu = "#1D1C19",
	float = "#0d0c0c",

	-- Diagnostics
	error = "#c4746e",
	warning = "#c4b28a",
	info = "#8ea4a2",
	hint = "#949fb5",

	-- Diff
	diff_add = "#87a987",
	diff_delete = "#c4746e",
	diff_change = "#b6927b",
	diff_text = "#12120f",

	-- Syntax
	red = "#c4746e",
	orange = "#b6927b",
	yellow = "#c4b28a",
	green = "#87a987",
	aqua = "#8ea4a2",
	blue = "#8ba4b0",
	cyan = "#949fb5",
	purple = "#8992a7",
	magenta = "#a292a3",
}

-- Light palette (Kanagawa Lotus with pure white background)
local light = {
	-- Base
	bg = "#ffffff",
	bg_light = "#f5f5f5",
	bg_lighter = "#ebebeb",
	fg = "#545464",
	fg_dark = "#43436c",
	fg_darker = "#8a8980",

	-- UI
	border = "#c0c0c0",
	cursor_line = "#f8f8f8",
	visual = "#c7d7e0",
	pmenu = "#f0f0f0",
	float = "#fafafa",

	-- Diagnostics
	error = "#e82424",
	warning = "#e98a00",
	info = "#597b75",
	hint = "#5a7785",

	-- Diff
	diff_add = "#6f894e",
	diff_delete = "#c84053",
	diff_change = "#836f4a",
	diff_text = "#d7e3d8",

	-- Syntax
	red = "#c84053",
	orange = "#cc6d00",
	yellow = "#836f4a",
	green = "#6f894e",
	aqua = "#597b75",
	blue = "#4d699b",
	cyan = "#5e857a",
	purple = "#624c83",
	magenta = "#b35b79",
}

local palette = vim.o.background == "dark" and dark or light

local function hl(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

-- Base
hl("Normal", { fg = palette.fg, bg = palette.bg })
hl("NormalFloat", { fg = palette.fg, bg = palette.float })
hl("FloatBorder", { fg = palette.border, bg = palette.float })
hl("FloatTitle", { fg = palette.fg, bg = palette.float, bold = true })
hl("ColorColumn", { bg = palette.bg_light })
hl("Conceal", { fg = palette.fg_darker })
hl("Cursor", { fg = palette.bg, bg = palette.fg })
hl("lCursor", { link = "Cursor" })
hl("CursorIM", { link = "Cursor" })
hl("CursorLine", { bg = palette.cursor_line })
hl("CursorColumn", { link = "CursorLine" })
hl("Directory", { fg = palette.blue })
hl("DiffAdd", { bg = palette.diff_add, fg = palette.bg })
hl("DiffChange", { bg = palette.diff_change, fg = palette.bg })
hl("DiffDelete", { bg = palette.diff_delete, fg = palette.bg })
hl("DiffText", { bg = palette.diff_text, fg = palette.fg })
hl("EndOfBuffer", { fg = palette.bg })
hl("ErrorMsg", { fg = palette.error, bold = true })
hl("VertSplit", { fg = palette.border })
hl("WinSeparator", { link = "VertSplit" })
hl("Folded", { fg = palette.fg_darker, bg = palette.bg_light })
hl("FoldColumn", { fg = palette.fg_darker })
hl("SignColumn", { fg = palette.fg_darker })
hl("IncSearch", { fg = palette.bg, bg = palette.orange, bold = true })
hl("Substitute", { link = "IncSearch" })
hl("LineNr", { fg = palette.fg_darker })
hl("CursorLineNr", { fg = palette.fg_dark, bold = true })
hl("MatchParen", { fg = palette.orange, bold = true })
hl("ModeMsg", { fg = palette.fg, bold = true })
hl("MsgArea", { fg = palette.fg })
hl("MoreMsg", { fg = palette.green, bold = true })
hl("NonText", { fg = palette.fg_darker })
hl("Pmenu", { fg = palette.fg, bg = palette.pmenu })
hl("PmenuSel", { fg = palette.bg, bg = palette.blue })
hl("PmenuSbar", { bg = palette.bg_light })
hl("PmenuThumb", { bg = palette.fg_darker })
hl("Question", { fg = palette.green, bold = true })
hl("QuickFixLine", { fg = palette.bg, bg = palette.blue })
hl("Search", { fg = palette.bg, bg = palette.yellow })
hl("SpecialKey", { fg = palette.fg_darker })
hl("SpellBad", { sp = palette.error, undercurl = true })
hl("SpellCap", { sp = palette.warning, undercurl = true })
hl("SpellLocal", { sp = palette.info, undercurl = true })
hl("SpellRare", { sp = palette.hint, undercurl = true })
hl("StatusLine", { fg = palette.fg, bg = palette.bg_light })
hl("StatusLineNC", { fg = palette.fg_darker, bg = palette.bg_light })
hl("TabLine", { fg = palette.fg_dark, bg = palette.bg_light })
hl("TabLineFill", { bg = palette.bg_light })
hl("TabLineSel", { fg = palette.fg, bg = palette.bg })
hl("Title", { fg = palette.blue, bold = true })
hl("Visual", { bg = palette.visual })
hl("VisualNOS", { link = "Visual" })
hl("WarningMsg", { fg = palette.warning, bold = true })
hl("Whitespace", { fg = palette.fg_darker })
hl("WildMenu", { link = "PmenuSel" })
hl("WinBar", { fg = palette.fg, bold = true })
hl("WinBarNC", { fg = palette.fg_dark })

-- Syntax
hl("Comment", { fg = palette.fg_darker, italic = true })

hl("Constant", { fg = palette.orange })
hl("String", { fg = palette.green })
hl("Character", { link = "String" })
hl("Number", { fg = palette.purple })
hl("Boolean", { fg = palette.orange, bold = true })
hl("Float", { link = "Number" })

hl("Identifier", { fg = palette.fg })
hl("Function", { fg = palette.blue })

hl("Statement", { fg = palette.purple, bold = true })
hl("Conditional", { link = "Statement" })
hl("Repeat", { link = "Statement" })
hl("Label", { link = "Statement" })
hl("Operator", { fg = palette.red })
hl("Keyword", { link = "Statement" })
hl("Exception", { link = "Statement" })

hl("PreProc", { fg = palette.red })
hl("Include", { link = "PreProc" })
hl("Define", { link = "PreProc" })
hl("Macro", { link = "PreProc" })
hl("PreCondit", { link = "PreProc" })

hl("Type", { fg = palette.cyan })
hl("StorageClass", { link = "Type" })
hl("Structure", { link = "Type" })
hl("Typedef", { link = "Type" })

hl("Special", { fg = palette.red })
hl("SpecialChar", { link = "Special" })
hl("Tag", { link = "Special" })
hl("Delimiter", { fg = palette.fg_dark })
hl("SpecialComment", { fg = palette.fg_darker, bold = true })
hl("Debug", { link = "Special" })

hl("Underlined", { underline = true })
hl("Ignore", { fg = palette.bg })
hl("Error", { fg = palette.error, bold = true })
hl("Todo", { fg = palette.bg, bg = palette.yellow, bold = true })

-- Treesitter
hl("@variable", { fg = palette.fg })
hl("@variable.builtin", { fg = palette.red })
hl("@variable.parameter", { fg = palette.fg })
hl("@variable.member", { fg = palette.fg })

hl("@constant", { link = "Constant" })
hl("@constant.builtin", { link = "Constant" })
hl("@constant.macro", { link = "Constant" })

hl("@module", { fg = palette.cyan })
hl("@label", { fg = palette.blue })

hl("@string", { link = "String" })
hl("@string.regexp", { fg = palette.orange })
hl("@string.escape", { fg = palette.red })
hl("@string.special", { link = "SpecialChar" })

hl("@character", { link = "Character" })
hl("@character.special", { link = "SpecialChar" })

hl("@number", { link = "Number" })
hl("@boolean", { link = "Boolean" })
hl("@number.float", { link = "Float" })

hl("@function", { link = "Function" })
hl("@function.builtin", { link = "Function" })
hl("@function.call", { link = "Function" })
hl("@function.macro", { link = "Macro" })
hl("@function.method", { link = "Function" })
hl("@function.method.call", { link = "Function" })

hl("@constructor", { fg = palette.cyan })
hl("@operator", { link = "Operator" })

hl("@keyword", { link = "Keyword" })
hl("@keyword.function", { link = "Keyword" })
hl("@keyword.operator", { link = "Keyword" })
hl("@keyword.return", { link = "Keyword" })
hl("@keyword.conditional", { link = "Conditional" })
hl("@keyword.repeat", { link = "Repeat" })
hl("@keyword.exception", { link = "Exception" })

hl("@type", { link = "Type" })
hl("@type.builtin", { fg = palette.cyan, italic = true })
hl("@type.definition", { link = "Type" })

hl("@attribute", { fg = palette.purple })
hl("@property", { fg = palette.fg })

hl("@comment", { link = "Comment" })
hl("@comment.documentation", { fg = palette.fg_dark, italic = true })

hl("@punctuation", { fg = palette.fg_dark })
hl("@punctuation.delimiter", { link = "Delimiter" })
hl("@punctuation.bracket", { fg = palette.fg_dark })
hl("@punctuation.special", { fg = palette.red })

hl("@markup.strong", { bold = true })
hl("@markup.italic", { italic = true })
hl("@markup.strikethrough", { strikethrough = true })
hl("@markup.underline", { underline = true })

hl("@markup.heading", { fg = palette.blue, bold = true })
hl("@markup.heading.1", { fg = palette.red, bold = true })
hl("@markup.heading.2", { fg = palette.orange, bold = true })
hl("@markup.heading.3", { fg = palette.yellow, bold = true })
hl("@markup.heading.4", { fg = palette.green, bold = true })
hl("@markup.heading.5", { fg = palette.cyan, bold = true })
hl("@markup.heading.6", { fg = palette.purple, bold = true })

hl("@markup.quote", { fg = palette.fg_dark, italic = true })
hl("@markup.math", { fg = palette.blue })

hl("@markup.link", { fg = palette.cyan, underline = true })
hl("@markup.link.label", { fg = palette.blue })
hl("@markup.link.url", { fg = palette.cyan, underline = true })

hl("@markup.raw", { fg = palette.green })
hl("@markup.raw.block", { fg = palette.fg })

hl("@markup.list", { fg = palette.red })
hl("@markup.list.checked", { fg = palette.green })
hl("@markup.list.unchecked", { fg = palette.fg_darker })

hl("@diff.plus", { fg = palette.diff_add })
hl("@diff.minus", { fg = palette.diff_delete })
hl("@diff.delta", { fg = palette.diff_change })

hl("@tag", { fg = palette.red })
hl("@tag.attribute", { fg = palette.yellow })
hl("@tag.delimiter", { fg = palette.fg_dark })

-- LSP Semantic Tokens
hl("@lsp.type.class", { link = "Type" })
hl("@lsp.type.decorator", { link = "@attribute" })
hl("@lsp.type.enum", { link = "Type" })
hl("@lsp.type.enumMember", { link = "Constant" })
hl("@lsp.type.function", { link = "Function" })
hl("@lsp.type.interface", { link = "Type" })
hl("@lsp.type.macro", { link = "Macro" })
hl("@lsp.type.method", { link = "Function" })
hl("@lsp.type.namespace", { link = "@module" })
hl("@lsp.type.parameter", { link = "@variable.parameter" })
hl("@lsp.type.property", { link = "@property" })
hl("@lsp.type.struct", { link = "Type" })
hl("@lsp.type.type", { link = "Type" })
hl("@lsp.type.typeParameter", { link = "Type" })
hl("@lsp.type.variable", { link = "@variable" })

hl("@lsp.mod.readonly", { italic = true })
hl("@lsp.mod.deprecated", { strikethrough = true })

-- Diagnostics
hl("DiagnosticError", { fg = palette.error })
hl("DiagnosticWarn", { fg = palette.warning })
hl("DiagnosticInfo", { fg = palette.info })
hl("DiagnosticHint", { fg = palette.hint })

hl("DiagnosticUnderlineError", { sp = palette.error, undercurl = true })
hl("DiagnosticUnderlineWarn", { sp = palette.warning, undercurl = true })
hl("DiagnosticUnderlineInfo", { sp = palette.info, undercurl = true })
hl("DiagnosticUnderlineHint", { sp = palette.hint, undercurl = true })

hl("DiagnosticVirtualTextError", { fg = palette.error, bg = palette.bg_light })
hl("DiagnosticVirtualTextWarn", { fg = palette.warning, bg = palette.bg_light })
hl("DiagnosticVirtualTextInfo", { fg = palette.info, bg = palette.bg_light })
hl("DiagnosticVirtualTextHint", { fg = palette.hint, bg = palette.bg_light })

hl("DiagnosticSignError", { link = "DiagnosticError" })
hl("DiagnosticSignWarn", { link = "DiagnosticWarn" })
hl("DiagnosticSignInfo", { link = "DiagnosticInfo" })
hl("DiagnosticSignHint", { link = "DiagnosticHint" })

hl("DiagnosticFloatingError", { link = "DiagnosticError" })
hl("DiagnosticFloatingWarn", { link = "DiagnosticWarn" })
hl("DiagnosticFloatingInfo", { link = "DiagnosticInfo" })
hl("DiagnosticFloatingHint", { link = "DiagnosticHint" })

-- LSP
hl("LspReferenceText", { bg = palette.bg_lighter })
hl("LspReferenceRead", { bg = palette.bg_lighter })
hl("LspReferenceWrite", { bg = palette.bg_lighter })

hl("LspSignatureActiveParameter", { fg = palette.orange, bold = true })

hl("LspCodeLens", { fg = palette.fg_darker, italic = true })
hl("LspCodeLensSeparator", { fg = palette.fg_darker })

hl("LspInlayHint", { fg = palette.fg_darker, bg = palette.bg_light })

-- Git
hl("gitcommitSummary", { fg = palette.fg })
hl("gitcommitComment", { link = "Comment" })
hl("gitcommitUntracked", { link = "Comment" })
hl("gitcommitDiscarded", { link = "Comment" })
hl("gitcommitSelected", { link = "Comment" })
hl("gitcommitUnmerged", { fg = palette.green, bold = true })
hl("gitcommitOnBranch", { fg = palette.fg_dark, bold = true })
hl("gitcommitBranch", { fg = palette.purple, bold = true })
hl("gitcommitNoBranch", { link = "gitcommitBranch" })
hl("gitcommitDiscardedType", { fg = palette.red })
hl("gitcommitSelectedType", { fg = palette.green })
hl("gitcommitUnmergedType", { fg = palette.yellow })
hl("gitcommitDiscardedFile", { fg = palette.red, bold = true })
hl("gitcommitSelectedFile", { fg = palette.green, bold = true })
hl("gitcommitUnmergedFile", { fg = palette.yellow, bold = true })

-- Terminal
vim.g.terminal_color_0 = palette.bg
vim.g.terminal_color_1 = palette.red
vim.g.terminal_color_2 = palette.green
vim.g.terminal_color_3 = palette.yellow
vim.g.terminal_color_4 = palette.blue
vim.g.terminal_color_5 = palette.purple
vim.g.terminal_color_6 = palette.cyan
vim.g.terminal_color_7 = palette.fg
vim.g.terminal_color_8 = palette.fg_darker
vim.g.terminal_color_9 = palette.red
vim.g.terminal_color_10 = palette.green
vim.g.terminal_color_11 = palette.yellow
vim.g.terminal_color_12 = palette.blue
vim.g.terminal_color_13 = palette.purple
vim.g.terminal_color_14 = palette.cyan
vim.g.terminal_color_15 = palette.fg
