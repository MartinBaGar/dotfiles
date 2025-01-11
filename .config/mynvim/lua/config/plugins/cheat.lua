return {
	"dbeniamine/cheat.sh-vim",
	enabled = false,
	config = function()
		-- Load the plugin using lazy.nvim
		require("lazy").setup()
		--
		-- -- Function to print keybindings
		-- local function print_keybindings(mode)
		-- 	local keymaps = vim.api.nvim_get_keymap(mode)
		-- 	print(string.format("Keybindings for mode: %s", mode))
		-- 	for _, keymap in ipairs(keymaps) do
		-- 		print(string.format(
		-- 			"LHS: %s | RHS: %s | Plugin: %s",
		-- 			keymap.lhs, keymap.rhs or "<None>", keymap.desc or "<No Description>"
		-- 		))
		-- 	end
		-- end
		--
		-- -- Print Normal Mode Keybindings
		-- print_keybindings("n")
	end,
}
