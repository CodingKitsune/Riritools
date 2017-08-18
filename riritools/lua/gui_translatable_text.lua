local class = require("riritools.lua.class")
local gui_component = require("riritools.lua.gui_component")

local gui_translatable_text = class("rt.gui_translatable_text", gui_component)

function gui_translatable_text:__initialize(name, parent)
	gui_component.__initialize(self, name, parent, name, true)
	self:__setup_node("__base_node", name, {translate=true})
end

return gui_translatable_text
