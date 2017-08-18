local foward_modifiable = require("riritools.lua.container_foward_modifiable_mixin")

local stack_mixin = {
	appended_methods = {
		__initialize = foward_modifiable.appended_methods.__initialize,
		push = foward_modifiable.appended_methods.add_at_end,
		pop = function(self)
			local last = foward_modifiable.appended_methods.last(self)
			foward_modifiable.appended_methods.remove_at_end(self)
			return last
		end,
		top = foward_modifiable.appended_methods.last,
		get_from_top = foward_modifiable.appended_methods.get_from_end,
	}
}

return stack_mixin
