export type AcceptedTypes = "string" | "number" | "boolean" | "vector" | "buffer" | "table"

export type GlobalConfig = {
	NodeLimit: number,
	MaxSizePerNode: number,
}

export type Node = {
	data: unknown,
	next: Node?,
}

export type LinkedList = {
	top: Node?,
	height: number,
	maxNodeAmount: number,
	maxByteSizePerNode: number,
	--lastModification: number,
	--changeCount: number,
	-- forceDeepClean: boolean,
	locked: boolean,
	isfrozen: boolean,
}

export type Stack = LinkedList & {
	new: (v: unknown) -> LinkedList,
	push: (self: LinkedList, v: unknown) -> (),
	pop: (self: LinkedList) -> unknown,
	peek: (self: LinkedList) -> Node?,
	clear: (self: LinkedList) -> (),
	freeze: (self: LinkedList, deepFreeze: unknown?) -> (),
}

export type SchematizedLinkedList<T> = {
	top: Node?,
	height: number,
	maxNodeAmount: number,
	maxByteSizePerNode: number,
	registeredType: string?,
	locked: boolean,
	isfrozen: boolean,
}

export type SchematizedStack<T = unknown> = SchematizedLinkedList<T> & {
	new: (v: T) -> SchematizedLinkedList<T>,
	push: (self: SchematizedLinkedList<T>, v: T) -> (),
	pop: (self: SchematizedLinkedList<T>) -> T?,
	peek: (self: SchematizedLinkedList<T>) -> T?,
	clear: (self: SchematizedLinkedList<T>) -> (),
}

return {}
