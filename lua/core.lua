local U = require("util")
local M = {
    options = {
        header = "random",
        exclude = {},
        user_path = nil,
    },
    _ascii_list = {},
    _index = 1,
}

function M.init_list()
    local exclude = {}
    for _, name in ipairs(M.options.exclude or {}) do
        exclude[name] = true
    end

    local default_folder = (debug.getinfo(1, "S").source:sub(2):match("(.*/)") or "") .. "headers"
    local default_list = {}

    for _, name in ipairs(U.get_ascii_files(default_folder)) do
        if not exclude[name] then
            table.insert(default_list, { name = name, path = default_folder })
        end
    end

    local user_folder = M.options.user_path and vim.fn.expand(M.options.user_path) or nil
    local user_list = {}

    if user_folder then
        for _, name in ipairs(U.get_ascii_files(user_folder)) do
            if not exclude[name] then
                table.insert(user_list, { name = name, path = user_folder })
            end
        end
    end

    M._ascii_list = vim.list_extend(default_list, user_list)

    table.sort(M._ascii_list, function(a, b)
        return a.name < b.name
    end)
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
        if v.name == name then
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
        local item = M._ascii_list[idx]
        return U.load_ascii(item.name, item.path)
    end
end

function M.set_header_by_index(idx)
    local item = M._ascii_list[idx]
    if not item then
        return
    end

    local header = U.load_ascii(item.name, item.path)
    if header then
        M._index = idx
        require("alpha.themes.dashboard").config.layout[2] = header
        vim.cmd("AlphaRedraw")
    else
        print("[alpha_ascii] Failed to load header: " .. item.name)
    end
end

return M
