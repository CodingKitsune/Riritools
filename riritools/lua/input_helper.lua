local table_utils = require("riritools.lua.table_utils")

local input_helper = table_utils.make_read_only_table {
	init = function(obj)
		obj.inputs = {}
	end,

	on_input = function(obj, action_id, ...)
		if (obj.inputs[action_id]) then
			obj.inputs[action_id](obj, ...)
		end
	end,

	add = function(obj, action_id, on_input_function)
		obj.inputs[action_id] = on_input_function
	end
}

return input_helper
