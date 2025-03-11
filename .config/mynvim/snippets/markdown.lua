local helpers = require('luasnip-helper-funcs')
local get_visual = helpers.get_visual

return {
	s({ trig = "(%f[%w]ii)", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta("*<>*",
			{
				d(1, get_visual),
			}
		)
	),
	s({ trig = "(%f[%w]bb)", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta("**<>**",
			{
				d(1, get_visual),
			}
		)
	),
	s({ trig = "(%f[%w]icd)", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta("`<>`",
			{
				d(1, get_visual),
			}
		)
	),
	s({ trig = "(%f[%w]cdb)", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta(
			[[
		```<>
		<>
		```
		]],
			{
				i(1, "type"), -- Input node for the code block type
				d(2, get_visual), -- Selected text or manual input
			}
		)
	),
	s({ trig = "cdf", wordTrig = true }, t("champ de force")
	),
	s("trig", {
		i(1), t "text", i(2), t "text again", i(3)
	}),

}
