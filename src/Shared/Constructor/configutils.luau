local types_mod = require("./types")
local global_conf = require("./configtemplate")

type AcceptedTypes = types_mod.AcceptedTypes

type ValidTypesLibrary = {
	check: (v: string) -> boolean,
	treat: (v: { [string]: unknown }) -> (boolean, string?),
	calculateBytes: (v: any) -> number,
}

local ByteFuncs: { [AcceptedTypes]: (v: unknown) -> number } = {
	["string"] = function(v: string): number
		return string.len(v)
	end,
	["boolean"] = function(v: boolean): number
		return 1
	end,
	["number"] = function(v: number): number
		return 8
	end,
	["vector"] = function(v: vector): number
		return 12
	end,
	["table"] = function(v): number end,
	["buffer"] = function(v: buffer): number
		return buffer.len(v)
	end,
}

local function check(v: { [string]: unknown }): boolean
	if typeof(ByteFuncs[v]) == "function" then
		return true
	else
		return false
	end
end

local function treat(v): (boolean, string?)
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

local function calculateBytes(v: any): boolean end

return {
	check = check,
	treat = treat,
	calculateBytes = calculateBytes,
} :: ValidTypesLibrary
