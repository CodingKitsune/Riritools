local hash_table_mixin = {
	appended_methods = {
		get = function(self, key)
			return self.__data[key]
		end,

		set = function(self, key, value)
			if (self.__data[key] == nil) then
				if (value == nil) then
					self.__size = self.__size - 1
				end
			else
				if (value ~= nil) then
					self.__size = self.__size + 1
				end
			end
			self.__data[key] = value
		end,
	}
}

return hash_table_mixin
