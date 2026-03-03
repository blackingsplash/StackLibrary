local types_mod = require("./types")

return table.freeze({
	NodeLimit = 50,
	MaxByteSizePerNode = 65535,
}) :: types_mod.GlobalConfig
