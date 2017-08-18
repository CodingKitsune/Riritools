local class = require("riritools.lua.class")
local gui_component = require("riritools.lua.gui_component")
local gui_radiobutton = require("riritools.lua.gui_radiobutton")

local gui_radiobox = class("rt.gui_radiobox", gui_component)

local function on_radio_click(_, args)
	args.box:set_value(args.box.__radiovalues[args.button])
end

function gui_radiobox:__initialize(name, params, parent)
	gui_component.__initialize(self, name, parent)
	params = params or {}
	self.on_change_function = nil
	self.on_change_function_args = nil
	self.__radiobutton_class = params.radiobutton_class or gui_radiobutton
	self.__default_value = params.default_value or nil
	self.__radio_margin = params.radio_margin or vmath.vector3(0, 50, 0)
	self.__box_margin = params.box_margin or vmath.vector3(0)
	self.__radiobuttons = {}
	self.__radiovalues = {}
	self.__value = nil
	self.__base_radiobutton = self.__radiobutton_class:new("radiobutton", nil, self)
end

function gui_radiobox:setup(options)
	options = options or {}
	self.__options = options.options or {}
	self.__default_value = options.default_value or self.__default_value
	self.__radio_margin = options.radio_margin or self.__radio_margin
	self.__box_margin = options.box_margin or self.__box_margin

	gui.set_enabled(self.__base_radiobutton:get_base_node(), true)
	self.__base_radiobutton:setup()
	for _, node in ipairs(self.__radiobuttons) do
		gui.delete_node(node)
	end
	self.__radiobuttons = {}
	self.__radiovalues = {}

	local basenode_id = self.__base_radiobutton:get_base_node_id()
	local background_id = self.__base_radiobutton:get_background_id()
	local label_id = self.__base_radiobutton:get_label_id()
	local check_id = self.__base_radiobutton:get_check_id()

	local nodes
	local radiobutton_name
	local radiobutton
	local background
	local label
	local font
	local box_width = 0
	local amount_of_options = table.getn(self.__options)
	for i=1, amount_of_options do
		nodes = gui.clone_tree(self.__base_radiobutton:get_base_node())
		for key, node in pairs(nodes) do
			radiobutton_name = "radiobutton_"..i
			if (key == basenode_id) then
				gui.set_id(node, radiobutton_name.."/component")
				gui.set_position(node, gui.get_position(node) - ((i-1) * self.__radio_margin))
			elseif (key == background_id) then
				background = node
				gui.set_id(node, radiobutton_name.."/background")
			elseif (key == label_id) then
				gui.set_id(node, radiobutton_name.."/label")
				gui.set_text(node, self.__options[i])
				label = node
				font = font or gui.get_font(label)
			elseif (key == check_id) then
				gui.set_id(node, radiobutton_name.."/check")
			end
		end
		radiobutton = self.__radiobutton_class:new(radiobutton_name, options.radiobutton_params)
		radiobutton:setup(options.radiobutton_options)
		box_width = math.max(box_width, gui.get_size(background).x + gui.get_text_metrics(font, gui.get_text(label)).width)
		radiobutton.on_click_function = on_radio_click
		radiobutton.on_click_function_args = {button=radiobutton, box=self}
		table.insert(self.__radiobuttons, radiobutton)
		self.__radiovalues[radiobutton] = self.__options[i]
	end
	gui.set_enabled(self.__base_radiobutton:get_base_node(), false)
	if (self.__default_value) then
		self:set_value(self.__default_value)
	end
	box_width = box_width + (self.__radio_margin.x * 2)
	local box_height = (amount_of_options + 1) * self.__radio_margin.y
	gui.set_size(self.__base_node, vmath.vector3(box_width, box_height, 0) + self.__box_margin)
end

function gui_radiobox:get_value()
	return self.__value
end

function gui_radiobox:set_value(value)
	for _, button in ipairs(self.__radiobuttons) do
		if (self.__radiovalues[button] == value) then
			button:toggle(true)
			self.__value = value
			if (self.on_change_function) then
				self.on_change_function(self.__value, self.on_change_function_args)
			end
		else
			button:toggle(false)
		end
	end
end

function gui_radiobox:on_input(action_id, action)
	for _, button in pairs(self.__radiobuttons) do
		button:on_input(action_id, action)
	end
end

function gui_radiobox:on_message(message_id, message, sender)
	for _, button in pairs(self.__radiobuttons) do
		button:on_message(message_id, message, sender)
	end
end

return gui_radiobox
