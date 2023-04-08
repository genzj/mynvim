local M = {}

local function remove_token(s, token)
    local removed = s:gsub(token, '')

    return removed, removed ~= s
end

local function extract_special_args(lhs, opts)
    lhs, opts.silent = remove_token(lhs, '<silent>')
    lhs, opts.expr = remove_token(lhs, '<expr>')
    return lhs, opts
end

local function extract_remap(cmd, opts)
    local noremap_replaced = cmd:gsub('noremap', 'map')
    opts.remap = (noremap_replaced == cmd)
    opts.noremap = not opts.remap
    return noremap_replaced, opts
end

local function extract_mode(cmd)
    if cmd == 'map' then
        -- empty string for map
        return ''
    elseif cmd == 'map!' then
        return '!'
    elseif cmd:match('[nvsxoilct]map') then
        -- otherwise the first char of cmd specifies the mode
        return cmd:sub(1, 1)
    end

    error('invalid keymap cmd ' .. cmd)
end

function M.group(prefix, name)
    M.try_register({
        [prefix] = {
            name=name
        },
    })
end

function M.try_register(...)
    local ok, wk = pcall(require, "which-key")
    if ok then
        return wk.register(...)
    end
    return nil
end

function M.set(cmd, lhs, rhs, desc, opts)
    opts = vim.deepcopy(opts or {})

    cmd, opts = extract_remap(cmd, opts)
    lhs, opts = extract_special_args(lhs, opts)
    local mode = extract_mode(cmd)

    if desc and not opts.desc then
        opts.desc = desc
    end

    -- print(vim.inspect({
    --     mode = mode,
    --     lhs = lhs,
    --     rhs = rhs,
    --     opts = opts,
    -- }))
    return vim.keymap.set(mode, lhs, rhs, opts)
end

return M
