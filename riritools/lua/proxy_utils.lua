local table_utils = require("riritools.lua.table_utils")

local url = msg.url

local proxy_utils = table_utils.make_read_only_table {
	get_initializer_from_level = function(level_name)
		return url(level_name..":/initializer")
	end,

	get_proxy_from_level = function(level_name)
		return url("main:/levels#"..level_name)
	end,

	get_gui_from_screen = function(screen_name)
		return url(screen_name..":/gui#gui")
	end,

	get_proxy_from_screen = function(screen_name)
		return url("main:/screens#"..screen_name)
	end
}

return proxy_utils
