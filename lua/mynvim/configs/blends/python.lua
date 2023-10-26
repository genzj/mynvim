return {
	nls = {
		"null_ls.builtins.diagnostics.mypy",
		-- isortd is installed from local registry mynvim.mason.registry
		-- but haven't figured out how to run it as a daemon
		-- "null_ls.builtins.formatting.isortd",
		"null_ls.builtins.formatting.isort",
	},
	mason = {
		"isort",
		"mypy",
	},
	servers = {
		["pylsp"] = {},
	},
}
