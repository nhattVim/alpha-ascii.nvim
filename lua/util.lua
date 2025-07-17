local M = {}

function M.get_ascii_files(folder)
    local glob_pattern = folder .. "headers/*.lua"
    local files = vim.fn.glob(glob_pattern, true, true)
    local result = {}

    for _, path in ipairs(files) do
        local name = path:match("([^/\\]+)%.lua$")
        if name ~= "init" then
            table.insert(result, name)
        end
    end

    return result
end

function M.load_ascii(name)
    local module_name = "headers." .. name
    package.loaded[module_name] = nil
    local ok, mod = pcall(require, module_name)
    return (ok and mod.header) and mod.header or nil
end

return M
