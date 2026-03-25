local capabilities = require('lazyConfigs.shared')

-- Enable Terraform-LSP
vim.lsp.config["tofu_ls"] = {
	capabilities = capabilities,
	cmd = { "tofu-ls", "serve" },
	filetypes = { "hcl", "terraform-vars", "tf", "terraform" },
}
vim.lsp.enable("tofu_ls")
