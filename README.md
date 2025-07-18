<p align='right'><em>Last updated: 2025-07-18 09:27 UTC+7</em></p>

# alpha-ascii.nvim

A simple plugin for [alpha-nvim ]("https://github.com/goolord/alpha-nvim") that provides custom ASCII headers for the dashboard screen.

## ✨ Preview

<div align="center">
  <img src="screenshots/ascii_preview.gif" width="600" alt="ascii gif preview"/>
</div>

<details><summary>Show individual screenshots</summary>

<div align="center">
  <table>
    <tr>
      <td align="center"><img src="screenshots/abstract_portrait.png" width="160"/><br/><sub><b>abstract_portrait</b></sub></td>
      <td align="center"><img src="screenshots/blue_bubblegum.png" width="160"/><br/><sub><b>blue_bubblegum</b></sub></td>
      <td align="center"><img src="screenshots/calm_eyes.png" width="160"/><br/><sub><b>calm_eyes</b></sub></td>
    </tr>
    <tr>
      <td align="center"><img src="screenshots/color_eyes.png" width="160"/><br/><sub><b>color_eyes</b></sub></td>
      <td align="center"><img src="screenshots/girl_bandaged_eyes.png" width="160"/><br/><sub><b>girl_bandaged_eyes</b></sub></td>
      <td align="center"><img src="screenshots/red_jpa.png" width="160"/><br/><sub><b>red_jpa</b></sub></td>
    </tr>
  </table>
</div>
</details>

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
            dashboard.button("SPC c i", "  Change header image", ":AlphaAsciiNext<CR>"),
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

## ⚙️Configuration

```lua
opts = {
    header = "random", -- Set to "random" for a random header, or a specific header name (without .lua extension)
    exclude = { "example1", "ugly_header" }, -- List of headers to exclude (filenames without .lua)
}
```

<!-- ## Generate header image -->
<!---->
<!-- You can use [nxtkofi's img2art github repository](https://github.com/nxtkofi/img2art) a fork of [Asthestarsfalll's img2art github repository](https://github.com/Asthestarsfalll/img2art) to generate header images. -->
<!---->
<!-- > [!Important] -->
<!-- > For more details or custom output options visit [Asthestarsfalll's img2art github repository](https://github.com/Asthestarsfalll/img2art) -->
<!-- > Without him none of this would be possible! -->
<!---->
<!-- 1. Clone my fork of ASthestarsfalll's repository. git clone https://github.com/nxtkofi/img2art -->
<!---->
<!-- 2. Install requirements inside the project root -->
<!---->
<!--     ``` -->
<!--     cd img2art -->
<!--     python -m venv ./venv -->
<!--     source venv/bin/activate -->
<!--     pip install typer opencv-python numpy -->
<!---->
<!--     ``` -->
<!---->
<!-- 3. We're now ready to go! Run: poetry run python -m img2art.cli ~/path/to/picture.jpg --scale 0.3 --threshold 20 --save-raw ./test.lua --alpha -->
<!---->
<!-- What does it do: -->
<!---->
<!-- - `--scale 0.3` This is scaling for our image. Pick a value so it fits into Your dashboard -->
<!-- - `-threshold 20` This is black-white threshold point. I suggest You play around it for a bit to see what's the best outcome for Your picture. Usually it's something between 20-150 -->
<!-- - `./test.lua` This is where our output file will go and what name will it receive. Leave .lua extension. You may change the name. -->
<!-- - `--alpha` This makes sure that we get our picture in desired output style (ready to paste into alpha's dashboard!). -->
<!---->
<!-- You should have Your output file now! Move it into header_img folder. Now to set a header image go ahead and check out my ./lua/custom/plugins/alpha.lua file. -->
<!-- Function load_random_header() loads random header image from header_img folder on nvim startup. -->
