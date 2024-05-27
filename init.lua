-- Start of UI Setting
local opt = vim.opt

opt.relativenumber = true
opt.number = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.signcolumn = "yes"
opt.mouse = "a"
opt.completeopt = [[menuone,noinsert,noselect]]
opt.guicursor = [[n:block-blinkon250,v:hor100-blinkon250,i:ver100-blinkon250]]
opt.updatetime = 1000
opt.foldmethod = "indent"
opt.winblend = 20
opt.termguicolors = true

local cmd = vim.cmd
cmd([[set shortmess+=c]])
cmd([[set noexpandtab]])
cmd([[set nofoldenable]])

-- End of UI Setting

-- Python config for faster startup
local g = vim.g
g.python3_host_prog = "~/.pyenv/shims/python"

-- Plugin Manager
require("plugins")
-- Plugin Configuration
require("config")
-- Key Mapping
require("mapping")
-- Statusline
require("statusline")
