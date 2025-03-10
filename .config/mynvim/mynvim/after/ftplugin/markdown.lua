vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { fg = "grey", bold = true })
vim.opt.textwidth = 100
vim.opt_local.spell = true
vim.opt.shiftwidth = 2

vim.keymap.set('n', 'vw', 'viw', { noremap = true })
vim.keymap.set('n', 'vW', 'viW', { noremap = true })
