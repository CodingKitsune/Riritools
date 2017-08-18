local default_autosort_mixin = {
	add_only_existing = true,
	appended_methods = {
		__initialize = function(self, _)
			self.auto_sort = false
		end,
		set = function(self, _, _)
			if (self.auto_sort) then
				self:sort(self.comparator_function)
			end
		end,
	}
}

default_autosort_mixin.appended_methods.add =
	default_autosort_mixin.appended_methods.set

default_autosort_mixin.appended_methods.add_at_start =
	default_autosort_mixin.appended_methods.set

default_autosort_mixin.appended_methods.add_at_end =
	default_autosort_mixin.appended_methods.set

default_autosort_mixin.appended_methods.push =
	default_autosort_mixin.appended_methods.set

return default_autosort_mixin
