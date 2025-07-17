local U = require("util")
local M = {
    options = {
        header = "random",
        exclude = {},
        path = nil,
    },
    _ascii_list = {},
    _index = 1,
}

function M.init_list()
    local exclude = {}
    for _, name in ipairs(M.options.exclude or {}) do
        exclude[name] = true
    end

    local folder = debug.getinfo(1, "S").source:sub(2):match("(.*/)") or ""
    local list = U.get_ascii_files(folder)
    M._ascii_list = vim.tbl_filter(function(name)
        return not exclude[name]
    end, list)

    table.sort(M._ascii_list)
end

function M.get_random_index()
    if #M._ascii_list == 0 then
        return nil
    end
    math.randomseed(os.time())
    return math.random(#M._ascii_list)
end

function M.get_index_by_name(name)
    for i, v in ipairs(M._ascii_list) do
        if v == name then
            return i
        end
    end
    return nil
end

function M.get_header()
    if #M._ascii_list == 0 then
        return nil
    end

    local idx
    if M.options.header == "random" or not M.options.header then
        idx = M.get_random_index()
    else
        idx = M.get_index_by_name(M.options.header)
    end

    if idx then
        M._index = idx
        return U.load_ascii(M._ascii_list[idx])
    end
end

function M.set_header_by_index(idx)
    local name = M._ascii_list[idx]
    if not name then
        return
    end

    local header = U.load_ascii(name)
    if header then
        M._index = idx
        require("alpha.themes.dashboard").config.layout[2] = header
        vim.cmd("AlphaRedraw")
    else
        print("[alpha_ascii] Failed to load header: " .. name)
    end
end

return M
