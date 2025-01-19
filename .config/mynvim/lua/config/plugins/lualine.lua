return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require('lualine').setup({
			sections = {
				lualine_c = {
					{
						function()
							if vim.wo.spell then
								local lang = table.concat(vim.opt.spelllang:get(), ",")
								return "Spell: " .. lang
							else
								return ""
							end
						end,
						cond = function()
							return vim.wo.spell -- Only display if spell checking is enabled
						end,
					},
				},
			},
		})
	end
}
