" Vim option settings ---------- {{{

" TODO: plugin manager
" Enable pathogen
" call pathogen#infect()
" call pathogen#helptags()

"set background=light

"TODO install colorscheme
"colorscheme summerfruit256
"let g:solarized_contrast = "high"
"let g:solarized_visibility = "low"
"let g:solarized_hitrail = 1

"TODO install powerline
function! EnablePowerline() abort
    try
        python3 from powerline.vim import setup as powerline_setup
        python3 powerline_setup()
        python3 del powerline_setup
    catch /E319/
        python from powerline.vim import setup as powerline_setup
        python powerline_setup()
        python del powerline_setup
    endtry
    set laststatus=2 " always show status line
    set noshowmode "hide mode indications
endfunction

if has("gui_running")
    " no menu, toolbar and
    set guioptions=e
    set encoding=utf-8
    set laststatus=2 " always show status line
    colorscheme solarized8
else
    " in case want to use solarized theme in terminal
    if &term =~ '256color' || &term =~ 'kitty'
        let g:solarized_termcolors=256
        colorscheme solarized8_high

        if &term =~ "xterm\\|rxvt"
            " use an orange cursor in insert mode
            let &t_SI = "\<Esc>]12;orange\x7"
            " use a red cursor otherwise
            let &t_EI = "\<Esc>]12;orange\x7"
            silent !echo -ne "\033]12;orange\007"
            " reset cursor when vim exits
            autocmd VimLeave * silent !echo -ne "\033]112\007"
            " use \003]12;gray\007 for gnome-terminal and rxvt up to version 9.21
        endif

        " https://superuser.com/questions/457911/in-vim-background-color-changes-on-scrolling
        " Disable Background Color Erase (BCE) so that color schemes
        " work properly when Vim is used inside tmux and GNU screen.
        set t_ut=
    endif
endif

let g:myvimrc#has_powerline = 0
try
    call EnablePowerline()
    let g:myvimrc#has_powerline = 1
catch
endtry

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  " ttymouse must be set before use mouse
  " otherwise a hanging would happen
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" }}}

" Auto commands -------------------- {{{
" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    " Clear this group at first
    au!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    " Auto fold my vimrc file
    autocmd BufReadPost $MYVIMRC setlocal foldmethod=marker
    autocmd BufReadPost $MYVIMRC setlocal foldlevel=0
    autocmd BufReadPost $P2VIMRC setlocal foldmethod=marker
    autocmd BufReadPost $P2VIMRC setlocal foldlevel=0

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  "When .vimrc isedited, reload it
  autocmd bufwritepost $MYVIMRC source $MYVIMRC
  autocmd bufwritepost $MYVIMRC :echom "Lastest vimrc loaded!"
  "When phase2 vimrc isedited, reload it
  if file_readable(expand($MYVIMRC))
      autocmd bufwritepost $P2VIMRC source $MYVIMRC
  else
      autocmd bufwritepost $P2VIMRC source $P2VIMRC
  endif
  autocmd bufwritepost $P2VIMRC :echom "Lastest phase2 vimrc loaded!"

  augroup END

  augroup vimrc_autocmds
      autocmd!
      " highlight characters past column 120
      autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
      autocmd FileType python match Excess /\%120v.*/
      autocmd FileType python set nowrap
      autocmd FileType python IndentGuidesEnable

      " html usually nest deeply, so ues a smaller indent
      autocmd FileType {html,coffee} setlocal softtabstop=2
      autocmd FileType {html,coffee} setlocal tabstop=2
      autocmd FileType {html,coffee} setlocal shiftwidth=2
      autocmd FileType {html,coffee} setlocal expandtab
  augroup END

  augroup go_autocmds
    "au FileType go GoInstallBinaries
    " keybindings mostly follow jedi-vim conventions
    au FileType go nmap K <Plug>(go-info)
    au FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
    au FileType go nmap <Leader>d <Plug>(go-def)
    au FileType go nmap <Leader>b :<C-u>call scraps#Build_go_files()<CR>
    au FileType go nmap <Leader>g <Plug>(go-doc)
    au FileType go nmap <Leader>i :GoImport 
    au FileType go nmap <Leader>I :GoImports
    au FileType go nmap <Leader>l <Plug>(go-metalinter)
    au FileType go nmap <Leader>t <Plug>(go-test)
    au FileType go nmap <Leader>r <Plug>(go-rename)
    au FileType go nmap <Leader>s <Plug>(go-implements)

    " :GoAlternate commands, mostly follow a.vim
    autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
    autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
    autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  augroup END
else

  set autoindent        " always set autoindenting on
  set smartindent       " Smart indent
  set cindent       " C-style indent

endif " has("autocmd")
" }}}

" DiffOrig command -------------------- {{{
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif
" }}}


"Key Mappings -------------------- {{{

"map <silent> <F9> :TlistUpdate<CR>:TlistToggle<CR>
map <silent> <F9> :TagbarToggle<CR>
map <silent> <F10> :MBEToggle<cr>

noremap <C-Tab> <C-W>w
"Jump to next window
noremap <C-S-Tab> <C-W>W
"Jump to prev window
nnoremap <silent> <up> :wincmd k<CR>
nnoremap <silent> <down> :wincmd j<CR>
nnoremap <silent> <right> :wincmd l<CR>
nnoremap <silent> <left> :wincmd h<CR>

