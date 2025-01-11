local set = vim.opt_local

set.shiftwidth = 4
set.tabstop = 4
set.number = true
set.relativenumber = true

vim.keymap.set("n", "<leader>c", ":write<CR>:VimtexCompile<CR>", { noremap = true, silent = true })
