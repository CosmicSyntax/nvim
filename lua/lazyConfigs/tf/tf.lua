local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable Terraform-LSP
vim.lsp.config["terraformls"] = {
	capabilities = capabilities,
	cmd = { "terraform-ls", "serve" },
	filetypes = { "hcl", "tf", "terraform" },
}
vim.lsp.enable("terraformls")
