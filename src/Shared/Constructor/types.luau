export type AcceptedTypes = "string" | "number" | "boolean" | "vector" | "buffer" | "table"

export type GlobalConfig = {
	NodeLimit: number,
	MaxSizePerNode: number,
	BlacklistTypes: { AcceptedTypes },
	ForceDeepClean: boolean,
	NumberPrecisionSnapping: number,
}

export type Node = {
	data: AcceptedTypes,
	next: Node?,
}

export type LinkedList = {
	top: Node?,
	bottom: Node?,
	height: number,
	maxNodeAmount: number,
	maxByteSizePerNode: number,
	precision: number,
	locked: boolean,
	isfrozen: boolean,
	config: GlobalConfig,
}

export type Stack = LinkedList & {
	new: (v: AcceptedTypes) -> LinkedList,
	push: (self: LinkedList, v: AcceptedTypes) -> (),
	pop: (self: LinkedList) -> AcceptedTypes?,
	peek: (self: LinkedList) -> Node?,
	clear: (self: LinkedList) -> (),
	freeze: (self: LinkedList, deepFreeze: boolean?) -> (),
}

export type SchematizedLinkedList<T = AcceptedTypes> = {
	top: Node?,
	bottom: Node?,
	height: number,
	maxNodeAmount: number,
	maxByteSizePerNode: number,
	precision: number,
	registeredType: string,
	locked: boolean,
	config: GlobalConfig,
}

export type SchematizedStack<T = AcceptedTypes> = SchematizedLinkedList<T> & {
	new: (v: T) -> SchematizedLinkedList<T>,
	push: (self: SchematizedLinkedList<T>, v: T) -> (),
	pop: (self: SchematizedLinkedList<T>) -> T?,
	peek: (self: SchematizedLinkedList<T>) -> T?,
	clear: (self: SchematizedLinkedList<T>) -> (),
}

return {}
