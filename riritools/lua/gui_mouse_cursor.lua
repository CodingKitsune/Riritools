local class = require("riritools.lua.class")
local gui_component = require("riritools.lua.gui_component")
local rt_msgs = require("riritools.lua.riritools_msgs")
local wh = require("riritools.lua.window_helper")

local set_position = gui.set_position
local set_cursor_animation = rt_msgs.SET_CURSOR_ANIMATION

local gui_mouse_cursor = class("rt.gui_mouse_cursor", gui_component)

local delay = 1
local delay_count = 0

function gui_mouse_cursor:__initialize(name, parent)
	gui_component.__initialize(self, name, parent)
	self.lock = false
	self.__is_non_mobile_platform = #sys.get_sys_info().device_model <= 0
end

function gui_mouse_cursor:setup()
	self:__setup_node("__cursor", "component")
	self.__position = gui.get_position(self.__cursor)
end

function gui_mouse_cursor:set_animation(animation)
	gui.play_flipbook(self.__cursor, animation)
end

function gui_mouse_cursor:on_input(_, action)
	delay_count = (delay_count + 1) % delay
	if (self.__is_non_mobile_platform and not self.lock and delay_count == 0) then
		self.__position.x = action.screen_x * wh.scale_x
		self.__position.y = action.screen_y * wh.scale_y
		set_position(self.__cursor, self.__position)
	end
end

function gui_mouse_cursor:on_message(message_id, message)
	if (message_id == set_cursor_animation) then
		self:set_animation(message.animation)
	end
end

return gui_mouse_cursor
