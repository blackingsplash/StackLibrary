local types_mod = require("./types")

return table.freeze({
	NodeLimit = 50,
	MaxSizePerNode = 65535,
	ForceDeepClean = true,
}) :: types_mod.GlobalConfig
