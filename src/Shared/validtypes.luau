local types_mod = require("./Constructor/types")
local global_config = require("./Constructor/config")

type ValidTypesLibrary = {
	add: (v: string) -> (),
	remove: (v: string) -> (),
	treat: (v: { types_mod.AcceptedTypes }) -> (),
	check: (v: any) -> (boolean, string?),
}

local ValidTypes: { types_mod.AcceptedTypes } = { "string", "number", "boolean", "vector", "buffer", "thread" }

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

local function treat(v: { types_mod.AcceptedTypes }): () end

local function check(v: any): () end

return {
	add = add,
	remove = remove,
	treat = treat,
	check = check,
} :: ValidTypesLibrary
