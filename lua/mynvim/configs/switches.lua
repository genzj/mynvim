local M = {}

-- use folke/noice.nvim or not
-- currently noice has performance issue and cause crashes to goneovim so it's been disabled
M.use_noice = false

---@alias CompletionProvider "nvim-cmp" | "blink.cmp" | "native"
---@type CompletionProvider
M.cmp_provider = "blink.cmp"

return M
