return {
	{
		'saghen/blink.cmp',
		dependencies = {
			'L3MON4D3/LuaSnip',
			version = 'v2.*',
			{ "saghen/blink.compat", opts = {}, version = "*" },
			{ "f3fora/cmp-spell" },
		},
		version = '*',
		opts = {
			snippets = { preset = 'luasnip' },
			keymap = { preset = 'default' },
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = 'mono'
			},
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
				per_filetype = {
					markdown = { 'lsp', 'path', 'snippets', 'buffer', 'obsidian', 'obsidian_new', 'obsidian_tags', 'spell' },
					-- latex = { 'lsp', 'path', 'snippets', 'buffer', 'spell' }
					tex = { 'lsp', 'path', 'snippets', 'buffer', 'spell' }
				},
				providers = {
					snippets = {
						name = 'snippets',
						score_offset = 50,
					},
					buffer = {
						name = 'buffer',
						score_offset = 40,
					},
					lsp = {
						name = 'lsp',
						score_offset = 30,
					},
					path = {
						name = 'path',
						score_offset = 10,
					},
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
				},
			},
			completion = {
				menu = {
					-- Don't automatically show the completion menu
					auto_show = true,
					-- nvim-cmp style menu
					draw = {
						treesitter = { 'lsp' },
						columns = {
							{ "label",     "label_description", gap = 1 },
							{ "kind_icon", "kind" },
						},
					}
				},
				documentation = {
					auto_show = true,
				},
				ghost_text = { enabled = true }
			}
		},
		opts_extend = { "sources.default" }
	},
}
