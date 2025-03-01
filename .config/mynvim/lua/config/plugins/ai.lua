return {
	{
		"monkoose/neocodeium",
		enabled = false,
		event = "VeryLazy",
		config = function()
			local neocodeium = require("neocodeium")
			neocodeium.setup()
			vim.keymap.set("i", "<A-f>", neocodeium.accept)
			-- NeoCodeium Configuration
			require("neocodeium").setup({
				enabled = false,
			})
		end,
	}

}
