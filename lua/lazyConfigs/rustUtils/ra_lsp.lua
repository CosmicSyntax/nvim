local M = {}

local function inner_request(full_method, params, handler)
    local extract_response = function(responses)
        local rust_analyzer_response = responses[M.ra_client_id()]

        if rust_analyzer_response ~= nil then
            handler(rust_analyzer_response)
            return
        end

        for _, response in pairs(responses) do
            handler(response)
            return
        end
    end

    vim.lsp.buf_request_all(0, full_method, params, extract_response)
end

function M.request(method, params, handler)
    inner_request("rust-analyzer/" .. method, params, handler)
end

function M.experimental_request(method, params, handler)
    inner_request("experimental/" .. method, params, handler)
end

function M.client_is_ra(client)
    if client.name == "rust_analyzer" or client.name == "rust-analyzer" then
        return true
    end
    local response = client.request_sync("rust-analyzer/analyzerStatus", {}, 100, 0)
    return response ~= nil and response.result ~= nil
end

-- Modernized Client Fetching
function M.ra_client_id(bufnr)
    bufnr = bufnr or 0
    -- Neovim 0.10+ API
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    for _, client in ipairs(clients) do
        if M.client_is_ra(client) then
            return client.id
        end
    end
    return nil
end

function M.offset_encoding(bufnr)
    local ra_id = M.ra_client_id(bufnr)
    if ra_id == nil then
        return "utf-16"
    end

    local ra = vim.lsp.get_client_by_id(ra_id)
    return ra.offset_encoding
end

function M.current_buf_has_ra()
    return M.ra_client_id() ~= nil
end

return M
