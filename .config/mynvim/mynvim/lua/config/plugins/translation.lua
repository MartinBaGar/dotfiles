return {
	"potamides/pantran.nvim",
	config = function()
		local pantran = require("pantran")
		pantran.setup({
			-- Default engine setting
			default_engine = "deepl",
			-- Configuration for individual engines
			engines = {
				deepl = {
					default_source = vim.NIL,
					default_target = "en",
					auth_key = "8e5f7835-fc8c-49fa-96e9-7d6e35455a2a:fx",
					free_api = true
				},
			},
			-- Controls configuration
			controls = {
				mappings = {
					edit = {
						n = {
							-- Additional mappings for normal mode in the translation window
							["j"] = "gj",
							["k"] = "gk"
						},
						i = {
							-- Mappings for insert mode
							["<C-y>"] = false,
							["<C-a>"] = require("pantran.ui.actions").yank_close_translation,
						}
					},
					select = {
						n = {
							-- ["q"] = require("pantran.ui.actions").close,
							-- ["<CR>"] = require("pantran.ui.actions").select_and_translate,
						}
					}
				}
			}
		})
		local opts = { noremap = true, silent = true, expr = true }

		-- Translate using motions (Visual mode) without replacement
		vim.keymap.set("v", "<leader>tf", function()
			return pantran.motion_translate { engine = "deepl", source = nil, target = "FR" }
		end, opts)
		vim.keymap.set("v", "<leader>te", function()
			return pantran.motion_translate { engine = "deepl", source = nil, target = "EN" }
		end, opts)

		-- Translate using motions (Visual mode) and replace text
		vim.keymap.set("v", "<leader>trf", function()
			return pantran.motion_translate { mode = "replace", engine = "deepl", source = "EN", target = "FR" }
		end, opts)
		vim.keymap.set("v", "<leader>tre", function()
			return pantran.motion_translate { mode = "replace", engine = "deepl", source = "FR", target = "EN" }
		end, opts)

		vim.keymap.set("n", "<leader>to", ":Pantran engine=google<CR>", { noremap = true, silent = true })
	end,
}
