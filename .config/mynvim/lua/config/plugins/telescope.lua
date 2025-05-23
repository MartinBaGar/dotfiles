return {
	{
		'nvim-telescope/telescope.nvim',
		event = 'VimEnter',
		tag = '0.1.8',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
			{ 'nvim-telescope/telescope-ui-select.nvim' },
			{ 'nvim-telescope/telescope-bibtex.nvim' },
			{ 'nvim-tree/nvim-web-devicons',              enabled = vim.g.have_nerd_font },
		},
		config = function()
			require('telescope').setup {
				pickers = {
					find_files = {
						hidden = true, -- This will show hidden files
						no_ignore = true,
						-- If you want to ignore .git files, add:
						-- file_ignore_patterns = { "^.git/" }
					}
				}, extensions = {
				['ui-select'] = {
					require('telescope.themes').get_dropdown(),
				},
				bibtex = {
					-- Depth for the *.bib file
					depth = 1,
					-- Custom format for citation label
					custom_formats = {},
					-- Format to use for citation label.
					-- Try to match the filetype by default, or use 'plain'
					format = '',
					-- Path to global bibliographies (placed outside of the project)
					global_files = { "~/texmf/bibtex/bib/library.bib" },
					-- Define the search keys to use in the picker
					search_keys = { 'author', 'year', 'title' },
					-- Template for the formatted citation
					citation_format = '{{author}} ({{year}}), {{title}}.',
					-- Only use initials for the authors first name
					citation_trim_firstname = true,
					-- Max number of authors to write in the formatted citation
					-- following authors will be replaced by "et al."
					citation_max_auth = 2,
					-- Context awareness disabled by default
					context = false,
					-- Fallback to global/directory .bib files if context not found
					-- This setting has no effect if context = false
					context_fallback = true,
					-- Wrapping in the preview window is disabled by default
					wrap = false,
					-- user defined mappings
					-- mappings = {
					-- 		i = {
					-- 			["<CR>"] = bibtex_actions.key_append('%s'), -- format is determined by filetype if the user has not set it explictly
					-- 			["<C-e>"] = bibtex_actions.entry_append,
					-- 			["<C-c>"] = bibtex_actions.citation_append('{{author}} ({{year}}), {{title}}.'),
					-- 		}
					-- },
				},
			},
			}
			-- See `:help telescope.builtin`
			local builtin = require 'telescope.builtin'
			vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
			vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
			vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
			vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
			vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
			vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
			vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
			vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
			vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
			vim.keymap.set('n', 'sz', builtin.spell_suggest, { desc = '[ ] Accept first spell suggestion' })

			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set('n', '<leader>/', function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
					winblend = 10,
					previewer = false,
				})
			end, { desc = '[/] Fuzzily search in current buffer' })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set('n', '<leader>s/', function()
				builtin.live_grep {
					grep_open_files = true,
					prompt_title = 'Live Grep in Open Files',
				}
			end, { desc = '[S]earch [/] in Open Files' })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set('n', '<leader>sn', function()
				builtin.find_files { cwd = vim.fn.stdpath 'config' }
			end, { desc = '[S]earch [N]eovim files' })
			require("config.telescope.multigrep").setup()
		end
	}
}
