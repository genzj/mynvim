---- init hooks to notify https://marketplace.visualstudio.com/items?itemName=JulianIaquinandi.nvim-ui-modifier
local function init_neovide_ui_modifier()
    vim.api.nvim_exec2([[
    " THEME CHANGER
    function! SetCursorLineNrColorInsert(mode)
        " Insert mode: blue
        if a:mode == "i"
            call VSCodeNotify('nvim-theme.insert')

        " Replace mode: red
        elseif a:mode == "r"
            call VSCodeNotify('nvim-theme.replace')
        endif
    endfunction

    augroup CursorLineNrColorSwap
        autocmd!
        autocmd ModeChanged *:[vV\x16]* call VSCodeNotify('nvim-theme.visual')
        autocmd ModeChanged *:[R]* call VSCodeNotify('nvim-theme.replace')
        autocmd InsertEnter * call SetCursorLineNrColorInsert(v:insertmode)
        autocmd InsertLeave * call VSCodeNotify('nvim-theme.normal')
        autocmd CursorHold * call VSCodeNotify('nvim-theme.normal')
        autocmd ModeChanged [vV\x16]*:* call VSCodeNotify('nvim-theme.normal')
    augroup END
]],
        {
            output = false
        }
    )
end

---- vscode specific settings
local function configure_nvim()
    -- make the output panel to popup less
    -- https://github.com/vscode-neovim/vscode-neovim/issues/2099#issuecomment-2169085647
    vim.o.cmdheight = 4
end

local function init()
    if not vim.g.vscode then
        return
    end

    configure_nvim()
    init_neovide_ui_modifier()
end

init()
