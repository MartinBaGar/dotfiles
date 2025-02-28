return {
	{
		'saghen/blink.cmp',
		dependencies = {
			'L3MON4D3/LuaSnip',
			version = 'v2.*',
			{ "saghen/blink.compat", opts = {}, version = "*" },
			{ "f3fora/cmp-spell" },
			{ "hrsh7th/cmp-calc" },
			{ 'dmitmel/cmp-digraphs' },
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
				default = { 'lsp', 'path', 'snippets', 'buffer', 'calc' },
				per_filetype = {
					markdown = { 'lsp', 'path', 'snippets', 'buffer', 'obsidian', 'obsidian_new', 'obsidian_tags', 'spell', 'digraphs', 'calc' },
					tex = { 'lsp', 'path', 'snippets', 'buffer', 'spell' }
				},
				providers = {
					snippets = {
						name = 'snippets',
					},
					buffer = {
						name = 'buffer',
					},
					lsp = {
						name = 'lsp',
					},
					path = {
						name = 'path',
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
					calc = {
						name = "calc",
						module = "blink.compat.source",
					},
					digraphs = {
						name = 'digraphs',
						module = 'blink.compat.source',
						opts = {
							cache_digraphs_on_start = true,
							max_item_count = 20,
							trigger_characters = { '*', '.', '@', '+' },
						},
					},
				},
			},
			completion = {
				menu = {
					auto_show = true,
					draw = {
						treesitter = { 'lsp' },
						columns = {
							{ "label",     "label_description", gap = 1 },
							{ "kind_icon", "source_name" },
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
