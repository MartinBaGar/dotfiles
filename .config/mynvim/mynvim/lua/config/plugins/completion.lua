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
						-- score_offset = function(ft)
						-- 	return ft == 'markdown' and 10 or ft == 'tex' and 50
						-- end,
					},
					buffer = {
						name = 'buffer',
						-- score_offset = function(ft)
						-- 	return ft == 'markdown' and 30 or ft == 'tex' and 40
						-- end,
					},
					lsp = {
						name = 'lsp',
						-- score_offset = function(ft)
						-- 	return ft == 'markdown' and 0 or ft == 'tex' and 30
						-- end,
					},
					path = {
						name = 'path',
						-- score_offset = function(ft)
						-- 	return ft == 'python' and 10 or ft == 'markdown' and 50 or ft == 'tex' and 100
						-- end,
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
						-- score_offset = function(ft)
						-- 	return ft == 'markdown' and 30 or ft == 'tex' and 40
						-- end,
					},
					calc = {
						name = "calc",
						module = "blink.compat.source",
					},
					digraphs = {
						name = 'digraphs',
						module = 'blink.compat.source',
						-- score_offset = -3,
						opts = {
							cache_digraphs_on_start = true,
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
