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

init_python()
