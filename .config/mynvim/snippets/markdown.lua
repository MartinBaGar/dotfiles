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
}
