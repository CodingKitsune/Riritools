local class = require("riritools.lua.class")
local gui_component = require("riritools.lua.gui_component")
local gui_clickable_mixin = require("riritools.lua.gui_clickable_mixin")
local gui_text_focus_mixin = require("riritools.lua.gui_text_focus_mixin")
local rt_inputs = require("riritools.lua.riritools_inputs")

local fade_cursor_out
local fade_cursor_in

fade_cursor_out = function(_, cursor_node)
	gui.animate(cursor_node, "color.w", 0, gui.EASING_INSINE, 0.5, 0.1, fade_cursor_in)
end

fade_cursor_in = function(_, cursor_node)
	gui.animate(cursor_node, "color.w", 1.0, gui.EASING_INSINE, 0.2, 0.1, fade_cursor_out)
end

local gui_text_field = class("rt.gui_text_field", gui_component)

function gui_text_field:__initialize(name, params, parent)
	gui_component.__initialize(self, name, parent)
	self.on_change = nil
	self.on_change_args = nil
	params = params or {}
	self.__default_text = params.default_text or ""
	self.__keyboard_type = params.keyboard_type or gui.KEYBOARD_TYPE_DEFAULT
	self.__password = params.password or false
	self.__number = params.number or false
	self.__float = params.float or false
	self.__allow_negative = params.negative or false
	self.__mask = params.mask or ""
	self.__min_length = params.min_length or 0
	self.__max_length = params.max_length or math.huge
	self.__cursor_padding = params.cursor_padding or vmath.vector3(0, 0, 0)
end

function gui_text_field:setup(params)
	self:__setup_node("__border", "border")
	self:__setup_node("__cursor", "cursor")
	self:__setup_node("__text", "text")
	self.__font = gui.get_font(self.__text)
	self.__border_width = gui.get_size(self.__border).x
	self.__padding_size = gui.get_text_metrics(self.__font, "|").width
	self.__initial_text_position = gui.get_position(self.__text)
	self.__initial_cursor_position = gui.get_position(self.__cursor)
	self.__cursor_width = gui.get_size(self.__cursor).x
	if (params and params.translate) then
		self.__default_text = self:__get_text_translation(self.__default_text, params.dictionary)
	end
	self:set_text("")
	self:release_text_focus()
end

function gui_text_field:get_text()
	return self.__text_string
end

function gui_text_field:set_text(text)
	local number = tonumber(text)
	if (self.__number and not number) then
		return
	end
	if (self.__number and not self.__allow_negative and number < 0) then
		return
	end
	if (#text <= self.__max_length) then
		self.__text_string = text
	else
		self.__text_string = string.sub(text, 1, self.__max_length)
	end

	local text_buffer = self.__text_string
	local color = gui.get_color(self.__text)

	if (self.__text_string == "") then
		text_buffer = self.__default_text
		color.w = 0.5
	else
		color.w = 1
	end

	if (self.__password) then
		gui.set_text(self.__text, string.rep("*", #text_buffer))
	else
		gui.set_text(self.__text, text_buffer)
	end
	gui.set_color(self.__text, color)

	local position = vmath.vector3(self.__initial_cursor_position)
	local text_position = vmath.vector3(self.__initial_text_position)
	position.x = position.x + gui.get_text_metrics(self.__font, self.__text_string.."|").width - self.__padding_size
	if (position.x > self.__border_width) then
		text_position.x = text_position.x + ((-position.x) + self.__border_width) - self.__initial_cursor_position.x
		position.x = self.__border_width - self.__cursor_width
	end
	gui.set_position(self.__cursor, position + self.__cursor_padding)
	gui.set_position(self.__text, text_position)
	if (self.on_change) then
		self.on_change(self.on_change_args)
	end
end

function gui_text_field:reset_text()
	self:set_text("")
end

function gui_text_field:acquire_text_focus()
	fade_cursor_in(nil, self.__cursor)
end

function gui_text_field:release_text_focus()
	gui.cancel_animation(self.__cursor, "color.w")
	local color = gui.get_color(self.__cursor)
	color.w = 0
	gui.set_color(self.__cursor, color)
end

function gui_text_field:on_input(action_id, action)
	local is_action_on_button = self.__is_active and self:__has_clicked_ok_on_component(action_id, action, self.__border)
	local requesting_focus = (action.pressed and is_action_on_button)
	local requesting_lose_focus = (
		(action_id == rt_inputs.MOUSE_OK or action_id == rt_inputs.TOUCH)
		and action.pressed and not is_action_on_button
	)
	if (requesting_focus) then
		self:acquire_text_focus()
	elseif (requesting_lose_focus) then
		self:release_text_focus()
	elseif (action_id == rt_inputs.TEXT and self:has_text_focus()) then
		self:set_text(self.__text_string .. action.text)
	elseif (action_id == rt_inputs.BACKSPACE and action.repeated and self:has_text_focus()) then
		self:set_text(string.sub(self.__text_string, 1, -2))
	end
end

gui_text_field:include(gui_text_focus_mixin)
gui_text_field:include(gui_clickable_mixin)

return gui_text_field
