local pairs = pairs

local default_linear_data_mixins = {
	appended_methods = {
		transform_from_table = function(self, table_to_use)
			self.__data = table_to_use
			self.__size = table.getn(table_to_use)
		end,

		for_each = function(self, do_function, ...)
			for k, v in pairs(self.__data) do
				if (v ~= nil) then
					do_function(k, v, ...)
				end
			end
		end,

		has_item = function(self, item, comparator_function)
			for _, v in pairs(self.__data) do
				if (comparator_function and comparator_function(v, item) or v == item) then
					return true
				end
			end
			return false
		end,

		amount_of_item = function(self, item)
			local amount = 0
			for _, value in pairs(self.__data) do
				if (value == item) then
					amount = amount + 1
				end
			end
			return amount
		end,
	}
}

return default_linear_data_mixins
