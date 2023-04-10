local set = require('mynvim.utils.keymap').set
local group = require('mynvim.utils.keymap').group

-- Don't use Ex mode, use Q for formatting
set('map', 'Q', 'gq', 'Formatting')

-- CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
-- so that you can undo CTRL-U after inserting a line break.
set('inoremap', '<C-U>', '<C-G>u<C-U>')

-- Jump to next / previous window
set('noremap', '<C-Tab>', '<C-W>w', 'Next window')
set('noremap', '<C-S-Tab>', '<C-W>W', 'Previous window')

-- move between windows
set('nnoremap', '<silent><up>', '<Cmd>wincmd k<CR>', 'Window above')
set('nnoremap', '<silent><down>', '<Cmd>wincmd j<CR>', 'Window below')
set('nnoremap', '<silent><right>', '<Cmd>wincmd l<CR>', 'Window at right')
set('nnoremap', '<silent><left>', '<Cmd>wincmd h<CR>', 'Window at left')

-- Copy clipboard
group('<leader>y', 'Copy to system clipboard or terminal')
set('nnoremap', '<leader>yy', '"+y', 'Copy to system clipboard')
set('vnoremap', '<leader>yy', '"+y', 'Copy to system clipboard')
-- Copy all to clipboard
set('nnoremap', '<leader>yA', '<Cmd>%yank+<CR>', 'Copy all to system clipboard')

-- hide highlight search
set('nnoremap', '<silent><F12>', '<Cmd>nohls<CR>', 'Hide highlight search')

group('<leader>o', 'Toggle options')
set('noremap', '<silent><leader>ol', '<Cmd>set list!<CR>', 'Toggle showing spaces')
set('noremap', '<silent><leader>or', '<Cmd>set readonly!<CR>', 'Toggle readonly')

set('nnoremap', '<space>', 'Lzt', 'Scroll one page')

-- TODO works fine in term but doesn't work in Gonvim
-- Use shift+Space to enter/exit insert mode
set('nnoremap', '<S-space>', 'i')
set('inoremap', '<S-space>', '<Esc>')

-- Change cwd to the file path
set('nnoremap', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>', 'Set CWD to folder of current buffer')

if vim.g.gonvim_running == 1 then
    -- toggle fullscreen
    set('nnoremap', '<silent><C-F11>', '<cmd>GonvimFullscreen "toggle"<cr>')

    if vim.fn.has('mac') == 1 then
        set('nnoremap', '<D-v>', 'o<Esc>"+p')
        set('inoremap', '<D-v>', '<C-r>+')
        set('cnoremap', '<D-v>', '<C-r>+')
        set('snoremap', '<D-c>', '"+y')
        set('vnoremap', '<D-c>', '"+y')
        set('snoremap', '<D-x>', '"+d')
        set('vnoremap', '<D-x>', '"+d')
    end
end

