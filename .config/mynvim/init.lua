-- Load Lazy configuration
require("config.lazy")

-- Spell configuration
vim.wo.spell = false
vim.opt.spelllang = "fr"

-- Keymaps for switching spell language
vim.keymap.set('n', '<leader>lf', function()
	vim.bo.spelllang = "fr"
end, { desc = "Set spell language to French" })

vim.keymap.set('n', '<leader>le', function()
	vim.bo.spelllang = "en"
end, { desc = "Set spell language to English" })

vim.keymap.set('n', '<leader>lb', function()
	vim.bo.spelllang = "fr,en"
end, { desc = "Set spell language to French and English" })

vim.keymap.set('n', '<leader>ll', function()
	vim.wo.spell = not vim.wo.spell
end, { desc = "Toggle spell checking in the current buffer" })

-- Toggle ltex language server
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

-- Navigation for spelling suggestions
vim.keymap.set('n', 'zn', ']s', { noremap = true, silent = true, desc = "Next spelling suggestion" })
vim.keymap.set('n', 'zp', '[s', { noremap = true, silent = true, desc = "Previous spelling suggestion" })

-- General Neovim settings
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true

-- Exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Set timeout length for which-key popup
vim.opt.timeoutlen = 300

-- LSP keymaps
vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set('n', 'gra', vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set('n', 'grr', vim.lsp.buf.references, { desc = "Find references" })

-- Insert mode keybindings
vim.keymap.set('i', '<C-h>', '<C-w>', { noremap = true, desc = "Delete previous word" })
vim.keymap.set('i', '<C-s>', '<BS>', { noremap = true, desc = "Delete previous character" })
vim.keymap.set('i', '<C-L>', '<Esc>wdwi', { noremap = true, desc = "Delete word and re-enter insert mode" })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Diagnostics navigation
vim.keymap.set('n', 'dn', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set('n', 'dp', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set('n', 'dq', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, { desc = "Rename symbol (LSP)" })
vim.keymap.set('n', 'da', vim.lsp.buf.code_action, { desc = "Perform code action" })

-- Set leader keys
vim.g.mapleader = " " -- Space as leader key
vim.g.maplocalleader = " "

-- Obsidian keymaps
vim.keymap.set("n", "<leader>oo", ":ObsidianOpen ", { desc = "Open with a query" })
vim.keymap.set("n", "<leader>on", ":ObsidianNew<CR>", { desc = "Create a new note" })
vim.keymap.set("n", "<leader>oq", ":ObsidianQuickSwitch<CR>", { desc = "Quick switch" })
vim.keymap.set("n", "<leader>ol", ":ObsidianFollowLink<CR>", { desc = "Follow link" })
vim.keymap.set("n", "<leader>olv", ":ObsidianFollowLink vsplit<CR>", { desc = "Follow link in vertical split" })
vim.keymap.set("n", "<leader>olh", ":ObsidianFollowLink hsplit<CR>", { desc = "Follow link in horizontal split" })
vim.keymap.set("n", "<leader>ob", ":ObsidianBacklinks<CR>", { desc = "View backlinks" })
vim.keymap.set("n", "<leader>ot", ":ObsidianTags ", { desc = "Search by tags" })
vim.keymap.set("n", "<leader>odd", ":ObsidianToday<CR>", { desc = "Open today's daily note" })
vim.keymap.set("n", "<leader>ody", ":ObsidianToday -1<CR>", { desc = "Open yesterday's note" })
vim.keymap.set("n", "<leader>odt", ":ObsidianTomorrow<CR>", { desc = "Open tomorrow's note" })
vim.keymap.set("n", "<leader>od", ":ObsidianDailies<CR>", { desc = "List daily notes" })
vim.keymap.set("n", "<leader>os", ":ObsidianSearch<CR>", { desc = "Search notes" })
vim.keymap.set("v", "<leader>ok", ":ObsidianLink<CR>", { desc = "Link selected text" })
vim.keymap.set("v", "<leader>okq", ":ObsidianLink ", { desc = "Link with a query" })
vim.keymap.set("v", "<leader>okn", ":ObsidianLinkNew<CR>", { desc = "Create and link a new note" })
vim.keymap.set("n", "<leader>oknq", ":ObsidianLinkNew ", { desc = "Create a new note with title" })
vim.keymap.set("n", "<leader>ox", ":ObsidianLinks<CR>", { desc = "Collect links in the current buffer" })
vim.keymap.set("v", "<leader>oe", ":ObsidianExtractNote<CR>", { desc = "Extract selection into a new note" })
vim.keymap.set("v", "<leader>oeq", ":ObsidianExtractNote ", { desc = "Extract selection with title" })
vim.keymap.set("n", "<leader>ow", ":ObsidianWorkspace<CR>", { desc = "Switch workspace" })
vim.keymap.set("n", "<leader>oi", ":ObsidianPasteImg<CR>", { desc = "Paste image from clipboard" })
vim.keymap.set("n", "<leader>or", ":ObsidianRename<CR>", { desc = "Rename current note" })
vim.keymap.set("n", "<leader>oc", ":ObsidianToggleCheckbox<CR>", { desc = "Toggle checkbox" })
vim.keymap.set("n", "<leader>otc", ":ObsidianTOC<CR>", { desc = "Generate table of contents" })
