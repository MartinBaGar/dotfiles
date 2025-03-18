return {
	{
		"lervag/vimtex",
		enabled = true,
		lazy = false, -- we don't want to lazy load VimTeX
		-- tag = "v2.15", -- uncomment to pin to a specific release
		init = function()
			-- VimTeX configuration goes here, e.g.
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_imaps_enabled = 0
			vim.g.vimtex_complete_enabled = 0
			vim.g.vimtex_syntax_enabled = 0
			vim.g.vimtex_format_enabled = 0
			vim.g.vimtex_indent_enabled = 0
			vim.g.vimtex_compiler_latexmk_engines = { _ = '-xelatex' }
		end
	},
}
