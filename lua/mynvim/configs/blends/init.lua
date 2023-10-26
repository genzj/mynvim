local M = {}
local blends = {
	"rust",
	"python",
    "cloudformation",
}

local function init()
	for _, name in ipairs(blends) do
		local ok, blend = pcall(require, "mynvim.configs.blends." .. name)
		if ok then
			M[name] = blend
		end
	end
end

init()
return M
