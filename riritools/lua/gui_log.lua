local class = require("riritools.lua.class")
local gui_component = require("riritools.lua.gui_component")
local delayed_function = require("riritools.lua.delayed_function")
local log = require("riritools.lua.log")
local rt_msgs = require("riritools.lua.riritools_msgs")

local gui_log = class("rt.gui_log", gui_component)

local set_text = gui.set_text
local set_color = gui.set_color
local toggle_log = rt_msgs.TOGGLE_LOG
local visible = vmath.vector4(1)
local not_visible = vmath.vector4(0)

local function update_log(self)
	set_text(self.__text, log.contents)
	self.__update_function:restart()
end

function gui_log:__initialize(name, parent)
	gui_component.__initialize(self, name, parent)
	self.__update_function = delayed_function:new(0.5, update_log, self, false)
	self.__visible = false
end

function gui_log:setup()
	self:__setup_node("__text", "text")
	set_color(self.__base_node, not_visible)
end

function gui_log:update(dt)
	self.__update_function:update(dt)
end

function gui_log:on_message(message_id)
	if (message_id == toggle_log) then
		self.__visible = not self.__visible
		set_color(self.__base_node, self.__visible and visible or not_visible)
	end
end

return gui_log
