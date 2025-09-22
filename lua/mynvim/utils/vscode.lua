local M = {}

M.vscode_plugins = {
      "flit.nvim",
      "lazy.nvim",
      "leap.nvim",
      "mini.ai",
      "mini.comment",
      "mini.pairs",
      "mini.surround",
      "nvim-treesitter",
      "nvim-treesitter-textobjects",
      "nvim-ts-context-commentstring",
      "vim-repeat",
}

---@param spec LazyPlugin
function M.filter_vscode_plugins(spec)
    if vim.g.vscode then
        for _, value in ipairs(M.vscode_plugins) do
            if spec.name == value or spec.url:find(value .. "$") or spec.url:find(value .. ".git$") then
                return true
            end
        end
        return false
    else
        return true
    end
end

return M
