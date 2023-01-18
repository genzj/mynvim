vim.g.mapleader = "," -- make sure to set `mapleader` before lazy so your mappings are correct

local set = vim.opt

set.history = 50               --  keep 50 lines of command line history
set.ruler = true               --  show the cursor position all the time
set.showcmd = true             --  display incomplete commands
set.incsearch = true           --  do incremental searching
set.showmatch = true           --  show match
set.number = true              --  show line No.

set.softtabstop=4              --  Set tabstop width
set.tabstop=4                  --  ||
set.shiftwidth=4               --  --
set.expandtab = true           -- expand tab and use space by default

set.sbr='->'                   -- chars before a wraped line
set.listchars='tab:>-,eol:$'   -- tab & eol char
set.list = false               -- not show tabs and EOLs by default

set.foldmethod='syntax'        -- set fold
set.foldlevel=100              -- do not fold by default

set.errorbells = false         -- no sound
set.visualbell = false

set.wildmenu = true            -- expand options on status bar

set.guifont = {
    "JetBrainsMono_Nerd_Font_Mono:h12.000000",
    "Inconsolata-dz_for_Powerline:h10",
    "Monospace 11"
}

-- TODO move lines and columns to gui settings
if vim.fn.has('win32') == 1 then
    -- set.lines = 40
    -- set.columns = 120
elseif vim.fn.has('mac') == 1 then
    -- set lines = 60
    -- set.columns = 120
else
end
