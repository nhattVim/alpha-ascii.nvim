local M = {}

function M.get_ascii_files(folder)
    local glob_pattern = folder .. "*.lua"
    local files = vim.fn.glob(glob_pattern, true, true)
    local result = {}

    for _, path in ipairs(files) do
        local name = path:match("([^/\\]+)%.lua$")
        if name and name ~= "init" then
            table.insert(result, name)
        end
    end

    return result
end

function M.load_ascii(name, path)
    local file = path .. "/" .. name .. ".lua"
    local chunk, err = loadfile(file)
    if not chunk then
        print("[alpha_ascii] Failed to load file: " .. err)
        return nil
    end

    local ok, mod = pcall(chunk)
    return (ok and mod and mod.header) and mod.header or nil
end

return M
