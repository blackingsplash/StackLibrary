--!optimize 2
local types_mod = require("./Constructor/types")
local global_conf = require("./Constructor/configtemplate")

type StackConfig = types_mod.GlobalConfig
type LinkedList = types_mod.LinkedList
type ConstructorNode = types_mod.Node
type Constructor = types_mod.Stack

local node = require("./Constructor/node")
local valid_config = require("./Constructor/configutils")

local table_freeze = table.freeze
local check, treat = valid_config.check, valid_config.treat

local function new(v: unknown, conf: StackConfig?): LinkedList
	if conf then
		local succ: boolean, result: string = treat(conf)
		if not succ then
			error(result)
		end
	end

	conf = conf or global_conf

	local curr = node(v)
	local nodeLimit, maxSizePerNode = conf["NodeLimit"], conf["MaxByteSizePerNode"]

	return {
		top = curr :: ConstructorNode,
		height = 1 :: number,

		maxNodeAmount = nodeLimit :: number,
		maxByteSizePerNode = maxSizePerNode :: number,

		locked = false :: boolean,
		isfrozen = false :: boolean,
	}
end

local function push(s: Constructor, v: unknown): ()
	if check(type(v)) then
		error(`expected a valid primitive whitelisted datatype, got {typeof(v)}`)
	end
	if s.locked or s.isfrozen then
		error("stack is already locked/frozen by another thread; push method is invalid.")
	end
	if s.height + 1 > s.maxNodeAmount then
		error("max amount of nodes exceeded. try popping.")
	end

	local curr = node(v)
	if s.height > 0 then
		curr.next = s.top
		s.top = curr
	else
		s.top = curr
	end
	s.height += 1
end

local function pop(s: Constructor): unknown
	if s.height == 0 or not s.top then
		error("no nodes to pop in stack")
	end
	if s.locked or s.isfrozen then
		error("stack is already locked/frozen by another thread; pop method is invalid.")
	end
	if s.height == 1 then
		s.top = nil
		return nil
	end

	s.locked = true

	local res: ConstructorNode? = s.top
	s.top = s.top.next
	res.next = nil
	s.height -= 1

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

local function deepClean(s: Constructor): ()
	if s.locked or s.isfrozen then
		error("stack is already locked/frozen by another thread; clean method is invalid.")
	end

	s.locked = true
	while s.top do
		local next_node = s.top.next
		s.top.data = nil
		s.top.next = nil
		s.top = next_node
	end

	s.top = nil
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

local function some(s: Constructor, p: (v: unknown) -> boolean): boolean
	if s.locked then
		error("stack is already locked by another thread; some method is invalid.")
	end
	if s.height == 0 or not s.top then
		error("no nodes to pop in stack in a deep freeze.")
	end
	s.locked = true

	local curr = s.top
	while curr do
		if p(curr.data) then
			return true
		end
		curr = curr.next
	end

	s.locked = false
	return false
end

return {
	create = new,
	push = push,
	pop = pop,
	peek = peek,
	clear = deepClean,
	freeze = freeze,
	some = some,
} :: Constructor
