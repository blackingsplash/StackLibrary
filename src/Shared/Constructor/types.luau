export type Node<T> = {
	data: T,
	next: Node<T>?,
}

export type LinkedList = {
	top: Node<any>?,
	bottom: Node<any>?,
	height: number, -- replace with t.positiveInteger

	new: (v: any) -> LinkedList,
	push: (self: LinkedList, v: any) -> (),
	pop: (self: LinkedList) -> (),
	peek: (self: LinkedList) -> (),

	__add: (t: { [string]: unknown }, v: LinkedList) -> LinkedList,
}

export type WeakLinkedList = {
	top: Node<any>?,
	bottom: Node<any>?,
	height: number, -- replace with t.positiveInteger

	new: (v: any) -> WeakLinkedList,
	push: (self: WeakLinkedList, v: any) -> (),
	pop: (self: WeakLinkedList) -> (),
	peek: (self: WeakLinkedList) -> (),

	__add: (t: { [string]: unknown }, v: WeakLinkedList) -> WeakLinkedList,
	__mode: "k" | "v" | "kv",
}

export type SchematizedLinkedList<T> = {
	top: Node<T>?,
	bottom: Node<T>?,
	height: number, -- replace with t.positiveInteger

	new: (v: T) -> SchematizedLinkedList<T>,
	push: (self: SchematizedLinkedList<T>, v: any) -> (),
	pop: (self: SchematizedLinkedList<T>) -> (),
	peek: (self: SchematizedLinkedList<T>) -> (),

	__add: (t: { [string]: unknown }, v: SchematizedLinkedList<T>) -> SchematizedLinkedList<T>,
}

return {}
