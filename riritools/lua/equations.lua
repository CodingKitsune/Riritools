local table_utils = require("riritools.lua.table_utils")

local equations = table_utils.make_read_only_table {
	pythagorian_theorem = "math.sqrt(@a*@a+@b*@b)",
	rectange_area = "@w*@h",
	square_area = "@s*@s",
	circle_area = "math.pi*@r*@r",
	cube_volume = "@s*@s*@s",
}

return equations
