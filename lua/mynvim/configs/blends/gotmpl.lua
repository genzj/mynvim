return {
	init = function ()
		local directives = vim.treesitter.query.list_directives()
		if directives["inject-go-tmpl!"] == nil then
			vim.treesitter.query.add_directive("inject-go-tmpl!", function(_, _, bufnr, _, metadata)
				if type(bufnr) ~= "number" then
					return
				end

				local fname = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
				local _, _, result_fname, _ = string.find(fname, "(.*%.%a+)(%.%a+)")
				local language = vim.filetype.match({ filename = result_fname })
				if language ~= nil and language ~= "" then
					metadata["injection.language"] = language
				end
			end, {})
		end

		if vim.filetype.match({ filename = 'config.toml.tmpl' }) ~= "gotmpl" then
			vim.filetype.add({
				extension = {
					tmpl = "gotmpl"
				},
			})
		end
	end,
	treesitter = {
		"gotmpl",
	},
	nls = {
	},
	servers = {
		["gopls"] = {},
	},
}
