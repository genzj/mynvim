local set = require('mynvim.utils.keymap').set
local group = require('mynvim.utils.keymap').group
local utils = require('mynvim.utils')

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

-- Copy to clipboard
set('noremap', '<leader>y', '"+y', 'Copy to system clipboard')
-- Paste from clipboard
set('nnoremap', '<silent><leader>p', '"+p', 'Paste system clipboard after cursor')
set('nnoremap', '<silent><leader>P', '"+P', 'Paste system clipboard before cursor')
set('nnoremap', '<silent><leader>gp', '<Cmd>silent put+<CR>', 'Paste system clipboard after current line')
if utils.is_linux() and utils.is_gui_running() then
    -- Linux GUI inserts <S-Insert> by default and this is a fix
    set('inoremap', '<silent><S-Insert>', '<C-r>+', 'Insert system clipboard content')
end

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

-- Motions
set('onoremap', '<silent>A', ':<C-U>normal! ggVG<CR>', 'The entire buffer')
-- patch for visual mode because the `A` has a default behavior to enter insert mode
set('nnoremap', '<silent>vA', '<Esc>ggVG', 'Mark the entire buffer in visual mode')
set('nnoremap', '<silent>VA', '<Esc>ggVG', 'Mark the entire buffer in visual mode')

if utils.is_mac() and utils.is_gui_running() then
    set('nnoremap', '<D-v>', 'o<Esc>"+p')
    set('inoremap', '<D-v>', '<C-r>+')
    set('cnoremap', '<D-v>', '<C-r>+')
    set('snoremap', '<D-c>', '"+y')
    set('vnoremap', '<D-c>', '"+y')
    set('snoremap', '<D-x>', '"+d')
    set('vnoremap', '<D-x>', '"+d')
end

