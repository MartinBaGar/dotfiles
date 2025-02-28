return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		{
			"folke/lazydev.nvim",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	config = function()
		require("mason").setup()
		local capabilities = require('blink.cmp').get_lsp_capabilities()
		local mason_lspconfig = require("mason-lspconfig")
		mason_lspconfig.setup({
			ensure_installed = { "lua_ls", "ltex" },
		})

		-- Existing LSP configurations
		require("lspconfig").pylsp.setup({ capabilities = capabilities })
		require("lspconfig").lua_ls.setup({ capabilities = capabilities })
		require("lspconfig").texlab.setup({ capabilities = capabilities })
		require("lspconfig").yamlls.setup({ capabilities = capabilities })
		-- require("lspconfig").markdownlint.setup({ capabilities = capabilities })
		require("lspconfig").ltex.setup({
			autostart = false,
			settings = {
				ltex = {
					language = "fr",
				},
				-- dictionary = {
				-- 	["en"] = { "neovim", "lua" }
				-- },
			}
		})
	end,
}
