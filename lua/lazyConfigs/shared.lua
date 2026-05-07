-- lua/lazyConfigs/shared.lua
local M = {}

-- Start Treesitter to ensure it's active for all filetypes
vim.treesitter.start()

-- Fetch the default capabilities and merge them with blink.cmp
M.capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

return M
