local backward_modifiable = require("riritools.lua.container_backward_modifiable_mixin")
local foward_modifiable = require("riritools.lua.container_foward_modifiable_mixin")

local queue_mixin = {
	appended_methods = {
		__initialize = function(self, ...)
			backward_modifiable.appended_methods.__initialize(self, ...)
			foward_modifiable.appended_methods.__initialize(self, ...)
		end,
		push = foward_modifiable.appended_methods.add_at_end,
		pop = function(self)
			local first = backward_modifiable.appended_methods.first(self)
			backward_modifiable.appended_methods.remove_at_start(self)
			return first
		end,
		first = backward_modifiable.appended_methods.first,
		last = foward_modifiable.appended_methods.last,
		get_from_first = foward_modifiable.appended_methods.get_from_start,
		get_from_last = foward_modifiable.appended_methods.get_from_end,
	}
}

return queue_mixin
