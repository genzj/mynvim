local function gonvim_settings()
    if not vim.g.gonvim_running then
        return
    end

    -- gonvim always opens from `/` when being started from
    -- the MacOS spotlight
    if vim.fn.argc() == 0 and vim.fn.getcwd() == '/' then
        vim.cmd.cd('~')
    end
end

gonvim_settings()

