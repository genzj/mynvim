local util = require("mason-registry.sources.util")
local package = require("mason-core.package")

local spec = util.map_registry_spec({
    schema = "registry+v1",
	name = "isortd",
    description = [[isortd is a small HTTP server that exposes isort's functionality
over a simple protocol. The main benefit of using it is to avoid the cost of
starting up a new isort process every time you want to format a file.]],
	homepage = "https://pypi.org/project/isortd",
	licenses = { "MIT" },
	languages = { "Python" },
	categories = { "Formatter" },
	source = { id = "pkg:pypi/isortd@0.1.7" },
	bin = { isortd = "pyvenv:isortd" },
})

return package.new(spec:get())
