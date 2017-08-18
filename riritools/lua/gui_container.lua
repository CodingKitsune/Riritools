local class = require("riritools.lua.class")
local gui_component = require("riritools.lua.gui_component")
local rt_inputs = require("riritools.lua.riritools_inputs")
local gui_clickable_mixin = require("riritools.lua.gui_clickable_mixin")
local wh = require("riritools.lua.window_helper")
local chronometer = require("riritools.lua.chronometer")

local min = math.min
local max = math.max

local get_size = gui.get_size
local set_size = gui.set_size
local get_position = gui.get_position
local set_position = gui.set_position

local gui_container = class("rt.gui_container", gui_component)

function gui_container:__initialize(name, _, parent)
	gui_component.__initialize(self, name, parent)
	self.delay = 5
	self.touch_press_time = 0.15
	self.drag_power = 0.5
	self.__max_content_pos = vmath.vector3()
	self.__drag = vmath.vector3()
	self.__is_a_container = true
	self.__delay_count = 0
	self.__drag_pos = nil
	self.__touch_counter = 0
	self.__drag_chronometer = chronometer:new()
	self.__is_moving = false
end

function gui_container:setup(options)
	options = options or {}
	self.window = self.__base_node
	self:__setup_node("__windowskin", "windowskin")
	self:__setup_node("__content", "content")
	self:__setup_node("__stencil", "stencil")
	self:__setup_node("__scrollbar_x", "scrollbar_x")
	self:__setup_node("__scrollbar_y", "scrollbar_y")

	local window_size = get_size(self.window)
	self.__window_size = vmath.vector3(window_size)
	self.__windowskin_slice9 = gui.get_slice9(self.__windowskin)

	if (not options.is_open) then
		window_size.x = 0
		window_size.y = 0
		gui.set_size(self.window, window_size)
	end

	self:refresh_windowskin()
end

function gui_container:open(time)
	time = time or 0.25
	gui.animate(self.window, "size.x", self.__window_size.x, gui.EASING_LINEAR, time)
	gui.animate(self.window, "size.y", self.__window_size.y, gui.EASING_LINEAR, time)
end

function gui_container:close(time)
	time = time or 0.25
	gui.animate(self.window, "size.x", 0, gui.EASING_LINEAR, time)
	gui.animate(self.window, "size.y", 0, gui.EASING_LINEAR, time)
end

function gui_container:is_open()
	local window_size = gui.get_size(self.window)
	return (window_size.x <= self.__windowskin_slice9.x or window_size.y <= self.__windowskin_slice9.y)
end

function gui_container:refresh_windowskin()
	local window_size = get_size(self.__base_node)
	set_size(self.__windowskin, window_size)

	window_size.x = max(window_size.x - self.__windowskin_slice9.x * 2, 0)
	window_size.y = max(window_size.y - self.__windowskin_slice9.y * 2, 0)
	set_size(self.__stencil, window_size)

	local size = get_size(self.__content)
	local pos = get_position(self.__content)
	local max_x = (size.x - window_size.x)
	local max_y = (size.y - window_size.y)
	local overmax = false
	if (pos.y > max_y) then
		pos.y = 0
		overmax = true
	end
	if (pos.x > max_x) then
		pos.x = 0
		overmax = true
	end
	if (overmax) then
		set_position(self.__content, pos)
	end

	self.__max_content_pos = (get_size(self.__content) - window_size)
	self.__delay_count = 0

	size = get_size(self.__scrollbar_x)
	local ratio = window_size.x  / gui.get_size(self.__content).x
	size.x = ratio * window_size.x
	set_size(self.__scrollbar_x, size)

	local color = gui.get_color(self.__scrollbar_x)
	color.w = (ratio >= 1) and 0 or 1
	gui.set_color(self.__scrollbar_x, color)

	pos = get_size(self.__scrollbar_x)
	pos.y = -window_size.y + pos.y
	pos.x = -min(get_position(self.__content).x / self.__max_content_pos.x, 1) * (window_size.x - size.x)
	set_position(self.__scrollbar_x,  pos)

	size = get_size(self.__scrollbar_y)
	ratio = (window_size.y  / get_size(self.__content).y)
	size.y = ratio * window_size.y
	set_size(self.__scrollbar_y, size)

	color = gui.get_color(self.__scrollbar_y)
	color.w = (ratio >= 1) and 0 or 1
	gui.set_color(self.__scrollbar_y, color)

	pos = get_size(self.__scrollbar_y)
	pos.x = window_size.x - pos.x
	pos.y = -min(get_position(self.__content).y / self.__max_content_pos.y, 1) * (window_size.y - size.y)
	set_position(self.__scrollbar_y,  pos)
end

function gui_container:update(dt)
	self.__drag_chronometer:update(dt)
	self.__delay_count = self.__delay_count + 1
	if (self.__delay_count >= self.delay) then
		self:refresh_windowskin()
	end
end

function gui_container:can_pass_input()
	return (self.__drag.x == 0 and self.__drag.y == 0)
end

function gui_container:on_non_moving_input()
end

function gui_container:__reset_input_data()
	self.__is_moving = false
	self.__drag_chronometer:stop()
	self.__drag_pos = nil
	self.__drag = vmath.vector3()
	self.__touch_counter = 0
end

function gui_container:on_input(action_id, action)
	if (self.__is_active and self.__is_enabled) then
		local input = self.use_touch and rt_inputs.TOUCH or self.mouse_binding

		local mouse_or_touch = (action_id == input) and not action.pressed
		local mouse_wheel = (action_id == rt_inputs.MOUSE_WHEEL_UP or action_id == rt_inputs.MOUSE_WHEEL_DOWN)
							and action.pressed

		if (not self.__drag_pos) then
			if (action.pressed and self:__has_clicked_ok_on_component(action_id, action, self.__stencil)) then
				self.__drag_chronometer:restart()
			elseif (mouse_wheel and self:__is_inside_component_check(action.screen_x, action.screen_y, self.__stencil)) then
				self.__drag_pos = get_position(self.__content)
			end
		end

		if (mouse_wheel or self.__drag_chronometer:as_seconds() > self.touch_press_time) then
			self.__is_moving = true
			self.__drag_pos = get_position(self.__content)
			self.__drag_chronometer:stop()
		end

		if ((mouse_or_touch or mouse_wheel) and self.__drag_pos) then
			local wheel_multiplier = mouse_wheel and (action_id == rt_inputs.MOUSE_WHEEL_UP and -0.1 or 0.1) or 0
			self.__drag.y = mouse_wheel and (self.__drag.y + wheel_multiplier * wh.height)
							or self.__drag.y + (action.screen_dy * self.drag_power)
			self.__drag.x = mouse_wheel and 0 or self.__drag.x + (action.screen_dx * self.drag_power)
			local position = self.__drag_pos + self.__drag
			position.x = min(max(position.x, -self.__max_content_pos.x), 0)
			position.y = max(min(position.y, self.__max_content_pos.y), 0)
			set_position(self.__content, position)
			self.__is_moving = true
		end

		if (not self.__is_moving) then
			self:on_non_moving_input(action_id, action)
		end

		if ((action.released and action_id == input) or mouse_wheel) then
			self:__reset_input_data()
		end
	end
end

gui_container:include(gui_clickable_mixin)

return gui_container