"Copy all to clipboard
nnoremap ,ya :%y+<CR>

nnoremap <F3> :NERDTreeToggle<CR>
"Open NERD Tree explorer

nnoremap <silent><F12> :nohls<CR>
"hide highlight search

nnoremap <silent><F11> :exe ":silent call libcallnr(\"gvimfullscreen.dll\", \"ToggleFullScreen\", 0)"<CR>
"toggle fullscreen

nnoremap <C-F3> :NERDTreeFind<CR>
"Find current file in NERD Tree explorer

if has("win32")
    let g:my_shell="git-bash.exe"
else
    let g:my_shell="bash"
endif

exec "nnoremap <leader>zb :!".my_shell."<CR>"
"Open bash shortkey

exec "noremap <silent><leader>zc :let w:prev_d=getcwd()<CR>:cd %:p:h<CR>:!".my_shell."<CR>:exe 'cd ' . w:prev_d<CR>:unlet w:prev_d<CR>"
"open a shell and set to folder of current file

" }}}

" Pandoc syntax configurations -------------------- {{{
let g:pandoc#syntax#codeblocks#embeds#langs = ["bash=sh", "python=python", "makefile=make", "yaml=yaml"]
if has("win32")
    "Diable pandoc conceal in windows
    "TODO replace conceal substitutions with chars can be displayed in win32
    let g:pandoc#syntax#conceal#use=0
endif

let g:user_emmet_settings = {
\  'html' : {
\    'indentation' : '  '
\  },
\}

" }}}

"Completion configuraions -------------------- {{{
let g:SuperTabCompletionContexts = ['s:ContextDiscover', 's:ContextText']
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery =
    \ ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]
" }}}

"Syntastic configuraions -------------------- {{{
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['pyflakes']
" disable html checker because it conflicts angularjs views
let g:syntastic_html_checkers = []
" vim-go and syntastic compatibility
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
let g:go_list_type = "quickfix"

" for react and es6 support, check
" https://jaxbot.me/articles/setting-up-vim-for-react-js-jsx-02-03-2015
let g:syntastic_javascript_checkers = ['eslint']

" }}}


"JSON specific configuraions -------------------- {{{
"https://github.com/elzr/vim-json
"au! BufRead,BufNewFile *.json set filetype=json
augroup json_autocmd
    autocmd!
    autocmd FileType json set autoindent
    autocmd FileType json set formatoptions=tcq2l
    autocmd FileType json set textwidth=78 shiftwidth=4
    autocmd FileType json set softtabstop=4 tabstop=4
    autocmd FileType json set expandtab
    autocmd FileType json set foldmethod=syntax
    autocmd FileType json let g:vim_json_syntax_conceal=0
augroup END
" }}}

"dictionary -------------------- {{{
if filereadable('/usr/share/dict/words')
   set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words
endif
" }}}

"indent guide plugin -------------------- {{{
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_default_mapping = 0
" }}}


"go file settings -------------------- {{{
let g:go_autodetect_gopath = 1

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1
" }}}

"vim-lsp settings {{{
let g:lsp_diagnostics_echo_cursor = 1

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

function! s:on_lsp_buffer_enabled() abort
    if exists('*asyncomplete#force_refresh()')
        let g:asyncomplete_auto_popup = 0
        inoremap <silent><expr> <TAB>
                    \ pumvisible() ? "\<C-n>" :
                    \ <SID>check_back_space() ? "\<TAB>" :
                    \ asyncomplete#force_refresh()
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    else
        " simple lsp complete
        setlocal omnifunc=lsp#complete
    endif
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    " Map definition to LSP features
    xmap <silent>gf <plug>(lsp-document-range-format)
    nmap <silent>gh <plug>(lsp-signature-help)
    nmap <silent>gd <plug>(lsp-definition)
    nmap <silent>gD <plug>(lsp-peek-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    nnoremap <expr><F9> scraps#ToggleVista()

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" }}}

" vim-buffet tabline settings {{{

" disable MiniBufferExplorer
let g:miniBufExplAutoStart = 0

" Keymaps
function! s:InstallBuffetKeymaps()
    let c = 1

    while c < 10
        execute "nmap <leader>" . c . " <Plug>BuffetSwitch(" . c . ")"
        let c += 1
    endwhile

    " for buffer index >= 10
    command! -nargs=1 Bb call buffet#bswitch(<q-args>)
endfunction
call s:InstallBuffetKeymaps()

" Theme
let g:buffet_show_index	= 1
let g:buffet_powerline_separators = 1
let g:buffet_tab_icon = "\uf00a"
let g:buffet_left_trunc_icon = "\uf0a8"
let g:buffet_right_trunc_icon = "\uf0a9"

function! g:BuffetSetCustomColors()
    hi! link BuffetCurrentBuffer Cursor
    hi! link BuffetActiveBuffer InsertMode
    hi! link BuffetBuffer StatusLine
    hi! link BuffetTab ReplaceMode
endfunction
" }}}

"TODO denite initializations {{{
"call scraps#InitializeDenite()
" }}}
