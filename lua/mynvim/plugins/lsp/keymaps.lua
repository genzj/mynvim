local M = {}

---@return (LazyKeys|{has?:string})[], (LazyKeys|{has?:string})[]
function M.get(buffer)
  ---@class PluginLspKeys
  -- stylua: ignore
  if M._keys and M._groups then
    return M._keys, M._groups
  end

  M._keys = M._keys or {
    { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
    { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
    { "K", vim.lsp.buf.hover, desc = "Hover" },
    { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
    { "]d", M.diagnostic_goto(true), desc = "Next Diagnostic" },
    { "[d", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
    { "]e", M.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
    { "[e", M.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
    { "]w", M.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
    { "[w", M.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
    { "<leader>cf", M.format, desc = "Format Document", has = "documentFormatting" },
    { "<leader>cf", M.format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
    { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
    { "<leader>ci", vim.diagnostic.open_float, desc = "Line Diagnostics" },
    { "<leader>cr", M.rename, expr = true, desc = "Rename", has = "rename" },
  }
  local ok, telescope = pcall(require, 'telescope.builtin')
  if ok then
    vim.list_extend(M._keys, {
      { "gd", telescope.lsp_definitions, desc = "Goto Definition" },
      { "grr", telescope.lsp_references, desc = "References" },
      { "gri", telescope.lsp_implementations, desc = "Goto Implementation" },
      { "gt", telescope.lsp_type_definitions, desc = "Goto Type Definition" },
    })
  else
    vim.list_extend(M._keys, {
      { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
      { "grr", vim.lsp.buf.references, desc = "References" },
      { "gri", vim.lsp.buf.implementation, desc = "Goto Implementation" },
      { "gt", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
    })
  end
  M._groups = M._groups or {
    { "g", group = "Goto" },
    { "<leader>c", group = "Code actions" },
  }
  return M._keys, M._groups
end

function M.on_attach(client, buffer)
    local Keys = require("lazy.core.handler.keys")
    local keymaps = {} ---@type table<string,LazyKeys|{has?:string}>
    local all_keys, groups = M.get(buffer)
    require('mynvim.utils').keymap.try_add(groups, { buffer = buffer })

    for _, value in ipairs(all_keys) do
        local keys = Keys.parse(value)
        if keys[2] == vim.NIL or keys[2] == false then
            keymaps[keys.id] = nil
        else
            keymaps[keys.id] = keys
        end
    end

    for _, keys in pairs(keymaps) do
        if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
            local opts = Keys.opts(keys)
            ---@diagnostic disable-next-line: no-unknown
            opts.has = nil
            opts.silent = true
            opts.buffer = buffer
            lhs = keys[1] or keys.lhs
            rhs = keys[2] or keys.rhs
            if lhs == nil or rhs == nil then
                error("bad keymap: " .. vim.inspect(keymaps))
            end
            vim.keymap.set(keys.mode or "n", lhs, rhs, opts)
        end
    end
end

function M.rename()
    if pcall(require, "inc_rename") then
        return ":IncRename " .. vim.fn.expand("<cword>")
    else
        -- run in next tick to avoid textlock (probably caused by the which-key)
        vim.schedule(function ()
            vim.lsp.buf.rename()
        end)
    end
end

function M.diagnostic_goto(next, severity)
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        vim.diagnostic.jump({ count = (next and 1 or -1), severity = severity })
    end
end

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0

  vim.lsp.buf.format(vim.tbl_deep_extend("force", {
    bufnr = buf,
    filter = function(client)
      if have_nls then
        return client.name == "null-ls"
      end
      return client.name ~= "null-ls"
    end,
  }, {}))
end

return M
