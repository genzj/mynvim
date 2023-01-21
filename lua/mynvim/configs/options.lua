vim.g.mapleader = "," -- make sure to set `mapleader` before lazy so your mappings are correct

local set = vim.opt

set.history = 50 --  keep 50 lines of command line history
set.ruler = true --  show the cursor position all the time
set.showcmd = true --  display incomplete commands
set.incsearch = true --  do incremental searching
set.showmatch = true --  show match
set.number = true --  show line No.

set.softtabstop = 4 --  Set tabstop width
set.tabstop = 4 --  ||
set.shiftwidth = 4 --  --
set.expandtab = true -- expand tab and use space by default

set.sbr = '->' -- chars before a wraped line
set.listchars = 'space:⋅,tab:>-,eol:$' -- tab & eol char
set.list = false -- not show tabs and EOLs by default

set.foldmethod = 'syntax' -- set fold
set.foldlevel = 100 -- do not fold by default

set.errorbells = false -- no sound
set.visualbell = false

set.wildmenu = true -- expand options on status bar

set.scrolloff = 4 -- Lines of context
set.sidescrolloff = 8 -- Columns of context

set.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time

set.timeoutlen = 5000 -- Longer timeout for leader cmds

-- using rg for grep
set.grepformat = "%f:%l:%c:%m"
set.grepprg = "rg --vimgrep"

set.guifont = {
    "JetBrainsMono_Nerd_Font:h13.000000",
    "Inconsolata-dz_for_Powerline:h12",
    "Monospace 12"
}

if vim.g.gonvim_running then
    set.lines = 60
    set.columns = 162
end

