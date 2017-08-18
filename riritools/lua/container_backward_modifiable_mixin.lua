local backward_modifiable_mixin = {
	appended_methods = {
		__initialize = function(self, _)
			self.__start_index = 0
		end,

		add_at_start = function(self, obj)
			self.__start_index = self.__start_index - 1
			self.__size = self.__size + 1
			self.__data[self.__start_index] = obj
		end,

		remove_at_start = function(self)
			if (self.__size > 0) then
				self.__data[self.__start_index] = nil
				self.__start_index = self.__start_index + 1
				self.__size = self.__size - 1
			end
		end,

		first = function(self)
			return self.__data[self.__start_index]
		end,

		get_from_start = function(self, position)
			return self.__data[self.__start_index + position]
		end,
	}
}

return backward_modifiable_mixin
