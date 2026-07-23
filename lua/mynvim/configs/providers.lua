-- Remote-plugin provider setup.
--
-- Only the Python provider is used by this config. Node.js, Perl and Ruby
-- remote-plugin hosts are disabled so `:checkhealth` does not warn about
-- their missing host packages. (This is unrelated to Node/Ruby LSP servers or
-- CLI tools, which do not go through these providers.)

local function detect_venv()
    for _, path in ipairs({
        "$WORKON_HOME/nvim/",
        "~/.venvs/nvim/",
        "$PYENV_ROOT/versions/nvim",
    }) do
        local full_path = vim.fs.normalize(path .. "/bin/python")
        local stat = vim.loop.fs_stat(full_path)
        if stat and stat.type == "file" then
            return full_path
        end
    end
    return nil
end

local function init_python()
    local venv = detect_venv()
    if venv ~= nil then
        vim.g.python3_host_prog = venv
    end
end

local function disable_unused_providers()
    vim.g.loaded_node_provider = 0
    vim.g.loaded_perl_provider = 0
    vim.g.loaded_ruby_provider = 0
end

init_python()
disable_unused_providers()
