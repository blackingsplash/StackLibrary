local types_mod = require("./Constructor/types")
local global_conf = require("./Constructor/config")

type ValidTypesLibrary = {
	add: (v: string) -> (),
	remove: (v: string) -> (),
	treat: (v: { types_mod.AcceptedTypes }) -> (boolean, string?),
	check: (v: string) -> boolean,
}

local ValidTypes: { types_mod.AcceptedTypes } = { "string", "number", "boolean", "vector", "buffer", "table" }

local function check(v: string): boolean
	if typeof(table.find(ValidTypes, v)) ~= "number" then
		return false
	else
		return true
	end
end

local function add(v: string): ()
	if typeof(table.find(ValidTypes, v)) == "number" then
		return
	end
	ValidTypes[#ValidTypes + 1] = v
end

local function remove(v: string): ()
	if typeof(table.find(v)) ~= "number" then
		return
	end
	local index: number = table.find(v)
	table.remove(ValidTypes, index)
end

local function treat(v: { types_mod.AcceptedTypes }): (boolean, string?) end

return {
	add = add,
	remove = remove,
	treat = treat,
	check = check,
} :: ValidTypesLibrary
