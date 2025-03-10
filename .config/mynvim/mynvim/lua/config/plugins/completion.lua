return {
	{
		'saghen/blink.cmp',
		dependencies = {
			'L3MON4D3/LuaSnip',
			version = 'v2.*',
			{
				'saghen/blink.compat',
				version = '*',
				lazy = true,
				opts = {},
			},
			{ "f3fora/cmp-spell" },
			{ "hrsh7th/cmp-calc" },
			{ 'dmitmel/cmp-digraphs' },
		},
		version = '*',
		opts = {
			snippets = { preset = 'luasnip' },
			keymap = {
				preset = 'default',
				['<A-1>'] = { function(cmp) cmp.accept({ index = 1 }) end },
				['<A-2>'] = { function(cmp) cmp.accept({ index = 2 }) end },
				['<A-3>'] = { function(cmp) cmp.accept({ index = 3 }) end },
				['<A-4>'] = { function(cmp) cmp.accept({ index = 4 }) end },
				['<A-5>'] = { function(cmp) cmp.accept({ index = 5 }) end },
				['<A-6>'] = { function(cmp) cmp.accept({ index = 6 }) end },
				['<A-7>'] = { function(cmp) cmp.accept({ index = 7 }) end },
				['<A-8>'] = { function(cmp) cmp.accept({ index = 8 }) end },
				['<A-9>'] = { function(cmp) cmp.accept({ index = 9 }) end },
				['<A-0>'] = { function(cmp) cmp.accept({ index = 10 }) end },
			},
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = 'mono'
			},
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer', 'calc' },
				per_filetype = {
					markdown = { 'lsp', 'path', 'snippets', 'buffer', 'obsidian', 'obsidian_new', 'obsidian_tags', 'spell', 'calc', 'omni' },
					tex = { 'lsp', 'path', 'snippets', 'buffer', 'spell' }
				},
				providers = {
					obsidian = {
						name = "obsidian",
						module = "blink.compat.source",
					},
					obsidian_new = {
						name = "obsidian_new",
						module = "blink.compat.source",
					},
					obsidian_tags = {
						name = "obsidian_tags",
						module = "blink.compat.source",
					},
					spell = {
						name = "spell",
						module = "blink.compat.source",
					},
					calc = {
						name = "calc",
						module = "blink.compat.source",
					},
				},
			},
			completion = {
				menu = {
					draw = {
						columns = { { 'item_idx' }, { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
						components = {
							item_idx = {
								text = function(ctx) return ctx.idx == 10 and '0' or ctx.idx >= 10 and ' ' or tostring(ctx.idx) end,
								highlight = 'BlinkCmpItemIdx' -- optional, only if you want to change its color
							}
						}
					}
				},
				documentation = {
					auto_show = false,
				},
				ghost_text = { enabled = false }
			},
		},
		opts_extend = { "sources.default" }
	},
}
