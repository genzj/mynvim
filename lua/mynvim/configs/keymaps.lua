local set = require('mynvim.utils.keymap').set

-- Don't use Ex mode, use Q for formatting
set('map', 'Q', 'gq')

-- CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
-- so that you can undo CTRL-U after inserting a line break.
set('inoremap', '<C-U>', '<C-G>u<C-U>')

-- Jump to next / previous window
set('noremap', '<C-Tab>', '<C-W>w')
set('noremap', '<C-S-Tab>', '<C-W>W')

-- move between windows
set('nnoremap', '<silent><up>', '<Cmd>wincmd k<CR>')
set('nnoremap', '<silent><down>', '<Cmd>wincmd j<CR>')
set('nnoremap', '<silent><right>', '<Cmd>wincmd l<CR>')
set('nnoremap', '<silent><left>', '<Cmd>wincmd h<CR>')

-- Copy all to clipboard
set('nnoremap', ',ya', '<Cmd>%y+<CR>')

-- hide highlight search
set('nnoremap', '<silent><F12>', '<Cmd>nohls<CR>')

-- Open Python 3 console
set('nnoremap', '<leader>zp', '<Cmd>!python3<CR>')

-- toggle show list
set('noremap', '<silent><leader>ol', '<Cmd>set list!<CR>')

-- toggle read only
set('noremap', '<silent><leader>or', '<Cmd>set readonly!<CR>')

-- toggle indent guides
set('nmap', '<silent><Leader>og', '<Cmd>IndentBlanklineToggle!<CR>')

-- TODO omni completion
-- Super-Tab keymap
-- Enter the chosen one when the menu is visible
set('inoremap', '<expr><CR>', 'pumvisible()?"<C-Y>":"<CR>"')
set('inoremap', '<expr><space>', 'pumvisible()?"<C-Y>":"<space>"')
-- Scoll and move the highlight
set('inoremap', '<expr><C-j>', 'pumvisible()?"<PageDown>":"<C-j>"')
set('inoremap', '<expr><C-k>', 'pumvisible()?"<PageUp>":"<C-k>"')
set('inoremap', '<expr>j', 'pumvisible()?"<Down>":"j"')
set('inoremap', '<expr>k', 'pumvisible()?"<Up>":"k"')

-- scroll one page
set('nnoremap', '<space>', 'Lzt')

-- TODO surround
-- Add quotes, parentheses or brcakets around chosen text"
set('vmap', '<leader>"', 'S"')
set('vmap', '<leader>\'', 'S\'')
set('vmap', '<leader>`', 'S`')
set('vmap', '<leader>(', 'S(')
set('vmap', '<leader>{', 'S{')
set('vmap', '<leader><', 'S<')

-- Use shift+Space to enter/exit insert mode
set('nnoremap', '<S-space>', 'i')
set('inoremap', '<S-space>', '<Esc>')

-- Change cwd to the file path
set('nnoremap', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>')

--  Jump to next error with Ctrl-pd and previous error with Ctrl-pu. Close the
--  quickfix window with <leader>a
set('nnoremap', '<C-PageDown>', ':cnext<CR>')
set('nnoremap', '<C-PageUp>', ':cprevious<CR>')

if vim.g.gonvim_running == 1 then
    -- toggle fullscreen
    set('nnoremap', '<silent><C-F11>', '<cmd>GonvimFullscreen "toggle"<cr>')

    set('nnoremap', '<D-v>', 'a<C-r>+<Esc>')
    set('inoremap', '<D-v>', '<C-r>+')
    set('cnoremap', '<D-v>', '<C-r>+')
end

