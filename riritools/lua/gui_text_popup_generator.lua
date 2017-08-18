local class = require("riritools.lua.class")
local gui_component = require("riritools.lua.gui_component")
local wh = require("riritools.lua.window_helper")

local text_popup_generator = class("rt.gui_text_popup_generator")

local node_data = setmetatable({}, {_mode="k"})

local function fade_out(_, node)
	local data = node_data[node]

end

local function waiting(guiScript, node)

end

function text_popup_generator:__initialize(node_template)
	self.__node_template = gui.get_node(node_template) 
	self.__text_nodes = {}
end

function text_popup_generator:pop_text(text, position, options)
	options = options or {}
	position = position or vmath.vector3(wh.width*0.5, wh.height*0.5, 1)
	local node = gui.clone(self.__node_template)
	gui.set_position(node, position)
	gui.set_text(node, options.should_translate and gui_component.static.global_dictionary:get(text) or text)

	options.duration = options.duration or 0

	if (options.fade_out_time) then
		options.fade_in_time = options.fade_in_time or 0
	end

	if (options.fade_in_time) then
		gui.animate(node, "color.w", 1.0, gui.EASING_LINEAR, options.fade_in_time, 0, options.fade_out_time and fade_out or nil)
	end

	node_data[node] = options

	return node
end

return text_popup_generator
