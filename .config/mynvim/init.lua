require("config.lazy")

-- Spell configuration
vim.opt.spelllang = ""

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

vim.keymap.set('n', '<leader>ln', vim.diagnostic.goto_next, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>lp', vim.diagnostic.goto_prev, { noremap = true, silent = true })

vim.keymap.set('n', 'zn', ']s', { noremap = true, silent = true })
vim.keymap.set('n', 'zp', '[s', { noremap = true, silent = true })

vim.o.conceallevel = 2
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"

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
