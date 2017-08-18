local screen_connector_manager = require("riritools.lua.screen_connector_manager")
local table_utils = require("riritools.lua.table_utils")

local connectors = screen_connector_manager.static.connectors
local global_connectors = screen_connector_manager.static.global_connectors
local shallow_copy = table_utils.make_shallow_copy

local connector_manager = {
	register_connector = function(connector)
		connectors[connector.screen] = connector
	end,

	register_global_connector = function(connector)
		table.insert(global_connectors, connector)
	end,

	unregister_connector = function(connector)
		connectors[connector.screen] = nil
		screen_connector_manager.static.connectors = shallow_copy(connectors)
	end,

	unregister_global_connector = function(connector)
		table.remove(connector)
	end,
}

return connector_manager
