--!optimize 2
local types_mod = require("./Constructor/types")
local global_conf = require("./Constructor/configtemplate")

type SchematizedLinkedList<T> = types_mod.SchematizedLinkedList<T>
type StackConfig = types_mod.GlobalConfig
type LinkedList = types_mod.LinkedList
type ConstructorNode = types_mod.Node
type Constructor<T = unknown> = types_mod.SchematizedStack<>

local node = require("./Constructor/node")
local valid_config = require("./Constructor/configutils")

local table_freeze = table.freeze

--[=[
    @function push
    @within Stack

    @param v -- the first value to push to the new stack. Cannot be nil. This will be the determinant of your other nodes.
    @param conf -- the configuration unique to this SchematizedStack.
    @return LinkedList
]=]
local function new(v: unknown, conf: StackConfig?): LinkedList
	if conf then
		local succ: boolean, result: string = valid_config.treat(conf)
		if not succ then
			error(result)
		end
	end
	conf = conf or global_conf

	local curr = node(v)
	local nodeLimit, maxSizePerNode = conf["NodeLimit"], conf["MaxSizePerNode"]
	return {
		top = curr :: ConstructorNode,

		height = 0 :: number,
		maxNodeAmount = nodeLimit :: number,
		maxByteSizePerNode = maxSizePerNode :: number,

		registeredType = type(v) :: string?,

		locked = false :: boolean,
		isfrozen = false :: boolean,
	}
end

--[=[
    @function push
    @within Stack

    @param Stack -- the stack to push the node to
    @param v -- the value that will be pushed. In a SchematizedStack, this should always be the same type as the other nodes or it will error.
    @return ()
]=]
local function push(s: Constructor<>, v: unknown): ()
	if type(v) ~= s.registeredType then
		error(`expected the same type as other data, got {typeof(v)}`)
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
		s.registeredType = type(curr.data)
	end
	s.height += 1
end

--[=[
    @function pop
    @within Stack

    @param Stack -- the stack to pop the last node of. O(1) operation.
    @return v -- the popped node's data.

	@note If there are no nodes within the stack, it will return an error. If this method pops the last node, the registeredType of this stack will change.
]=]
local function pop(s: Constructor): unknown
	if s.height == 0 or not s.top then
		error("no nodes to pop in stack")
	end
	if s.locked or s.isfrozen then
		error("stack is already locked/frozen by another thread; pop method is invalid.")
	end
	if s.height == 1 then
		s.top = nil
		s.registeredType = nil
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

--[=[
    @function peek
    @within Stack

    @param Stack -- the stack to peek the last node of. O(1) operation.
    @return ()

	@note If there are no nodes within the stack, it will return nil.
]=]
local function peek(s: Constructor): ConstructorNode?
	if s.locked then
		error("stack is already locked by another thread; peek method is invalid.")
	end
	if s.height == 0 or not s.top then
		error("no nodes to peek at in stack")
	end

	s.locked = true

	if s.height == 0 or not s.top then
		s.locked = false
		return nil
	elseif s.locked then
		error("stack is already locked by another thread; peek method is invalid.")
	else
		s.locked = false
		return s.top
	end
end

--[=[
    @function clear
    @within Stack

    @param Stack -- the stack to clear the nodes of.
    @return ()

	@note This method deletes all node links and data. It completely resets it. Will not work if it is frozen. O(n) operation at Omega(1).
]=]
local function clear(s: Constructor): ()
	if s.locked or s.isfrozen then
		error("stack is already locked/frozen by another thread; clear method is invalid.")
	end
	if s.height == 0 or not s.top then
		return nil
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
	return nil
end

--[=[
    @function freeze
    @within Stack

    @param Stack -- the stack to freeze
    @param deepFreeze: boolean? -- Chooses if the freeze will be a shallow or a deep freeze. Defaults to false.
    @return ()

	@note A shallow freeze is O(1) and a deep freeze is O(n). It will error if there are no nodes.
]=]
local function freeze(s: Constructor, deepFreeze: boolean?): ()
	if s.locked or s.frozen then
		error("stack is already locked/frozen by another thread; freeze method is invalid.")
	end
	if s.height == 0 or not s.top then
		error("no nodes to pop in stack in a deep freeze.")
	end
	s.locked = true

	deepFreeze = deepFreeze or false
	local curr = s.top

	if deepFreeze then
		while curr do
			if type(curr.data) == "table" then
				table_freeze(curr.data)
			end
			curr = curr.next
		end
	end

	table_freeze(curr.data)
	s.isfrozen = true
	s.locked = false
end

--[=[
    @function some
    @within Stack

    @param Stack -- the stack to perform the predicate on each node
    @param predicate ((v: AcceptedTypes) -> boolean) -- the function that will be ran on each node, should return a boolean value. In a SchematizedStack, v should always be the same type as the other nodes or it will error.
    @return boolean -- returns wether at least one of the keys passed the predicate

    @note The parameter of the predicate function will be the same type as all the other node data. If there are no nodes within the stack, it will return nil.
]=]
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
	clear = clear,
	freeze = freeze,
	some = some, -- credits to yoda's Magnus module for the idea, code is made by me though
} :: Constructor
