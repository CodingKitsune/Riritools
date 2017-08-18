local class = require("riritools.lua.class")
local gui_component = require("riritools.lua.gui_component")
local gui_clickable_mixin = require("riritools.lua.gui_clickable_mixin")
local delayed_function = require("riritools.lua.delayed_function")

local set_color = gui.set_color

local gui_button = class("rt.gui_button", gui_component)

function gui_button:__initialize(name, params, parent)
	gui_component.__initialize(self, name, parent)
	self.pressed_function = nil
	self.pressed_function_args = nil
	self.released_function = nil
	self.released_function_args = nil
	self.repeated_function = nil
	self.repeated_function_args = nil
	self.pressed_color = vmath.vector4(0, 0.3, 0.3, 1)
	self.normal_color = vmath.vector4(0, 0.5, 0.5, 1)
	self.inactive_color = vmath.vector4(0.1, 0.1, 0.1, 1)
	self.disabled_color = vmath.vector4(0, 0, 0, 1)
	self.press_animation = nil
	self.release_animation = nil
	self.__auto_refresh_color = delayed_function:new(0.51, gui_button.__refresh_color, self)
	self.__no_label = params and params.no_label or false
	self.__button = nil
	self.__label = nil
end

function gui_button:setup(options)
	self:__setup_node("__button", "component")
	if not (self.__no_label) then
		if (options and options.translate) then
			self:__setup_node("__label", "label", {translate=options.translate, dictionary=options.dictionary})
		else
			self:__setup_node("__label", "label")
		end
	end
	self:__refresh_color()
end

function gui_button:update(dt)
	self.__auto_refresh_color:update(dt)
end

function gui_button:on_input(action_id, action)
	if self.__is_active then
		local is_action_on_button =  self:__has_clicked_ok_on_component(action_id, action, self.__button)

		local is_button_pressed = (action.pressed and is_action_on_button)
		local is_button_repeated = (action.repeated and is_action_on_button)
		local is_button_released = (action.released and is_action_on_button)

		if (action.pressed or action.repeated or action.released) then
			self.__auto_refresh_color:restart()
		end

		local is_cooldown_over = self.__cooldown_timer:as_seconds() > self.cooldown

		if is_button_pressed then
			if is_cooldown_over and self.pressed_function then
				self:__emit_ok()
				self.__cooldown_timer:restart()
				self.pressed_function(self.pressed_function_args)
				if self.press_animation then
					self.press_animation(self, self.pressed_function_args)
				end
			end
			--if not (self.__no_label) then
			set_color(self.__button, self.pressed_color)
			--end
		elseif is_button_released then
			if is_cooldown_over and self.released_function then
				self.__cooldown_timer:restart()
				self.released_function(self.released_function_args)
				if self.release_animation then
					self.release_animation(self, self.release_function_args)
				end
			end
			--if not (self.__no_label) then
			set_color(self.__button, self.normal_color)
			--end
		elseif is_button_repeated and self.repeated_function then
			if is_cooldown_over then
				self.__cooldown_timer:restart()
				self.repeated_function(self.repeated_function_args)
			end
			--if not (self.__no_label) then
			set_color(self.__button, self.pressed_color)
			--end
		end
	end
end

function gui_button:__refresh_color()
	--if not (self.__no_label) then
	set_color(self.__button,
		self.__is_enabled and (self.__is_active and self.normal_color or self.inactive_color) or self.disabled_color)
	--end
end

function gui_button:set_active()
	self:__refresh_color()
end

function gui_button:set_enabled()
	self:__refresh_color()
end

gui_button:include(gui_clickable_mixin)

return gui_button
