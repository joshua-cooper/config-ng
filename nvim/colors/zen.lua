vim.cmd.highlight("clear")

if vim.fn.exists("syntax_on") == 1 then
	vim.cmd("syntax reset")
end

vim.g.colors_name = "zen"

local dark = {
	-- Base

	bg = "#1c1917",
	bg_light = "#282727",
	bg_lighter = "#393836",
	fg = "#c5c9c5",
	fg_dark = "#a6a69c",
	fg_darker = "#737c73",

	-- UI

	border = "#625e5a",
	cursor_line = "#282727",
	visual = "#223249",
	pmenu = "#464442",
	float = "#464442",

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

	-- Colors

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

local light = {
	-- Base

	bg = "#faf9f8",
	bg_light = "#f0edec",
	bg_lighter = "#e8e5e3",
	fg = "#545464",
	fg_dark = "#43436c",
	fg_darker = "#8a8980",

	-- UI

	border = "#d0d0d0",
	cursor_line = "#f5f5f5",
	visual = "#c9cbd1",
	pmenu = "#e5e2e0",
	float = "#e5e2e0",

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

	-- Colors

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

local p = vim.o.background == "dark" and dark or light

local function hl(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

-- Base

hl("Normal", { fg = p.fg, bg = p.bg })
hl("NormalFloat", { fg = p.fg, bg = p.float })
hl("FloatBorder", { fg = p.border, bg = p.float })
hl("FloatTitle", { fg = p.fg, bg = p.float, bold = true })
hl("ColorColumn", { bg = p.bg_light })
hl("Conceal", { fg = p.fg_darker })
hl("Cursor", { fg = p.bg, bg = p.fg })
hl("lCursor", { link = "Cursor" })
hl("CursorIM", { link = "Cursor" })
hl("CursorLine", { bg = p.cursor_line })
hl("CursorColumn", { link = "CursorLine" })
hl("Directory", { fg = p.blue })
hl("DiffAdd", { bg = p.diff_add, fg = p.bg })
hl("DiffChange", { bg = p.diff_change, fg = p.bg })
hl("DiffDelete", { bg = p.diff_delete, fg = p.bg })
hl("DiffText", { bg = p.diff_text, fg = p.fg })
hl("EndOfBuffer", { fg = p.bg })
hl("ErrorMsg", { fg = p.error, bold = true })
hl("VertSplit", { fg = p.border })
hl("WinSeparator", { link = "VertSplit" })
hl("Folded", { fg = p.fg_darker, bg = p.bg_light })
hl("FoldColumn", { fg = p.fg_darker })
hl("SignColumn", { fg = p.fg_darker })
hl("IncSearch", { fg = p.bg, bg = p.orange, bold = true })
hl("Substitute", { link = "IncSearch" })
hl("LineNr", { fg = p.fg_darker })
hl("CursorLineNr", { fg = p.fg_dark, bold = true })
hl("MatchParen", { fg = p.orange, bold = true })
hl("ModeMsg", { fg = p.fg, bold = true })
hl("MsgArea", { fg = p.fg })
hl("MoreMsg", { fg = p.green, bold = true })
hl("NonText", { fg = p.fg_darker })
hl("Pmenu", { fg = p.fg, bg = p.pmenu })
hl("PmenuSel", { fg = p.bg, bg = p.blue })
hl("PmenuSbar", { bg = p.bg_light })
hl("PmenuThumb", { bg = p.fg_darker })
hl("Question", { fg = p.green, bold = true })
hl("QuickFixLine", { fg = p.bg, bg = p.blue })
hl("Search", { fg = p.bg, bg = p.yellow })
hl("SpecialKey", { fg = p.fg_darker })
hl("SpellBad", { sp = p.error, undercurl = true })
hl("SpellCap", { sp = p.warning, undercurl = true })
hl("SpellLocal", { sp = p.info, undercurl = true })
hl("SpellRare", { sp = p.hint, undercurl = true })
hl("StatusLine", { fg = p.fg, bg = p.bg_light })
hl("StatusLineNC", { fg = p.fg_darker, bg = p.bg_light })
hl("TabLine", { fg = p.fg_dark, bg = p.bg_light })
hl("TabLineFill", { bg = p.bg_light })
hl("TabLineSel", { fg = p.fg, bg = p.bg })
hl("Title", { fg = p.blue, bold = true })
hl("Visual", { bg = p.visual })
hl("VisualNOS", { link = "Visual" })
hl("WarningMsg", { fg = p.warning, bold = true })
hl("Whitespace", { fg = p.fg_darker })
hl("WildMenu", { link = "PmenuSel" })
hl("WinBar", { fg = p.fg, bold = true })
hl("WinBarNC", { fg = p.fg_dark })

-- Syntax

hl("Comment", { fg = p.fg_darker, italic = true })

hl("Constant", { fg = p.orange })
hl("String", { fg = p.green })
hl("Character", { link = "String" })
hl("Number", { fg = p.purple })
hl("Boolean", { fg = p.orange, bold = true })
hl("Float", { link = "Number" })

hl("Identifier", { fg = p.fg })
hl("Function", { fg = p.blue })

hl("Statement", { fg = p.purple, bold = true })
hl("Conditional", { link = "Statement" })
hl("Repeat", { link = "Statement" })
hl("Label", { link = "Statement" })
hl("Operator", { fg = p.red })
hl("Keyword", { link = "Statement" })
hl("Exception", { link = "Statement" })

hl("PreProc", { fg = p.red })
hl("Include", { link = "PreProc" })
hl("Define", { link = "PreProc" })
hl("Macro", { link = "PreProc" })
hl("PreCondit", { link = "PreProc" })

hl("Type", { fg = p.cyan })
hl("StorageClass", { link = "Type" })
hl("Structure", { link = "Type" })
hl("Typedef", { link = "Type" })

hl("Special", { fg = p.red })
hl("SpecialChar", { link = "Special" })
hl("Tag", { link = "Special" })
hl("Delimiter", { fg = p.fg_dark })
hl("SpecialComment", { fg = p.fg_darker, bold = true })
hl("Debug", { link = "Special" })

hl("Underlined", { underline = true })
hl("Ignore", { fg = p.bg })
hl("Error", { fg = p.error, bold = true })
hl("Todo", { fg = p.bg, bg = p.yellow, bold = true })

-- Treesitter

hl("@variable", { fg = p.fg })
hl("@variable.builtin", { fg = p.red })
hl("@variable.parameter", { fg = p.fg })
hl("@variable.member", { fg = p.fg })

hl("@constant", { link = "Constant" })
hl("@constant.builtin", { link = "Constant" })
hl("@constant.macro", { link = "Constant" })

hl("@module", { fg = p.cyan })
hl("@label", { fg = p.blue })

hl("@string", { link = "String" })
hl("@string.regexp", { fg = p.orange })
hl("@string.escape", { fg = p.red })
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

hl("@constructor", { fg = p.cyan })
hl("@operator", { link = "Operator" })

hl("@keyword", { link = "Keyword" })
hl("@keyword.function", { link = "Keyword" })
hl("@keyword.operator", { link = "Keyword" })
hl("@keyword.return", { link = "Keyword" })
hl("@keyword.conditional", { link = "Conditional" })
hl("@keyword.repeat", { link = "Repeat" })
hl("@keyword.exception", { link = "Exception" })

hl("@type", { link = "Type" })
hl("@type.builtin", { fg = p.cyan, italic = true })
hl("@type.definition", { link = "Type" })

hl("@attribute", { fg = p.purple })
hl("@property", { fg = p.fg })

hl("@comment", { link = "Comment" })
hl("@comment.documentation", { fg = p.fg_dark, italic = true })

hl("@punctuation", { fg = p.fg_dark })
hl("@punctuation.delimiter", { link = "Delimiter" })
hl("@punctuation.bracket", { fg = p.fg_dark })
hl("@punctuation.special", { fg = p.red })

hl("@markup.strong", { bold = true })
hl("@markup.italic", { italic = true })
hl("@markup.strikethrough", { strikethrough = true })
hl("@markup.underline", { underline = true })

hl("@markup.heading", { fg = p.blue, bold = true })
hl("@markup.heading.1", { fg = p.red, bold = true })
hl("@markup.heading.2", { fg = p.orange, bold = true })
hl("@markup.heading.3", { fg = p.yellow, bold = true })
hl("@markup.heading.4", { fg = p.green, bold = true })
hl("@markup.heading.5", { fg = p.cyan, bold = true })
hl("@markup.heading.6", { fg = p.purple, bold = true })

hl("@markup.quote", { fg = p.fg_dark, italic = true })
hl("@markup.math", { fg = p.blue })

hl("@markup.link", { fg = p.cyan, underline = true })
hl("@markup.link.label", { fg = p.blue })
hl("@markup.link.url", { fg = p.cyan, underline = true })

hl("@markup.raw", { fg = p.green })
hl("@markup.raw.block", { fg = p.fg })

hl("@markup.list", { fg = p.red })
hl("@markup.list.checked", { fg = p.green })
hl("@markup.list.unchecked", { fg = p.fg_darker })

hl("@diff.plus", { fg = p.diff_add })
hl("@diff.minus", { fg = p.diff_delete })
hl("@diff.delta", { fg = p.diff_change })

hl("@tag", { fg = p.red })
hl("@tag.attribute", { fg = p.yellow })
hl("@tag.delimiter", { fg = p.fg_dark })

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

hl("DiagnosticError", { fg = p.error })
hl("DiagnosticWarn", { fg = p.warning })
hl("DiagnosticInfo", { fg = p.info })
hl("DiagnosticHint", { fg = p.hint })

hl("DiagnosticUnderlineError", { sp = p.error, undercurl = true })
hl("DiagnosticUnderlineWarn", { sp = p.warning, undercurl = true })
hl("DiagnosticUnderlineInfo", { sp = p.info, undercurl = true })
hl("DiagnosticUnderlineHint", { sp = p.hint, undercurl = true })

hl("DiagnosticVirtualTextError", { fg = p.error, bg = p.bg_light })
hl("DiagnosticVirtualTextWarn", { fg = p.warning, bg = p.bg_light })
hl("DiagnosticVirtualTextInfo", { fg = p.info, bg = p.bg_light })
hl("DiagnosticVirtualTextHint", { fg = p.hint, bg = p.bg_light })

hl("DiagnosticSignError", { link = "DiagnosticError" })
hl("DiagnosticSignWarn", { link = "DiagnosticWarn" })
hl("DiagnosticSignInfo", { link = "DiagnosticInfo" })
hl("DiagnosticSignHint", { link = "DiagnosticHint" })

hl("DiagnosticFloatingError", { link = "DiagnosticError" })
hl("DiagnosticFloatingWarn", { link = "DiagnosticWarn" })
hl("DiagnosticFloatingInfo", { link = "DiagnosticInfo" })
hl("DiagnosticFloatingHint", { link = "DiagnosticHint" })

-- LSP

hl("LspReferenceText", { bg = p.bg_lighter })
hl("LspReferenceRead", { bg = p.bg_lighter })
hl("LspReferenceWrite", { bg = p.bg_lighter })
hl("LspSignatureActiveParameter", { fg = p.orange, bold = true })
hl("LspCodeLens", { fg = p.fg_darker, italic = true })
hl("LspCodeLensSeparator", { fg = p.fg_darker })
hl("LspInlayHint", { fg = p.fg_darker, bg = p.bg_light })

-- Git

hl("gitcommitSummary", { fg = p.fg })
hl("gitcommitComment", { link = "Comment" })
hl("gitcommitUntracked", { link = "Comment" })
hl("gitcommitDiscarded", { link = "Comment" })
hl("gitcommitSelected", { link = "Comment" })
hl("gitcommitUnmerged", { fg = p.green, bold = true })
hl("gitcommitOnBranch", { fg = p.fg_dark, bold = true })
hl("gitcommitBranch", { fg = p.purple, bold = true })
hl("gitcommitNoBranch", { link = "gitcommitBranch" })
hl("gitcommitDiscardedType", { fg = p.red })
hl("gitcommitSelectedType", { fg = p.green })
hl("gitcommitUnmergedType", { fg = p.yellow })
hl("gitcommitDiscardedFile", { fg = p.red, bold = true })
hl("gitcommitSelectedFile", { fg = p.green, bold = true })
hl("gitcommitUnmergedFile", { fg = p.yellow, bold = true })

-- Whitespace

hl("ZenTrailingWhitespace", { bg = p.bg_light })

-- Terminal colors

vim.g.terminal_color_0 = p.bg
vim.g.terminal_color_1 = p.red
vim.g.terminal_color_2 = p.green
vim.g.terminal_color_3 = p.yellow
vim.g.terminal_color_4 = p.blue
vim.g.terminal_color_5 = p.purple
vim.g.terminal_color_6 = p.cyan
vim.g.terminal_color_7 = p.fg
vim.g.terminal_color_8 = p.fg_darker
vim.g.terminal_color_9 = p.red
vim.g.terminal_color_10 = p.green
vim.g.terminal_color_11 = p.yellow
vim.g.terminal_color_12 = p.blue
vim.g.terminal_color_13 = p.purple
vim.g.terminal_color_14 = p.cyan
vim.g.terminal_color_15 = p.fg
