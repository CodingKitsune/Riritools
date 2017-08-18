local class = require("riritools.lua.class")
local gui_bar = require("riritools.lua.gui_bar")
local gui_clickable_mixin = require("riritools.lua.gui_clickable_mixin")

local draggable_bar = class("rt.gui_draggable_bar", gui_bar)

function draggable_bar:__initialize(name, params, parent)
	gui_bar.__initialize(self, name, params, parent)
	self.__is_reverse = params and params.is_reverse or false
	self.set_value_function = nil
end

function draggable_bar:on_input(action_id, action)
	if (self.__is_active and (action.pressed or action.repeated)) then
		local how_much = self:__how_much_inside_component(action_id, action, self.__outer_bar)
		if (how_much.x > -1 and self.set_value_function) then
			if (self.__is_vertical) then
				if (self.__is_reverse) then
					self.set_value_function(self.target, (1.0 - how_much.y) * self.max_value)
				else
					self.set_value_function(self.target, how_much.y * self.max_value)
				end
			else
				if (self.__is_reverse) then
					self.set_value_function(self.target, (1.0 - how_much.x) * self.max_value)
				else
					self.set_value_function(self.target, how_much.x * self.max_value)
				end
			end
		end
	end
end

draggable_bar:include(gui_clickable_mixin)

return draggable_bar
