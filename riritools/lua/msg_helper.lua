local table_utils = require("riritools.lua.table_utils")

local msg_helper = table_utils.make_read_only_table {

	init = function(obj)
		obj.messages = {}
	end,

	on_message = function(obj, message_id, ...)
		if (obj.messages[message_id]) then
			obj.messages[message_id](obj, ...)
		end
	end,

	add = function(obj, message_id, on_message_function)
		obj.messages[message_id] = on_message_function
	end
}

return msg_helper
