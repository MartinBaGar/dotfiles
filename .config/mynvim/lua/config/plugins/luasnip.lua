---@diagnostic disable: assign-type-mismatch
return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		version = "v2.*",
		build = "make install_jsregexp",
		config = function()
			local ls = require("luasnip")
			ls.config.set_config({
				history = true,
				updateevents = "TextChanged,TextChangedI",
				enable_autosnippets = true,
				store_selection_keys = "<Tab>",
			})

			-- Keymaps
			vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<M-l>", function() ls.jump(1) end, { silent = true, noremap = false })
			vim.keymap.set({ "i", "s" }, "<M-j>", function() ls.jump(-1) end, { silent = true, noremap = false })
			vim.keymap.set({ "i", "s" }, "<C-E>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, { silent = true })

			-- Load snippets
			require("luasnip.loaders.from_vscode").lazy_load({
			}
			)
			require("luasnip.loaders.from_lua").load({
				paths = "~/.config/mynvim/snippets/",
			})
			ls.filetype_extend("quarto", { "markdown" })
		end,
	},
}
