local fallback_filetype = {
	html = "html",
}

local function get_injected_ext(filename)
	-- Remove any path components, keep only the filename
	local basename = vim.fn.fnamemodify(filename, ":t")

	-- Split by dots
	local parts = vim.split(basename, ".", { plain = true })

	-- If we have at least 2 parts (name + n*extensions), return the second to last
	-- If we have 1 part (no extension), return empty string
	if #parts >= 2 then
		return parts[#parts - 1]
	else
		return "" -- no extension
	end
end

return {
	init = function()
		local directives = vim.treesitter.query.list_directives()
		if directives["inject-go-tmpl!"] == nil then
			vim.treesitter.query.add_directive("inject-go-tmpl!", function(_, _, bufnr, _, metadata)
				if type(bufnr) ~= "number" then
					return
				end

				local fname = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
				local _, _, base_fname, _ = string.find(fname, "(.*)(%.%a+)")
				if base_fname == nil or base_fname == "" then
					return
				end

				local language = vim.filetype.match({ filename = base_fname })
				-- print("base_fname=" .. base_fname .. " current injection language: " .. (language == nil and "" or language))

				if language == nil or language == "" then
					local ext = get_injected_ext(fname)
					language = fallback_filetype[ext]
					-- print("base_fname=" .. base_fname .. " ext=" .. ext .. " current injection language: " .. (language == nil and "" or language))
				end

				if language ~= nil and language ~= "" then
					metadata["injection.language"] = language
				end
			end, {})
		end

		if vim.filetype.match({ filename = "config.toml.tmpl" }) ~= "gotmpl" then
			vim.filetype.add({
				extension = {
					tmpl = "gotmpl",
				},
			})
		end
	end,
	treesitter = {
		"gotmpl",
	},
	nls = {},
	servers = {
		["gopls"] = {},
	},
}
