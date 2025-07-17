local M = {}

local function get_ascii_files()
    local folder = debug.getinfo(1, "S").source:sub(2):match("(.*/)") or ""
    local glob_pattern = folder .. "alpha_ascii/" .. "*.lua"
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

local function load_ascii(name)
    local module_name = "alpha_ascii." .. name
    package.loaded[module_name] = nil
    local ok, mod = pcall(require, module_name)
    if ok and mod.header then
        return mod.header
    else
        return nil
    end
end

M.options = {
    header = nil,
}

function M.setup(opts)
    M.options = vim.tbl_deep_extend("force", M.options, opts or {})
    M.apply_header()

    vim.api.nvim_create_user_command("ChDbHeader", function()
        require("alpha_ascii").change_header()
    end, {})
end

function M.get_random_header()
    local files = get_ascii_files()

    if #files == 0 then
        return nil
    end

    math.randomseed(os.time())
    local name = files[math.random(#files)]
    return load_ascii(name)
end

function M.get_header()
    if M.options.header == "random" or M.options.header == nil then
        return M.get_random_header()
    else
        return load_ascii(M.options.header)
    end
end

function M.apply_header()
    local dashboard = require("alpha.themes.dashboard")
    local header = M.get_header()
    if header then
        dashboard.config.layout[2] = header
    else
        print("[alpha_ascii] No ascii headers found.")
    end
end

function M.change_header()
    local dashboard = require("alpha.themes.dashboard")
    local new_header = M.get_random_header()
    if new_header then
        dashboard.config.layout[2] = new_header
        vim.cmd("AlphaRedraw")
    else
        print("[alpha_ascii] No ascii headers found.")
    end
end

return M
