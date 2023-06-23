return {
    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "meuter/lualine-so-fancy.nvim",
        },
        opts = function(plugin)
            local icons = require("mynvim.configs").icons
            local use_noice = require("mynvim.configs").switches.use_noice

            local function fg(name)
                return function()
                    ---@type {foreground?:number}?
                    local hl = vim.api.nvim_get_hl_by_name(name, true)
                    return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
                end
            end

            local function getWords()
                local wordcount = vim.fn.wordcount();
                return tostring(wordcount.visual_words or wordcount.words)
            end

            local function inRecording()
                return string.len(vim.fn.reg_recording()) > 0
            end

            local function invert(func_or_val)
                if type(func_or_val) == 'function' then
                    return function() return not func_or_val() end
                else
                    return function() return not func_or_val end
                end
            end

            local function chiming()
                local sec = os.date("*t").sec
                return sec >= 55 or sec <= 5
            end

            return {
                options = {
                    theme = "auto",
                    globalstatus = true,
                    disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
                },
                sections = {
                    lualine_a = { "fancy_mode" },
                    lualine_b = { "fancy_branch" },
                    lualine_c = {
                        { "fancy_diagnostics" },
                        { "fancy_filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                        { "filename", path = 0, symbols = { modified = "  ", readonly = "", unnamed = "" } },
                        -- stylua: ignore
                        {
                            function() return require("nvim-navic").get_location() end,
                            cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
                        },
                    },
                    lualine_x = {
                        -- stylua: ignore
                        {
                            function() return require("noice").api.status.command.get() end,
                            cond = function() return use_noice and require("noice").api.status.command.has() end,
                            color = fg("Statement")
                        },
                        -- stylua: ignore
                        {
                            function() return require("noice").api.status.mode.get() end,
                            cond = function() return use_noice and require("noice").api.status.mode.has() end,
                            color = fg("Constant") ,
                        },
                        {
                            function() return require("noice").api.status.search.get() end,
                            cond = function() return use_noice and require("noice").api.status.search.has() end,
                            color = fg("WarningMsg"),
                        },
                        -- Lazy update indicator
                        -- { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
                        { "fancy_diff", },
                        { "fancy_macro", cond = inRecording },
                        { "fileformat", separator = "", padding = 0, cond = invert(inRecording) },
                        { "o:encoding", separator = "", cond = invert(inRecording) },
                    },
                    lualine_y = {
                        { getWords, icon="" },
                        { "fancy_searchcount",
                            cond = invert(use_noice),
                            fmt = function (s)
                                if string.len(s) > 0 then
                                    return vim.fn.getreg("/") .. " [" .. s .. "]"
                                else
                                    return s
                            end
                        end },
                        { "fancy_location", separator = "", padding = { left = 1, right = 0, }},
                        { "progress", },
                    },
                    lualine_z = {
                        {
                            function() return " " .. os.date("%X") end,
                            cond = chiming,
                        },
                        {
                            "fancy_lsp_servers",
                            cond = invert(chiming),
                        },
                    },
                },
                extensions = { "nvim-tree", "quickfix" },
            }
        end,
    },
}
