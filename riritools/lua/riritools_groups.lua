local table_utils = require("riritools.lua.table_utils")

local groups = table_utils.make_read_only_table {
	GROUP_WORLD = hash("world"),
	GROUP_LEVEL0 = hash("level0"),
	GROUP_BULLET = hash("bullet"),
	GROUP_PLAYER = hash("player")
}

return groups
