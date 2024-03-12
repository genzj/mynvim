return {
	treesitter = {
		"rust",
	},
	nls = {
	},
	servers = {
		["rust_analyzer"] = {
			settings = {
				["rust-analyzer"] = {
					imports = {
						granularity = {
							group = "module",
						},
						prefix = "self",
					},
					cargo = {
						buildScripts = {
							enable = true,
						},
					},
					procMacro = {
						enable = true,
					},
				},
			},
		},
	},
}
