export type Node<T> = {
	create: (v: T) -> Node<T>,
	data: T,
	next: Node<T>?,
}

export type LinkedList = {
	top: Node<any>?,
	bottom: Node<any>?,
	height: number,
	locked: boolean,

	new: (v: any) -> LinkedList,
	push: (self: LinkedList, v: any) -> (),
	pop: (self: LinkedList) -> any,
	peek: (self: LinkedList) -> Node<any>,
}

export type SchematizedLinkedList<T> = {
	top: Node<T>?,
	bottom: Node<T>?,
	height: number,

	new: (v: T) -> SchematizedLinkedList<T>,
	push: (self: SchematizedLinkedList<T>, v: T) -> (),
	pop: (self: SchematizedLinkedList<T>) -> T,
	peek: (self: SchematizedLinkedList<T>) -> T,
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
