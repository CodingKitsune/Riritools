local class = require("riritools.lua.class")
local gui_component = require("riritools.lua.gui_component")

local gui_window = class("rt.gui_window", gui_component)

function gui_window:__initialize(name, parent)
	gui_component.__initialize(self, name, parent, "window")
	self.delay = 1
	self.__delay_count = 0
end

function gui_window:setup(is_open)
	self.window = self.__base_node
	self:__setup_node("__windowskin", "windowskin")
	self:__setup_node("__content", "content")

	local window_size = gui.get_size(self.window)
	self.__window_size = vmath.vector3(window_size)
	self.__windowskin_slice9 = gui.get_slice9(self.__windowskin)

	if (not is_open) then
		window_size.x = 0
		window_size.y = 0
		gui.set_size(self.window, window_size)
	end

	self:refresh_windowskin()
end

function gui_window:open(time)
	time = time or 0.25
	gui.animate(self.window, "size.x", self.__window_size.x, gui.EASING_LINEAR, time)
	gui.animate(self.window, "size.y", self.__window_size.y, gui.EASING_LINEAR, time)
end

function gui_window:close(time)
	time = time or 0.25
	gui.animate(self.window, "size.x", 0, gui.EASING_LINEAR, time)
	gui.animate(self.window, "size.y", 0, gui.EASING_LINEAR, time)
end

function gui_window:is_open()
	local window_size = gui.get_size(self.window)
	return (window_size.x <= self.__windowskin_slice9.x or window_size.y <= self.__windowskin_slice9.y)
end

function gui_window:refresh_windowskin()

	local window_size = gui.get_size(self.__base_node)
	gui.set_size(self.__windowskin, window_size)

	window_size.x = math.max(window_size.x - self.__windowskin_slice9.x * 2, 0)
	window_size.y = math.max(window_size.y - self.__windowskin_slice9.y * 2, 0)
	gui.set_size(self.__content, window_size)
	self.__delay_count = 0
end

function gui_window:update()
	self.__delay_count = self.__delay_count + 1
	if (self.__delay_count >= self.delay) then
		self:refresh_windowskin()
	end
end

return gui_window
