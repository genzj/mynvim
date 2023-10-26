return {
	nls = {
		"null_ls.builtins.diagnostics.cfn_lint",
		"null_ls.builtins.diagnostics.yamllint",
	},
	mason = {
		"yamllint",
		"cfn-lint",
	},
	servers = {
		["yamlls"] = {
			settings = {
				yaml = {
					format = {
						enable = true,
						singleQuote = true,
					},
					schemas = {
						["https://s3.amazonaws.com/cfn-resource-specifications-us-east-1-prod/schemas/2.15.0/all-spec.json"] = "*-template.yaml",
					},
					customTags = {
						"!And scalar",
						"!If scalar",
						"!Not",
						"!Equals scalar",
						"!Or scalar",
						"!FindInMap scalar",
						"!Base64",
						"!Cidr",
						"!Ref",
						"!Sub",
						"!GetAtt sequence",
						"!GetAZs",
						"!ImportValue sequence",
						"!Select sequence",
						"!Split sequence",
						"!Join sequence",
					},
				},
			},
		},
	},
}
