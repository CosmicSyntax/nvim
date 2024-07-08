-- map keys for flash
local map = vim.api.nvim_set_keymap

map('n', 's', '<cmd>lua require("flash").jump()<CR>', { noremap = true, silent = true })
map('n', 'S', '<cmd>lua require("flash").treesitter()<CR>', { noremap = true, silent = true })
