local class = require("riritools.lua.class")
local dictionary = require("riritools.lua.dictionary")

local gui_component = class("rt.gui_component")

gui_component.static.global_dictionary = dictionary:new()

function gui_component:__initialize(name, parent, base_component_name, is_single_node)
	self.__name = name
	self.__parent = parent
	self.__is_single_node = is_single_node
	self.__is_a_container = false
	self.__nodes = {}
	self.__clone_node_table = nil
	self:__setup_node("__base_node", base_component_name or "component")
end

function gui_component:get_full_name()
	if (self.__parent) then
		return (self.__parent:get_full_name().."/"..self.__name)
	else
		return (self.__name)
	end
end

function gui_component:__setup_node(property_name, node_name, options)
	options = options or {}
	local node
	if (self.__is_single_node) then
		node = gui.get_node((self.__parent and (self.__parent:get_full_name().."/"..node_name)) or node_name)
	else
		node = gui.get_node(self:get_full_name().."/"..node_name)
	end
	self[property_name] = node
	self.__nodes[property_name] = node
	if (options.translate) then
		gui.set_text(node, self:__get_text_translation(gui.get_text(node), options.dictionary))
	end
end

function gui_component:__get_text_translation(text, dictionary_to_use)
	return (dictionary_to_use and dictionary_to_use:get(text))
	or gui_component.static.global_dictionary:get(text)
	or text
end

function gui_component:get_base_node()
	return self.__base_node
end

function gui_component:get_base_node_id()
	return gui.get_id(self.__base_node)
end

function gui_component:is_a_container()
	return self.__is_a_container
end

function gui_component:set_clone_node_table(clone_node_table)
	self.__clone_node_table = clone_node_table
end

function gui_component:create_clone_node_table(node_names)
	self.__clone_node_table = {}
	self.__clone_node_table[table.getn(node_names)] = true
	for _, name in ipairs(node_names) do
		self.__clone_node_table[hash(name)] = name
	end
end

function gui_component:clone_component(id, params)
	local new_name = self.__name..id
	local nodes = gui.clone_tree(self.__base_node)
	local str_to_find = "/"..self.__name.."/"
	local str_to_rep = "/"..new_name.."/"
	local new_id
	for key, node in pairs(nodes) do
		new_id = string.gsub(self.__clone_node_table[key], str_to_find, str_to_rep)
		gui.set_id(node, new_id)
	end
	local new_component = self.class:new(new_name, params, self.__parent)
	return new_component
end

function gui_component:delete_component()
	gui.delete_node(self.__base_node)
end

return gui_component
