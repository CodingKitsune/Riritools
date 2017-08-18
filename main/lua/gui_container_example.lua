local class = require("riritools.lua.class")
local gui_container = require("riritools.lua.gui_container")
local gui_button = require("riritools.lua.gui_button")

local example = class("rt.gui_container_example", gui_container)

function example:__initialize(name, params, parent)
	gui_container.__initialize(self, name, params, parent)
	self.__button = gui_button:new("button", nil, self)
end

function example:setup(options)
	gui_container.setup(self, options)
	self.__button:setup()
	self.__button.released_function = function()
		pprint("DOING STUFF")
	end
end

function example:update(dt)
	gui_container.update(self, dt)
	self.__button:update(dt)
end

function example:on_non_moving_input(action_id, action)
	self.__button:on_input(action_id, action)
end

function example:on_message(message_id, message, sender)
	gui_container.on_message(self, message_id, message, sender)
	self.__button:on_message(self, message_id, message, sender)
end

return example