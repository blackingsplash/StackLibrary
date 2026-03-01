--!optimize 2
local types_mod: {} = require("./Constructor/types")
local global_conf: {} = require("./Config/config")

type AcceptedTypes = types_mod.AcceptedTypes
type StackConfig = types_mod.GlobalConfig
type ConstructorNode = types_mod.Node
type Constructor = types_mod.LinkedList
type Stack = {
	create: (v: any) -> Constructor,
	push: (s: Constructor, v: any) -> (),
	pop: (s: Constructor) -> any,
	peek: (s: Constructor) -> ConstructorNode,
}

local node: (v: any) -> ConstructorNode = require("./Constructor/node")

local function verifyInputType(v: AcceptedTypes) end

local function verifyConstructorConfig(conf: StackConfig): (boolean, string?)
	for k, v in conf do
		if not global_conf[k] then
			return false, `{k} key in config params is non-existent.`
		end
		if v ~= nil and typeof(v) ~= typeof(global_conf[k]) then
			return false, `{typeof(global_conf[k])} expected, got {typeof(v)} for key: {k}`
		end
		v = v or global_conf[k]
	end
	return true
end

local function new(v: AcceptedTypes, conf: StackConfig?): Constructor
	if conf then
		local succ: boolean, result: string = verifyConstructorConfig(conf)
		if not succ then
			error(result)
		end
	end

	conf = conf or global_conf
	local curr: ConstructorNode = node(v)
	return {
		top = curr :: ConstructorNode,
		bottom = curr :: ConstructorNode,
		height = 0 :: number,
		locked = false :: boolean,
		config = conf :: StackConfig,
	}
end

local function push(s: Constructor, v: any): ()
	if v == nil then
		error(`expected a primitive datatype, got {typeof(v)}`)
	end
	if s.locked then
		error("stack is already locked by another thread; push method is invalid.")
	end

	local curr: ConstructorNode = node(v)
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
	if s.locked then
		error("stack is already locked by another thread; pop method is invalid.")
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
	if s.locked then
		error("stack is already locked by another thread; clear method is invalid.")
	end

	s.locked = true
	while s.top.next do
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

return {
	create = new,
	push = push,
	pop = pop,
	peek = peek,
	clear = clear,
} :: Stack
