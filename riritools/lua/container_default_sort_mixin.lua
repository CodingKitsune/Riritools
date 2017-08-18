local sort = table.sort

local default_sort = {
	appended_methods = {
		sort = function(self, comparator_function)
			sort(self.__data, comparator_function)
		end
	}
}

return default_sort
