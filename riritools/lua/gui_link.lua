local class = require("riritools.lua.class")
local gui_component = require("riritools.lua.gui_component")
local gui_clickable_mixin = require("riritools.lua.gui_clickable_mixin")

local link = class("rt.link", gui_component)

function link:__initialize(name, parent)
	gui_component.__initialize(self, name, parent, name, true)
	self.pressed_function = nil
	self.pressed_function_args = nil
	self.pressed_color = vmath.vector4(0.5, 0.5, 0.5, 1.0)
	self.normal_color = vmath.vector4(1.0, 1.0, 1.0, 1.0)
	self.disabled_color = vmath.vector4(0.2, 0.2, 0.2, 1.0)
end

function link:on_input(action_id, action)
	local is_action_on_button = self.__is_active
								and self:__has_clicked_ok_on_component(action_id, action, self.__base_node)

	local is_button_pressed = (action.pressed and is_action_on_button)

	local is_cooldown_over = self.__cooldown_timer:as_seconds() > self.cooldown

	if is_button_pressed then
		if is_cooldown_over then
			self:__emit_ok()
			if self.pressed_function then
				self.pressed_function(self.pressed_function_args)
			end
			self.__cooldown_timer:restart()
		end
		gui.set_color(self.__base_node, self.pressed_color)
	else
		gui.set_color(self.__base_node, self.__is_active and self.normal_color or self.disabled_color)
	end
end

link:include(gui_clickable_mixin)

return link
