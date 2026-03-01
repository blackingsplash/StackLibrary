export type AcceptedTypes = "string" | "number" | "boolean" | "vector" | "buffer" | "thread"

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
	locked: boolean,
	config: GlobalConfig,

	new: (v: AcceptedTypes) -> LinkedList,
	push: (self: LinkedList, v: AcceptedTypes) -> (),
	pop: (self: LinkedList) -> AcceptedTypes?,
	peek: (self: LinkedList) -> Node?,
	clear: (self: LinkedList) -> (),
}

export type SchematizedLinkedList<T = AcceptedTypes> = {
	top: Node?,
	bottom: Node?,
	height: number,
	locked: boolean,
	config: GlobalConfig,

	new: (v: T) -> SchematizedLinkedList<T>,
	push: (self: SchematizedLinkedList<T>, v: T) -> (),
	pop: (self: SchematizedLinkedList<T>) -> T?,
	peek: (self: SchematizedLinkedList<T>) -> T?,
	clear: (self: SchematizedLinkedList<T>) -> (),
}

export type function JoinedSchematizedLinkedList(t1: type, t2: type)
	if not t1:is("table") or t2:is("table") then
		error("arguments expected to be of type table to join.")
	end
	return types.unionof(t1, t2)
end

export type function keyof(t1: type)
	if not t1:is("table") then
		error(`table expected, got {t1}`)
	end

	local union = nil
	for property in t1:properties() do
		union = if union then types.unionof(union, property) else property
	end

	return if union then union else types.singleton(nil)
end

return {}
