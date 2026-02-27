export type Node<T> = {
	create: (v: T) -> Node<T>,
	data: T,
	next: Node<T>?,
}

export type LinkedList = {
	top: Node<any>?,
	bottom: Node<any>?,
	height: number, -- replace with t.positiveInteger

	new: (v: any) -> LinkedList,
	push: (self: LinkedList, v: any) -> (),
	pop: (self: LinkedList) -> any,
	peek: (self: LinkedList) -> any,

	__add: (t: LinkedList, v: LinkedList) -> LinkedList,
}

export type SchematizedLinkedList<T> = {
	top: Node<T>?,
	bottom: Node<T>?,
	height: number, -- replace with t.positiveInteger

	new: (v: T) -> SchematizedLinkedList<T>,
	push: (self: SchematizedLinkedList<T>, v: T) -> (),
	pop: (self: SchematizedLinkedList<T>) -> T,
	peek: (self: SchematizedLinkedList<T>) -> T,

	__add: (t: { [string]: unknown }, v: SchematizedLinkedList<T>) -> SchematizedLinkedList<T>,
}

export type function JoinedSchematizedLinkedList(t1: type, t2: type)
	if not t1:is("table") or t2:is("table") then error("arguments expected to be of type table to join.") end
	return types.unionof(t1,t2)
end

return {}
