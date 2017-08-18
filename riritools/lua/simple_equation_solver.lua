local class = require("riritools.lua.class")

local simple_equation_solver = class("rt.simple_equation_solver")

local loadstring = loadstring
local gsub = string.gsub
local pairs = pairs

function simple_equation_solver:__initialize(equation)
	self.__equation = equation
	self.__prepared_equation = equation
	self.__cached = false
	self.__cached_result = 0
end

function simple_equation_solver:set_equation(equation)
	self.__equation = equation
	self:reset()
end

function simple_equation_solver:reset()
	self.__prepared_equation = self.__equation
	self.__cached = false
end

function simple_equation_solver:set(var_name, value)
	self.__cached = false
	self.__prepared_equation = gsub(self.__prepared_equation, "@"..var_name, value)
end

function simple_equation_solver:set_many(var_table)
	for k, v in pairs(var_table) do
		self.__prepared_equation = gsub(self.__prepared_equation, "@"..k, v)
	end
	self.__cached = false
end

function simple_equation_solver:result()
	if (self.__cached) then
		return self.__cached_result
	end
	self.__cached = true
	self.__cached_result = loadstring("return "..self.__prepared_equation)()
	return self.__cached_result
end

return simple_equation_solver
