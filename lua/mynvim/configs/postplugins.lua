local function gonvim_settings()
    if not vim.g.gonvim_running then
        return
    end

    -- toggle fullscreen
    -- set('nnoremap', '<silent><C-F11>', '<cmd>GonvimFullscreen "toggle"<cr>')

    -- gonvim always opens from `/` when being started from
    -- the MacOS spotlight
    if vim.fn.argc() == 0 and vim.fn.getcwd() == '/' then
        vim.cmd.cd('~')
    end
end

local function neovide_settings()
    if not vim.g.neovide then
        return
    end

    vim.g.neovide_cursor_vfx_mode = "pixiedust"
end

gonvim_settings()
neovide_settings()

