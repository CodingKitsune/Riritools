local class = require("riritools.lua.class")

local state_machine = class("rt.state_machine")

function state_machine:__initialize()
	self.before_change_function = nil
	self.before_change_function_args = nil
	self.after_change_function = nil
	self.after_change_function_args = nil
	self.__state = nil
	self.__last_state = nil
	self.__vars = {}
	self.__states = {}
end

function state_machine:register_state(state, transition_table, condition_set)
	self.__states[state] = {transition_table, condition_set}
end

function state_machine:update(input_vars)
	self.__vars = input_vars
	if (self.__state) then
		for _, value in ipairs(self.__states[self.__state][1]) do
			if (self.__state ~= value and self:check_condition(value)) then
				if (self.before_change_function) then
					self.before_change_function(self, self.before_change_function_args or {})
				end
				self.__last_state = self.__state
				self.__state = value
				if (self.after_change_function) then
					self.after_change_function(self, self.after_change_function_args or {})
				end
				break
			end
		end
	end
end

function state_machine:check_condition(state)
	if (self.__states[state]) then
		for _, value in ipairs(self.__states[state][2]) do
			if (not value[1](self.__vars[value[2]], value[3])) then
				return false
			end
		end
		return true
	else
		return false
	end
end

function state_machine:get_state()
	return self.__state
end

function state_machine:get_last_state()
	return self.__last_state
end

function state_machine:set_state(state)
	if (self.__states[state]) then
		if (self.before_change_function) then
			self.before_change_function(self, self.before_change_function_args or {})
		end
		self.__last_state = state
		self.__state = state
		if (self.after_change_function) then
			self.after_change_function(self, self.after_change_function_args or {})
		end
	end
end

return state_machine
