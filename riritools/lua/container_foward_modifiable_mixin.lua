local foward_modifiable_mixin = {
	appended_methods = {
		__initialize = function(self, _)
			self.__end_index = -1
		end,

		add_at_end = function(self, obj)
			self.__end_index = self.__end_index + 1
			self.__size = self.__size + 1
			self.__data[self.__end_index] = obj
		end,

		remove_at_end = function(self)
			if (self.__size > 0) then
				self.__data[self.__end_index] = nil
				self.__end_index = self.__end_index - 1
				self.__size = self.__size - 1
			end
		end,

		last = function(self)
			return self.__data[self.__end_index]
		end,

		get_from_end = function(self, position)
			return self.__data[self.__end_index - position]
		end,
	}
}

return foward_modifiable_mixin
