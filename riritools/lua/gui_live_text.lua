local class = require("riritools.lua.class")
local gui_component = require("riritools.lua.gui_component")

local set_text = gui.set_text

local live_text = class("rt.live_text", gui_component)

function live_text:__initialize(name, parent)
	gui_component.__initialize(self, name, parent, name, true)
	self.update_function = nil
	self.target = nil
	self.delay = 1
	self.is_active = true
	self.__delay_count = 0
end

function live_text:update()
	self.__delay_count = self.__delay_count + 1
	if (self.is_active and self.__delay_count >= self.delay and self.update_function) then
		self:refresh()
	end
end

function live_text:refresh()
	set_text(self.__base_node, self.update_function(self.target))
	self.__delay_count = 0
end

return live_text
