--!optimize 2
local types_mod: {} = require("./Constructor/types")
local global_conf: {} = require("./Config/config")
local node: (v: any) -> ConstructorNode<> = require("./Constructor/node")
local t = require("./Packages/t")

export type ConstructorNode<K = any> = types_mod.Node<K>
export type Constructor = types_mod.LinkedList
export type GlobalConfig = {} --types_mod.keyof(global_conf.GlobalConfig)
export type Stack = {
	new: (v: any) -> Constructor,
	push: (s: Constructor, v: any) -> (),
	pop: (s: Constructor) -> any,
	peek: (s: Constructor) -> ConstructorNode<>,
}

local function new(v: any, conf: GlobalConfig?): Constructor
	local curr: ConstructorNode<> = node(v)
	return {
		top = curr :: ConstructorNode<>,
		bottom = curr :: ConstructorNode<>,
		height = 0 :: number,
		locked = false :: boolean,
		config = if conf then conf else global_conf :: { [string]: number | string },
	}
end

local function push(s: Constructor, v: any): ()
	if not t.any(v) then
		error(`expected type notnil, got {typeof(v)}`)
	end
	if s.locked then
		error("stack is already locked by another thread; push method is invalid.")
	end

	local curr: ConstructorNode<> = node(v)
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
	local res: ConstructorNode<>? = s.top

	s.top = s.top.next
	res.next = nil
	s.height -= 1

	if s.height == 0 then
		self.bottom = nil
	end

	s.locked = false
	return res.data
end

local function peek(s: Constructor): ConstructorNode<>?
	if s.height == 0 or not s.top then
		return nil
	elseif s.locked then
		error("stack is already locked by another thread; peek method is invalid.")
	else
		return s.top
	end
end

return {
	new = new,
	push = push,
	pop = pop,
	peek = peek,
} :: Stack
