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
	s({ trig = "cdf", wordTrig = true }, t("champ de force")
	),
	s("trig", {
		i(1), t "text", i(2), t "text again", i(3)
	}),

}
