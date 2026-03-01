local types_mod = require("../Constructor/types")

return table.freeze({
	NodeLimit = 50,
	MaxSizePerNode = 65535,
	BlacklistTypes = {},
	ForceDeepClean = true,
	NumberPrecisionSnapping = 4,
}) :: types_mod.GlobalConfig
