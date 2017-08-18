local pairs = pairs
local random = math.random
local randomseed = math.randomseed

local modifiable_array_mixin
modifiable_array_mixin = {
	appended_methods = {
		__reorganize_data = function(self)
			local clone = {}
			local index = 0
			for _, v in pairs(self.__data) do
				if (v ~= nil) then
					index = index + 1
					clone[index] = v
				end
			end
			self.__data = clone
		end,

		add = function(self, obj)
			self.__size = self.__size + 1
			self.__data[self.__size] = obj
		end,

		add_at = function(self, obj, position)
			for i=self.__size, position, -1 do
				self.__data[i+1] = self.__data[i]
			end
			self.__data[position] = obj
		end,

		remove = function(self, obj, amount)
			amount = amount or 1
			for k, v in pairs(self.__data) do
				if (v == obj) then
					self.__data[k] = nil
					self.__size = self.__size - 1
					amount = amount - 1
					if (amount == 0) then
						break
					end
				end
			end
			modifiable_array_mixin.appended_methods.__reorganize_data(self)
		end,

		remove_all = function(self, obj)
			for k, v in pairs(self.__data) do
				if (v == obj) then
					self.__data[k] = nil
					self.__size = self.__size - 1
				end
			end
			modifiable_array_mixin.appended_methods.__reorganize_data(self)
		end,

		remove_last = function(self)
			self.__data[self.__size] = nil
			self.__size = self.__size - 1
		end,

		remove_at = function(self, index)
			self.__data[index] = nil
			modifiable_array_mixin.appended_methods.__reorganize_data(self)
		end,

		first = function(self)
			return self.__data[1]
		end,

		last = function(self)
			return self.__data[self.__size]
		end,

		get = function(self, index)
			return self.__data[index]
		end,

		get_random_element = function(self, seed)
			if (seed) then
				randomseed(seed)
			end
			return self.__data[random(1, self.__size)]
		end,

		add_all = function(self, array)
			for _, obj in pairs(array.__data) do
				self:add(obj)
			end
		end,
	}
}

return modifiable_array_mixin
