vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client_id = ev.data.client_id
		local client = vim.lsp.get_client_by_id(client_id)

		if client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint(0, true)
			vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = '#616e88', italic = true })
		end
	end,
})
