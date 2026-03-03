local types_mod = require("./types")

return function(v)
	return {
		data = v :: unknown,
		next = nil :: types_mod.Node?,
	} :: types_mod.Node
end
