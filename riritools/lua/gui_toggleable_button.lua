local class = require("riritools.lua.class")
local gui_component = require("riritools.lua.gui_component")
local gui_clickable_mixin = require("riritools.lua.gui_clickable_mixin")
local delayed_function = require("riritools.lua.delayed_function")

local toggleable_button = class("rt.gui_toggleable_button", gui_component)

function toggleable_button:__initialize(name, params, parent)
	gui_component.__initialize(self, name, parent)
	self.default_pressed_color = vmath.vector4(0, 0.3, 0.3, 1)
	self.default_normal_color = vmath.vector4(0, 0.5, 0.5, 1)
	self.default_inactive_color = vmath.vector4(0.1, 0.1, 0.1, 1)
	self.default_disabled_color = vmath.vector4(0, 0, 0, 1)
	self.__no_label = params and params.no_label or false
	self.__button = nil
	self.__label = nil
	self.__current_state = 0
	self.__states = {}
	self.__states_amount = 0
	self.__last_text = ""
	self.__auto_refresh_color = delayed_function:new(0.51, toggleable_button.__refresh_color, self)
end

function toggleable_button:setup(options)
	self:__setup_node("__button", "component")
	if not (self.__no_label) then
		if (options and options.translate) then
			self.translate = true
			self.dictionary = options.dictionary
			self:__setup_node("__label", "label", {translate=options.translate, dictionary=options.dictionary})
		else
			self:__setup_node("__label", "label")
		end
	end
end

function toggleable_button:update(dt)
	self.__auto_refresh_color:update(dt)
end

function toggleable_button:add_state(state)
	self.__states_amount = self.__states_amount + 1
	self.__states[self.__states_amount] = state
	if (self.__current_state == 0) then
		self.__current_state = 1
		self.__last_text = state.text
		self:refresh_label()
		self:__refresh_color()
	end
end

function toggleable_button:refresh_label()
	if not(self.no_label) then
		local text = (self.__states[self.__current_state].text or self.__last_text or "")
		if (self.translate) then
			gui.set_text(self.__label, self.dictionary:get(gui.get_text(text))
			or gui_component.static.global_dictionary:get(gui.get_text(text)))
		else
			gui.set_text(self.__label, text)
		end
	end
end

function toggleable_button:on_input(action_id, action)
	local is_action_on_button = self.__is_active and self:__has_clicked_ok_on_component(action_id, action, self.__button)

	local state = self.__states[self.__current_state]

	if (action.pressed and is_action_on_button) then
		gui.set_color(self.__button, state.pressed_color or self.default_pressed_color)
		if (self.__cooldown_timer:as_seconds() > self.cooldown) then
			self:__emit_ok()
			if 	state.pressed_function then
				state.pressed_function(state.pressed_function_args)
			end
			self.__last_text = self.__states[self.__current_state].text
			self.__current_state = self.__current_state + 1
			if (self.__current_state > self.__states_amount) then
				self.__current_state = 1
			end
			self:refresh_label()
			self.__cooldown_timer:restart()
		end
	elseif (action.released and is_action_on_button) then
		gui.set_color(self.__button, state.normal_color or self.default_normal_color)
	end
end

function toggleable_button:__refresh_color()
	local state = self.__states[self.__current_state]
	if (state) then
		gui.set_color(self.__button, self.__is_enabled and
			(self.__is_active and (state.normal_color or self.default_normal_color)
				or (state.inactive_color or self.default_inactive_color))
			or (state.disabled_color or self.default_disabled_color))
	end
end

function toggleable_button:set_active()
	self:__refresh_color()
end

function toggleable_button:set_enabled()
	self:__refresh_color()
end

toggleable_button:include(gui_clickable_mixin)

return toggleable_button
