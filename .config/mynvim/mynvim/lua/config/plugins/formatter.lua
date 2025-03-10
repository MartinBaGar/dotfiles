return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			yaml = { "yamlls" },
			markdown = { "markdownlint" },
		},
		-- Set default options
		default_format_opts = {
			lsp_format = "fallback",
		},
		-- Set up format-on-save (disabled)
		format_on_save = { timeout_ms = 500 },
		-- Customize formatters
		formatters = {
			shfmt = {
				prepend_args = { "-i", "2" },
			},
			markdownlint = {
				prepend_args = {
					"--config", vim.fn.expand("~/.markdownlint.json")
				}
			}
		},
	},
	init = function()
		-- Set formatexpr for better formatting behavior
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

		-- Define a global `:Format` command for manual formatting with range
		vim.api.nvim_create_user_command('Format', function(args)
			local range = nil
			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					start = { args.line1, 0 },
					['end'] = { args.line2, end_line:len() },
				}
			end
			require('conform').format({
				async = true,
				lsp_fallback = true,
				range = range
			})
		end, { range = true, desc = "Manually format buffer with range" })
	end,
}
