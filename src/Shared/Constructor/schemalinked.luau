--!strict
--!optimize 2
local types = require("./types")

type Unionized<T,K> = types.JoinedSchematizedLinkedList<T,K>
export type SchematizedLinkedList<T> = types.SchematizedLinkedList<T>
