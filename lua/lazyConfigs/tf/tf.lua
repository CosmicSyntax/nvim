local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable Terraform-LSP
vim.lsp.config["tofu_ls"] = {
	capabilities = capabilities,
	cmd = { "tofu-ls", "serve" },
	filetypes = { "hcl", "terraform-vars", "tf", "terraform" },
}
vim.lsp.enable("tofu_ls")
