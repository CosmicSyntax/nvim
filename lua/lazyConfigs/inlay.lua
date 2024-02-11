local function enable_inlay_hints()
	vim.lsp.inlay_hint.enable()
	vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = '#616e88', italic = true })
end

-- Built-in inlay hint... neovim 0.10 needed
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client_id = ev.data.client_id
		local client = vim.lsp.get_client_by_id(client_id)
		local M = {}

		if client.server_capabilities.inlayHintProvider then
			-- Rust specific since LSP is not immediatelt available when on_attach is called
			if vim.bo.filetype == 'rust' then
				vim.lsp.handlers['experimental/serverStatus'] = function(_, result)
					if result.quiescent and not M.ran_once then
						vim.lsp.inlay_hint.enable(0, false)
						enable_inlay_hints()
						M.ran_once = true
					end
				end
			end

			enable_inlay_hints()
		end
	end,
})
