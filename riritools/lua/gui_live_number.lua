local class = require("riritools.lua.class")
local gui_component = require("riritools.lua.gui_component")

local format = string.format
local floor = math.floor
local live_number = class("rt.live_number", gui_component)
local gui_set_text = gui.set_text

function live_number:__initialize(name, linear_animator, parent)
	gui_component.__initialize(self, name, parent, name, true)
	self.update_function = nil
	self.target = nil
	self.delay = 1
	self.delay_set_text = 1
	self.transition_time = 0.5
	self.is_active = true
	self.use_float = false
	self.format = ""

	self.__delay_count = 0
	self.__delay_set_text_count = 0
	self.__property = self:get_full_name().."_number"
	self.__number = 0
	self.__is_animating = false
	self.__linear_animator = linear_animator
end

local function set_text(self)
	gui_set_text(self.__base_node, self.use_float and (self.format == "" and self.__number
			or format(self.format, self.__number)) or
		(self.format == "" and floor(self.__number) or format(self.format, floor(self.__number)))
	)
end

local function after_animating(self)
	self.__is_animating = false
	set_text(self)
end

local function while_animating(self)
	self.__delay_set_text_count = self.__delay_set_text_count + 1
	if (self.__delay_set_text_count >= self.delay_set_text) then
		set_text(self)
		self.__delay_set_text_count = 0
	end
end

function live_number:update()
	self.__delay_count = self.__delay_count + 1
	if (self.is_active and self.__delay_count >= self.delay and self.update_function) then
		local new_number = self.update_function(self.target)
		if (new_number ~= self.__number and not self.__is_animating) then
			self.__is_animating = true
			self.__linear_animator:animate(self, "__number", new_number, self.transition_time, after_animating, while_animating)
		end
		self.__delay_count = 0
	end
end

return live_number
