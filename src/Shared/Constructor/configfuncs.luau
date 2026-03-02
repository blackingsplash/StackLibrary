local types_mod = require("./types")
local global_conf = require("./configtemplate")

type AcceptedTypes = types_mod.AcceptedTypes

type ValidTypesLibrary = {
	check: (v: string) -> boolean,
	add: (v: AcceptedTypes) -> (),
	remove: (v: AcceptedTypes) -> (),
	treat: (v: { AcceptedTypes }) -> (boolean, string?),
}

local ValidTypes: { AcceptedTypes } = { "string", "number", "boolean", "vector", "buffer", "table" }
local table_find, table_remove, table_insert = table.find, table.remove, table.insert

local function check(v: string): boolean
	if type(table.find(ValidTypes, v)) ~= "number" then
		return false
	else
		return true
	end
end

local function add(v: AcceptedTypes): ()
	if type(table_find(ValidTypes, v)) == "number" then
		return
	end
	table_insert(ValidTypes, v)
end

local function remove(v: AcceptedTypes): ()
	if type(table_find(ValidTypes, v)) ~= "number" then
		return
	end
	local index: number = table_find(v)
	table_remove(ValidTypes, index)
end

local function treat(v: { AcceptedTypes }): (boolean, string?)
	for k, j in v do
		if not global_conf[k] or type(j) ~= type(global_conf[k]) then
			return false,
				`{k} key is not a valid configuration key or is of the wrong type (expected {global_conf[k]}, got {typeof(
					j
				)}}).`
		end
		j = j or global_conf[k]
	end

	return true
end

return {
	check = check,
	add = add,
	remove = remove,
	treat = treat,
} :: ValidTypesLibrary
