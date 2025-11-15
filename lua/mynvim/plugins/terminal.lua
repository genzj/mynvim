return {
    "akinsho/toggleterm.nvim",
    keys = {
        { [[<c-`>]], desc="Toggle terminal window" },
        -- { "<leader>yt", "<cmd>ToggleTermSendCurrentLine<cr>", mode = "n", desc = "sends the whole line where you are standing with your cursor to the terminal" },
        -- { "<leader>yt", "<cmd>ToggleTermSendVisualSelection<cr>", mode = "v", desc = "sends the visually selected text to the terminal" },
    },
    opts = {
        open_mapping = [[<c-`>]],
    },
    config = function (_, opts)
        require('toggleterm').setup(opts)
        vim.api.nvim_create_autocmd(
            "TermOpen",
            {
                group = vim.api.nvim_create_augroup("MyNVimTerm", {
                    clear = true,
                }),

                pattern = "term://*",
                callback = function ()
                    local kopts = {buffer = 0}
                    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], kopts)
                end,
            }
        )
    end
}
