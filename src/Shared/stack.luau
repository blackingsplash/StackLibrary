--!optimize 2
local types_mod = require("./Constructor/types")
local global_conf = require("./Constructor/config")

type AcceptedTypes = types_mod.AcceptedTypes
type StackConfig = types_mod.GlobalConfig
type LinkedList = types_mod.LinkedList
type ConstructorNode = types_mod.Node
type Constructor = types_mod.Stack

local node = require("./Constructor/node")
local valid_config = require("./validconfig")

local table_find, table_freeze = table.find, table.freeze

local function new(v: AcceptedTypes, conf: StackConfig?): LinkedList
	if conf then
		local succ: boolean, result: string = valid_config.treat(conf)
		if not succ then
			error(result)
		end
	end

	if type(v) == "number" then
		v = math.round(v * conf["MaxSizePerNode"]) / conf["MaxSizePerNode"]
	end

	conf = conf or global_conf
	local curr = node(v)
	return {
		top = curr :: ConstructorNode,
		bottom = curr :: ConstructorNode,
		height = 1 :: number,
		maxNodeAmount = conf["NodeLimit"] :: number,
		maxByteSizePerNode = conf["MaxSizePerNode"] :: number,
		precision = conf["NumberPrecisionSnapping"] :: number,
		locked = false :: boolean,
		isfrozen = false :: boolean,
		config = conf :: StackConfig,
	}
end

local function push(s: Constructor, v: any): ()
	if typeof(table_find(s, type(v))) ~= "number" then
		error(`expected a valid whitelisted datatype, got {typeof(v)}`)
	end
	if s.locked or s.isfrozen then
		error("stack is already locked/frozen by another thread; push method is invalid.")
	end
	if s.height + 1 > s.maxNodeAmount then
		error("max amount of nodes exceeded. try popping.")
	end

	if type(v) == "number" then
		v = math.round(v * s.precision) / s.precision
	end

	local curr = node(v)
	if s.height > 0 then
		curr.next = s.top
		s.top = curr
	else
		s.top = curr
		s.bottom = curr
	end
	s.height += 1
end

local function pop(s: Constructor): any
	if s.height == 0 or not s.top then
		error("no nodes to pop in stack")
	end
	if s.locked or s.isfrozen then
		error("stack is already locked/frozen by another thread; pop method is invalid.")
	end

	s.locked = true
	local res: ConstructorNode? = s.top

	s.top = s.top.next
	res.next = nil
	s.height -= 1

	if s.height == 0 then
		self.bottom = nil
	end

	s.locked = false
	return res.data
end

local function peek(s: Constructor): ConstructorNode?
	if s.height == 0 or not s.top then
		return nil
	elseif s.locked then
		error("stack is already locked by another thread; peek method is invalid.")
	else
		return s.top
	end
end

local function clear(s: Constructor): ()
	if s.locked or s.isfrozen then
		error("stack is already locked/frozen by another thread; clear method is invalid.")
	end

	s.locked = true
	while s.top do
		local next_node = s.top.next
		s.top.data = nil
		s.top.next = nil
		s.top = next_node
	end

	s.top = nil
	s.bottom = nil
	s.height = 0
	s.locked = false
end

local function freeze(s: Constructor, deepFreeze: boolean?): ()
	deepFreeze = deepFreeze or false
	local curr = s.top

	if deepFreeze then
		while curr do
			if typeof(curr.data) == "table" then
				table_freeze(curr.data)
			end
			curr = curr.next
		end
	end

	table_freeze(curr.data)
	s.isfrozen = true
end

return {
	create = new,
	push = push,
	pop = pop,
	peek = peek,
	clear = clear,
	freeze = freeze,
} :: Constructor
