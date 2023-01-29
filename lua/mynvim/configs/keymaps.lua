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

-- toggle show list
set('noremap', '<silent><leader>ol', '<Cmd>set list!<CR>')

-- toggle read only
set('noremap', '<silent><leader>or', '<Cmd>set readonly!<CR>')

-- toggle indent guides
set('nmap', '<silent><Leader>og', '<Cmd>IndentBlanklineToggle!<CR>')

-- scroll one page
set('nnoremap', '<space>', 'Lzt')

-- TODO works fine in term but doesn't work in Gonvim
-- Use shift+Space to enter/exit insert mode
set('nnoremap', '<S-space>', 'i')
set('inoremap', '<S-space>', '<Esc>')

-- Change cwd to the file path
set('nnoremap', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>')

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

