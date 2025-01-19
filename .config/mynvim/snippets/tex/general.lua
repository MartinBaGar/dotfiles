local helpers = require('luasnip-helper-funcs')
local get_visual = helpers.get_visual

return {
	-- Bold text snippet
	s(
		{ trig = "tbf", dscr = "Expands 'tbf' into LaTeX's \\textbf{} command.", snippetType = "autosnippet" },
		fmta(
			"\\textbf{<>}",
			{ d(1, get_visual) }
		)
	),
	-- Italic text snippet with visual selection support
	s(
		{ trig = "tii", dscr = "Expands 'tii' into LaTeX's \\textit{} command.", snippetType = "autosnippet" },
		fmta(
			"\\textit{<>}",
			{ d(1, get_visual) }
		)
	),
	s(
		{ trig = "([^%w])foo", regTrig = true, wordTrig = false },
		t("bar")
	),
	s({ trig = "([^%a])mm", wordTrig = false, regTrig = true },
		fmta(
			"<>$<>$",
			{
				f(function(_, snip) return snip.captures[1] end),
				d(1, get_visual),
			}
		)
	),
}
