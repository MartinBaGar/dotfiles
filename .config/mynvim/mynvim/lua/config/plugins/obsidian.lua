return {
	"epwalsh/obsidian.nvim",
	enabled = true,
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = false,
	ft = { "markdown", "quarto" },
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
	--   -- refer to `:h file-pattern` for more examples
	--   "BufReadPre path/to/my-vault/*.md",
	--   "BufNewFile path/to/my-vault/*.md",
	-- },
	dependencies = {
		"nvim-lua/plenary.nvim",

	},
	opts = {
		workspaces = {
			-- {
			-- 	name = "personal",
			-- 	path = "~/docs",
			-- },
			{
				name = "work",
				path = "~/Documents/vaults/labo/",
			},
			{
				name = "no-vault",
				path = function()
					-- alternatively use the CWD:
					-- return assert(vim.fn.getcwd())
					return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
				end,
				overrides = {
					notes_subdir = vim.NIL, -- have to use 'vim.NIL' instead of 'nil'
					new_notes_location = "current_dir",
					templates = {
						folder = vim.NIL,
					},
					disable_frontmatter = true,
					daily_notes = {
						folder = vim.NIL,
					}
				},
			},
		},
		daily_notes = {
			-- Optional, if you keep daily notes in a separate directory.
			folder = "dailies",
		},
		-- Optional, customize how note IDs are generated given an optional title.
		---@param title string|?
		---@return string
		note_id_func = function(title)
			-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
			-- In this case a note with the title 'My new note' will be given an ID that looks
			-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
			local suffix = ""
			if title ~= nil then
				-- If title is given, transform it into valid file name.
				-- I modified because i prefer underscore
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				-- suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				-- If title is nil, just add 4 random uppercase letters to the suffix.
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			-- I modified to just have the title as name
			-- return tostring(os.time()) .. "-" .. suffix
			return suffix
		end,

		-- Optional, customize how note file names are generated given the ID, target directory, and title.
		---@param spec { id: string, dir: obsidian.Path, title: string|? }
		---@return string|obsidian.Path The full path to the new note.
		note_path_func = function(spec)
			-- This is equivalent to the default behavior.
			local path = spec.dir / tostring(spec.id)
			return path:with_suffix(".md")
		end,

		-- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
		ui = {
			enable = false, -- set to false to disable all additional syntax features
		},
	},
}
