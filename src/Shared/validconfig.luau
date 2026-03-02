local types_mod = require("./Constructor/types")
local global_conf = require("./Constructor/config")

type ValidTypesLibrary = {
	--add: (v: string) -> (),
	remove: (v: string) -> (),
	treat: (v: { types_mod.AcceptedTypes }) -> (boolean, string?),
	check: (v: string) -> boolean,
}

local ValidTypes: { types_mod.AcceptedTypes } = { "string", "number", "boolean", "vector", "buffer", "table" }
local table_find, table_remove, table_insert = table.find, table.remove, table.insert

local function check(v: string): boolean
	if typeof(table.find(ValidTypes, v)) ~= "number" then
		return false
	else
		return true
	end
end

--[[local function add(v: string): ()
	if typeof(table_find(ValidTypes, v)) == "number" then
		return
	end
	table_insert(ValidTypes, v)
end--]]

local function remove(v: string): ()
	if typeof(table_find(v)) ~= "number" then
		return
	end
	local index: number = table_find(v)
	table_remove(ValidTypes, index)
end

local function treat(v: { types_mod.AcceptedTypes }): (boolean, string?)
	for k, j in v do
		if not global_conf[k] or typeof(j) ~= typeof(global_conf[k]) then
			return false,
				`{k} key is not a valid configuration key or is of the wrong type (expected {global_conf[k]}, got {typeof(
					j
				)}}).`
		end
		j = j or global_conf[k]
	end

	for k, j in v["BlacklistedTypes"] do
		if type(j) ~= "string" then
			return false, `only string types are valid to put inside a BlackklistTypes list`
		end
		remove(j)
	end

	return true
end

return {
	--add = add,
	remove = remove,
	treat = treat,
	check = check,
} :: ValidTypesLibrary
