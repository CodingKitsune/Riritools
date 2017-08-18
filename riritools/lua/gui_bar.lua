local class = require("riritools.lua.class")
local gui_component = require("riritools.lua.gui_component")
local colors = require("riritools.lua.colors")

local gui_bar = class("rt.gui_bar", gui_component)
local set_color = gui.set_color
local set_size = gui.set_size
local get_size = gui.get_size
local animate = gui.animate
local min = math.min

function gui_bar:__initialize(name, params, parent)
	gui_component.__initialize(self, name, parent)
	self.value = params and params.value or 0
	self.max_value = params and params.value or 1
	self.target = nil
	self.get_value_function = nil
	self.get_max_value_function = nil
	self.positive_change_color = colors.GREEN
	self.negative_change_color = colors.RED
	self.difference_speed = 0.5
	self.__initial_size = 0
	self.__is_vertical = params and params.is_vertical or false
end

function gui_bar:setup()
	self:__setup_node("__outer_bar", "component")
	self:__setup_node("__inner_bar", "inner")
	self:__setup_node("__difference", "difference")
	self:__setup_node("__difference_texture", "difference_texture")
	self.__initial_size = self.__is_vertical and get_size(self.__inner_bar).y or get_size(self.__inner_bar).x
	self:refresh()
end

function gui_bar:update()
	local new_value = self.value
	local new_max_value = self.max_value
	if (self.target) then
		if (self.get_value_function) then
			new_value = self.get_value_function(self.target)
		end
		if (self.get_max_value_function) then
			new_max_value = self.get_max_value_function(self.target)
		end
	end
	if (new_value ~= self.value or new_max_value ~= self.max_value) then
		local difference_speed
		if(new_value > self.value) then
			set_color(self.__difference_texture, self.positive_change_color)
			difference_speed = self.difference_speed * 0.5
		else
			set_color(self.__difference_texture, self.negative_change_color)
			difference_speed = self.difference_speed * 2.5
		end

		self.value = new_value
		self.max_value = new_max_value

		local new_size = min(1.0, self.value / self.max_value) * self.__initial_size
		if (self.__is_vertical) then
			animate(self.__inner_bar, "size.y", new_size, gui.EASING_LINEAR, self.difference_speed)
			animate(self.__difference, "size.y", new_size, gui.EASING_LINEAR, difference_speed)
		else
			animate(self.__inner_bar, "size.x", new_size, gui.EASING_LINEAR, self.difference_speed)
			animate(self.__difference, "size.x", new_size, gui.EASING_LINEAR, difference_speed)
		end

	end
end

function gui_bar:refresh()
	local size = get_size(self.__inner_bar)
	local new_size = min(1.0, self.value / self.max_value) * self.__initial_size
	if (self.__is_vertical) then
		size.y = new_size
	else
		size.x = new_size
	end
	set_size(self.__inner_bar, size)
	set_size(self.__difference, size)
end

return gui_bar
