local core = require("core")
local M = {}

function M.setup(opts)
    core.options = vim.tbl_deep_extend("force", core.options, opts or {})
    core.init_list()
    core._index = 1

    local header = core.get_header()

    if header then
        require("alpha.themes.dashboard").config.layout[2] = header
    else
        print("[alpha_ascii] No ascii headers found.")
    end

    vim.api.nvim_create_user_command("AlphaAsciiRandom", function()
        local idx = core.get_random_index()
        if idx then
            core.set_header_by_index(idx)
        end
    end, {})

    vim.api.nvim_create_user_command("AlphaAsciiNext", function()
        if #core._ascii_list > 0 then
            local idx = core._index % #core._ascii_list + 1
            core.set_header_by_index(idx)
        end
    end, {})

    vim.api.nvim_create_user_command("AlphaAsciiPrev", function()
        if #core._ascii_list > 0 then
            local idx = (core._index - 2 + #core._ascii_list) % #core._ascii_list + 1
            core.set_header_by_index(idx)
        end
    end, {})

    vim.api.nvim_create_user_command("AlphaAsciiName", function()
        local item = core._ascii_list[core._index]
        print("[alpha_ascii] Current header: " .. (item and item.name or "N/A"))
    end, {})
end

return M
