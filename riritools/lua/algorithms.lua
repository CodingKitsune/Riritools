local table_utils = require("riritools.lua.table_utils")

local pairs = pairs

local algorithm = table_utils.make_read_only_table {
	greater_than = function(number1, number2)
		return number1 > number2
	end,

	greater_equals_than = function(number1, number2)
		return number1 >= number2
	end,

	lesser_than = function(number1, number2)
		return number1 < number2
	end,

	lesser_equals_than = function(number1, number2)
		return number1 <= number2
	end,

	equals_to = function(number1, number2)
		return number1 == number2
	end,

	different_than = function(number1, number2)
		return number1 ~= number2
	end,

	is_in = function(number, list)
		for _, value in pairs(list) do
			if (value == number) then
				return true
			end
		end
		return false
	end,

	is_not_in = function(number, list)
		for _, value in pairs(list) do
			if (value == number) then
				return false
			end
		end
		return true
	end,

	is_between = function(number, range)
		return (number > range[1] and number < range[2] )
	end,

	is_between_inclusive = function(number, range)
		return (number >= range[1] and number <= range[2] )
	end,

	is_point_inside_rect = function(point, rect)
		return (point.x >= rect.x
			and point.y >= rect.y
			and point.x <= (rect.x + rect.width)
			and point.y <= (rect.y + rect.height))
	end
}

return algorithm
