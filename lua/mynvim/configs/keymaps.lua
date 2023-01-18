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
set('nnoremap', '<silent><up>', ':wincmd k<CR>')
set('nnoremap', '<silent><down>', ':wincmd j<CR>')
set('nnoremap', '<silent><right>', ':wincmd l<CR>')
set('nnoremap', '<silent><left>', ':wincmd h<CR>')

-- Copy all to clipboard
set('nnoremap', ',ya', ':%y+<CR>')

-- Open NERD Tree explorer
set('nnoremap', '<F3>', ':NERDTreeToggle<CR>')

-- hide highlight search
set('nnoremap', '<silent><F12>', ':nohls<CR>')

-- toggle fullscreen
set('nnoremap', '<silent><F11>', ':exe ":silent call libcallnr(\"gvimfullscreen.dll\", \"ToggleFullScreen\", 0)"<CR>')

-- Find current file in NERD Tree explorer
set('nnoremap', '<C-F3>', ':NERDTreeFind<CR>')

-- Open Python 3 console
set('nnoremap', '<leader>zp', ':!python3<CR>')

-- Save and make current file
set('nnoremap', '<leader>zm', ':w<CR>:make<CR>')

-- toggle show list
set('noremap', '<silent><leader>ol', ':set list!<CR>')

-- toggle read only
set('noremap', '<silent><leader>oro', ':set readonly!<CR>')

-- toggle indent guides
set('nmap', '<silent><Leader>og', '<Plug>IndentGuidesToggle')

-- Super-Tab keymap
-- Enter the chosen one when the menu is visible
set('inoremap', '<expr><CR>', 'pumvisible()?"<C-Y>":"<CR>"')
set('inoremap', '<expr><space>', 'pumvisible()?"<C-Y>":"<space>"')
-- Scoll and move the highlight
set('inoremap', '<expr><C-j>', 'pumvisible()?"<PageDown>":"<C-j>"')
set('inoremap', '<expr><C-k>', 'pumvisible()?"<PageUp>":"<C-k>"')
set('inoremap', '<expr>j', 'pumvisible()?"<Down>":"j"')
set('inoremap', '<expr>k', 'pumvisible()?"<Up>":"k"')

set('noremap', '<leader>zw', '<C-W>=1<C-W><C-W>1<C-W>_')

-- scroll one page
set('nnoremap', '<space>', 'Lzt')

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

-- Open git status
set('nnoremap', '<leader>gs', ':Gstatus<cr>')

-- Change cwd to the file path
set('nnoremap', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>')

--  Jump to next error with Ctrl-n and previous error with Ctrl-m. Close the
--  quickfix window with <leader>a
set('nnoremap', '<C-PageDown>', ':cnext<CR>')
set('nnoremap', '<C-PageUp>', ':cprevious<CR>')
set('nnoremap', '<leader>a', ':<C-u>call scraps#ToggleQuickfixErrorWindow()<CR>')

