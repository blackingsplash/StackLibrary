local types_mod = require("./types")

return table.freeze({
	NodeLimit = 50,
	MaxSizePerNode = 65535,
	BlacklistTypes = {},
	ForceDeepClean = true,
	NumberPrecisionSnapping = 4,
}) :: types_mod.GlobalConfig
