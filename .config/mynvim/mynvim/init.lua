require("config.lazy")

vim.wo.spell = false
-- Spell configuration
vim.opt.spelllang = "fr"

vim.keymap.set('n', '<leader>lf', function()
	vim.bo.spelllang = "fr"
end, { desc = "Set language to French" })

vim.keymap.set('n', '<leader>le', function()
	vim.bo.spelllang = "en"
end, { desc = "Set language to English" })

vim.keymap.set('n', '<leader>lb', function()
	vim.bo.spelllang = "fr,en"
end, { desc = "Set language to French and English" })

vim.keymap.set('n', '<leader>ll', function()
	vim.wo.spell = not vim.wo.spell
end, { desc = "Activate spell in the current buffer" })

vim.keymap.set('n', '<leader>lx', function()
	local clients = vim.lsp.get_clients({ name = 'ltex' })
	if #clients > 0 then
		vim.cmd('LspStop ltex')
		print("ltex language server stopped")
	else
		vim.cmd('LspStart ltex')
		print("ltex language server started")
	end
end, { desc = "Toggle ltex language server" })

vim.keymap.set('n', 'zn', ']s', { noremap = true, silent = true })
vim.keymap.set('n', 'zp', '[s', { noremap = true, silent = true })

-- vim.o.conceallevel = 2
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true

-- vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
-- vim.keymap.set("n", "<space>x", ":.lua<CR>")
-- vim.keymap.set("v", "<space>x", ":lua<CR>")

-- Exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

vim.keymap.set('n', 'grn', vim.lsp.buf.rename)
vim.keymap.set('n', 'gra', vim.lsp.buf.code_action)
vim.keymap.set('n', 'grr', vim.lsp.buf.references)

vim.keymap.set('i', '<C-h>', '<C-w>', { noremap = true })
vim.keymap.set('i', '<C-s>', '<BS>', { noremap = true })
-- vim.keymap.set('i', '<C-W>l', '<Esc>dwi')
-- vim.keymap.set('i', '<C-W>j', '<Esc>Jdwi')
vim.keymap.set('i', '<C-L>', '<Esc>wdwi', { noremap = true })

vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Diagnostics
vim.keymap.set('n', 'dn', vim.diagnostic.goto_next)
vim.keymap.set('n', 'dp', vim.diagnostic.goto_prev)
vim.keymap.set("n", "dq", vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename)
vim.keymap.set('n', 'da', vim.lsp.buf.code_action)

-- General Leader Key Setup
vim.g.mapleader = " " -- Set leader key to space
vim.g.maplocalleader = " "

-- Keybindings for Obsidian commands
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Obsidian Commands
map("n", "<leader>oo", ":ObsidianOpen ", opts)                  -- Open with a query
map("n", "<leader>on", ":ObsidianNew<CR>", opts)                -- Create a new note
map("n", "<leader>onq", ":ObsidianNew ", opts)                  -- Create a new note with title
map("n", "<leader>oq", ":ObsidianQuickSwitch<CR>", opts)        -- Quick switch
map("n", "<leader>ol", ":ObsidianFollowLink<CR>", opts)         -- Follow link
map("n", "<leader>olv", ":ObsidianFollowLink vsplit<CR>", opts) -- Follow link in vertical split
map("n", "<leader>olh", ":ObsidianFollowLink hsplit<CR>", opts) -- Follow link in horizontal split
map("n", "<leader>ob", ":ObsidianBacklinks<CR>", opts)          -- Backlinks
map("n", "<leader>ot", ":ObsidianTags ", opts)                  -- Search by tags
map("n", "<leader>otd", ":ObsidianToday<CR>", opts)             -- Open today's daily note
map("n", "<leader>oty", ":ObsidianToday -1<CR>", opts)          -- Yesterday's note
map("n", "<leader>ott", ":ObsidianTomorrow<CR>", opts)          -- Tomorrow's note
map("n", "<leader>od", ":ObsidianDailies<CR>", opts)            -- List dailies
map("n", "<leader>os", ":ObsidianSearch<CR>", opts)             -- Search notes
map("v", "<leader>ok", ":ObsidianLink<CR>", opts)               -- Link selected text
map("v", "<leader>okq", ":ObsidianLink ", opts)                 -- Link with a query
map("v", "<leader>okn", ":ObsidianLinkNew<CR>", opts)           -- Create a new note and link
map("n", "<leader>oknq", ":ObsidianLinkNew ", opts)             -- Create a new note with title
map("n", "<leader>ox", ":ObsidianLinks<CR>", opts)              -- Collect links in the current buffer
map("v", "<leader>oe", ":ObsidianExtractNote<CR>", opts)        -- Extract selection into a new note
map("v", "<leader>oeq", ":ObsidianExtractNote ", opts)          -- Extract selection with title
map("n", "<leader>ow", ":ObsidianWorkspace<CR>", opts)          -- Switch workspace
map("n", "<leader>oi", ":ObsidianPasteImg<CR>", opts)           -- Paste image from clipboard
map("n", "<leader>or", ":ObsidianRename<CR>", opts)             -- Rename current note
map("n", "<leader>ord", ":ObsidianRename --dry-run<CR>", opts)  -- Dry run rename
map("n", "<leader>oc", ":ObsidianToggleCheckbox<CR>", opts)     -- Toggle checkbox
map("n", "<leader>otc", ":ObsidianTOC<CR>", opts)               -- Table of contents
map("n", "<leader>otn", ":ObsidianNewFromTemplate<CR>", opts)   -- New note from template
map("n", "<leader>otnq", ":ObsidianNewFromTemplate ", opts)     -- New note from template with title
