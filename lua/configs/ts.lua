local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Typescript
require("typescript").setup({
    disable_commands = false,
    debug = false,
    go_to_source_definition = {
        fallback = true,
    },
    server = {
		capabilities = capabilities,
        on_attach = function(client, bufnr)
			require("lsp-inlayhints").on_attach(client, bufnr)
		end,
    },
})
