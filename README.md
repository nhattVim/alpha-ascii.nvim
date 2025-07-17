<p align='right'><em>Last updated: 2025-07-17 16:28 UTC+7</em></p>

# alpha-ascii.nvim

A simple plugin for [alpha-nvim ]("https://github.com/goolord/alpha-nvim") that provides custom ASCII headers for the dashboard screen.

## ✨ Preview

<div align="center">
    <table>
        <tr>
            <td><img src="screenshots/abstract_portrait.png"/></td>
            <td><img src="screenshots/blue_bubblegum.png"/></td>
            <td><img src="screenshots/calm_eyes.png"/></td>
        </tr>
        <tr>
            <td><img src="screenshots/color_eyes.png"/></td>
            <td><img src="screenshots/girl_bandaged_eyes.png"/></td>
            <td><img src="screenshots/red_jpa.png"/></td>
        </tr>
    </table>
</div>

## 📦 Installation

Use your favourite package manager and call the setup function.

```lua
-- lua with lazy.nvim
return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = {
        "nhattVim/alpha-ascii.nvim",
        opts = { header = "random" },
    },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.buttons.val = {
            dashboard.button("SPC f f", "  Find File  ", ":Telescope find_files<CR>"),
            dashboard.button("SPC f o", "  Recent File  ", ":Telescope oldfiles<CR>"),
            dashboard.button("SPC f w", "  Find Word  ", ":Telescope live_grep theme=ivy<CR>"),
            dashboard.button("SPC f b", "  Bookmarks  ", ":Telescope marks theme=ivy<CR>"),
            dashboard.button("SPC f t", "  Themes  ", ":Telescope colorscheme enable_preview=false<CR>"),
            dashboard.button("SPC f s", "  Settings", ":e $MYVIMRC | :cd %:p:h <CR>"),
            dashboard.button("SPC c i", "  Change header image", ":ChDbHeader<CR>"),
        }

        vim.api.nvim_create_autocmd("User", {
            once = true,
            pattern = "LazyVimStarted",
            callback = function()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                dashboard.section.footer.val = {
                    " ",
                    " Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins  in " .. ms .. " ms ",
                }
                pcall(vim.cmd.AlphaRedraw)
            end,
        })

        alpha.setup(dashboard.opts)
    end,
}
```
