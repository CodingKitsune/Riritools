local table_utils = require("riritools.lua.table_utils")

local vector3 = vmath.vector3
local vector4 = vmath.vector4
local max = math.max
local min = math.min

local vector = table_utils.make_read_only_table {
	NULL_VECTOR3 = vector3(),
	NULL_VECTOR4 = vector4(),
	UNIT_VECTOR3 = vector3(1),
	UNIT_VECTOR4 = vector4(1),

	move_to = function(vector, x, y, speed)
		local result = 0
		if (vector.x < x) then
			vector.x = min(vector.x + speed, x)
		elseif (vector.x > x) then
			vector.x = max(vector.x - speed, x)
		else
			result = result + 1
		end
		if (vector.y < y) then
			vector.y = min(vector.y + speed, y)
		elseif (vector.y > y) then
			vector.y = max(vector.y - speed, y)
		else
			result = result + 1
		end
		return (result == 2)
	end,

	vector3_to_table = function(vector)
		return {x=vector.x, y=vector.y, z=vector.z}
	end,

	vector4_to_table = function(vector)
		return {x=vector.x, y=vector.y, z=vector.z, w=vector.w}
	end,

	table_to_vector3 = function(table)
		return vector3(table.x, table.y, table.z)
	end,

	table_to_vector4 = function(table)
		return vector4(table.x, table.y, table.z, table.w)
	end,

	vector3_to_vector4 = function(vector3_instance)
		return vector4(vector3_instance.x, vector3_instance.y, vector3_instance.z, 0)
	end,

	vector3_to_vector4_normalized = function(vector3_instance)
		return vector4(vector3_instance.x, vector3_instance.y, vector3_instance.z, 1)
	end,

	vector4_to_vector3 = function(vector4_instance)
		return vector3(vector4_instance.x, vector4_instance.y, vector4_instance.z)
	end,
}

return vector
