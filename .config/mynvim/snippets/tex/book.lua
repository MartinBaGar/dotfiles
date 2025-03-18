local helpers = require('luasnip-helper-funcs')
local get_visual = helpers.get_visual

return {
	-- Bold text snippet
	s(
		{ trig = "chapter", dscr = "Expands 'chapter' into LaTeX's \\chapter{} command.", snippetType = "autosnippet" },
		fmta(
			"\\chapter{<>}",
			{ d(1, get_visual) }
		)
	),
}
