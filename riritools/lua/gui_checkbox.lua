local class = require("riritools.lua.class")
local gui_component = require("riritools.lua.gui_component")
local gui_clickable_mixin = require("riritools.lua.gui_clickable_mixin")

local set_enabled = gui.set_enabled
local set_color = gui.set_color

local gui_checkbox = class("rt.gui_checkbox", gui_component)

function gui_checkbox:__initialize(name, params, parent)
	params = params or {}
	gui_component.__initialize(self, name, parent)
	self.on_click_function = nil
	self.on_click_function_args = nil
	self.active_color_background = vmath.vector4(0, 0.3, 0.3, 1)
	self.disabled_color_background = vmath.vector4(0, 0, 0, 1)
	self.active_color_check = vmath.vector4(0.2, 0.5, 0.5, 1)
	self.disabled_color_check = vmath.vector4(0.2, 0.2, 0.2, 1)
	self.click_animation = nil
	self.__is_checked = params.is_checked or false
	self.__no_label = params.no_label or false
end

function gui_checkbox:setup(options)
	self:__setup_node("__background", "background")
	self:__setup_node("__check", "check")
	if (not self.__no_label) then
		self:__setup_node("__label", "label", options)
	end
	self:refresh()
end

function gui_checkbox:set_active()
	self:refresh()
end

function gui_checkbox:set_enabled()
	self:refresh()
end

function gui_checkbox:toggle(new_value)
	if (new_value == nil) then
		self.__is_checked = not self.__is_checked
	else
		self.__is_checked = new_value
	end
	self:refresh()
end

function gui_checkbox:refresh()
	set_enabled(self.__check, self.__is_checked)
	set_color(self.__background, (self.__is_active and self.__is_enabled) and
		self.active_color_background or self.disabled_color_background)
	set_color(self.__check, (self.__is_active and self.__is_enabled) and
		self.active_color_check or self.disabled_color_check)
end

function gui_checkbox:on_input(action_id, action)
	if (self.__is_active
		and self.__cooldown_timer:as_seconds() > self.cooldown
		and action.pressed
		and (self:__has_clicked_ok_on_component(action_id, action, self.__background) or
			(not self.__no_label and self:__has_clicked_ok_on_component(action_id, action, self.__label))
		)) then
			self:__emit_ok()
			self.__cooldown_timer:restart()
			self:toggle()
			if (self.on_click_function) then
				self.on_click_function(self.__is_checked, self.on_click_function_args)
			end
			if (self.click_animation) then
				self.click_animation(self, self.on_click_function_args)
			end
	end
end

gui_checkbox:include(gui_clickable_mixin)

return gui_checkbox
