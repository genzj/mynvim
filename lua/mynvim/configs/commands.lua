vim.api.nvim_exec([[
    function! TabMessage(cmd)
        redir => message
        silent execute a:cmd
        redir END
    if empty(message)
        echoerr "no output"
    else
        " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
        " tabnew
        new
        setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
        setlocal filetype=notify
        silent put=message
        endif
    endfunction
    command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)
]], false)
