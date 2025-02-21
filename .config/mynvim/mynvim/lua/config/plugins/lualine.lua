return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require('lualine').setup {
			options = {
				theme = 'auto',
				section_separators = '',
				component_separators = '',
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { 'branch' },
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
					{
						'filename',
						path = 4,            -- Display filename and parent directory
						file_status = true,  -- Show file status (modified, readonly)
						symbols = {
							modified = '[+]',  -- Text to show when the file is modified
							readonly = '[-]',  -- Text to show for readonly files
							unnamed = '[No Name]', -- Text for unnamed buffers
						},
					},
				},
				lualine_x = { 'filetype' },
				lualine_y = { 'progress' },
				lualine_z = { 'location' }
			},
			inactive_sections = {
				lualine_c = {
					{
						'filename',
						path = 4, -- Display filename and parent directory
						file_status = true,
						symbols = {
							modified = '[+]',
							readonly = '[-]',
							unnamed = '[No Name]',
						},
					},
				},
				lualine_x = { 'location' }
			},
		}
	end
}
