local class = require("riritools.lua.class")
local gui_component = require("riritools.lua.gui_component")

local pairs = pairs
local tostring = tostring
local set_text = gui.set_text

local debug_window = class("rt.debug_window", gui_component)

function debug_window:__initialize(name, parent)
	gui_component.__initialize(self, name, parent, "window")
	self.vars = nil
	self.update_frequency = 1

	self.__update_counter = 0
end

function debug_window:setup()
	self.window = self.__base_component
	self:__setup_node("__text", "text")
end

function debug_window:update(vars)
	self.__update_counter = self.__update_counter + 1
	if (self.__update_counter >= self.update_frequency) then
		self.vars = vars
		local text_string = ""
		for key, value in pairs(self.vars) do
			text_string = text_string .. "\n"..tostring(key)..": "..tostring(value)
		end
		set_text(self.__text, text_string)
		self.__update_counter = 0
	end
end

return debug_window
