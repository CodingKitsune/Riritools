local class = require("riritools.lua.class")
local queue = require("riritools.lua.queue")
local stepper = class("rt.stepper")

local function dummy_checker()
	return true
end

function stepper:__initialize()
	self.__todo = queue:new()
	self.__last_checker = dummy_checker
end

function stepper:add_step(todo_function, checker_function)
	self.__todo:push({todo_function, checker_function or dummy_checker})
	return self
end

stepper.after = stepper.add_step

function stepper:start()
	if (self.__todo:size() > 0 and self.__last_checker()) then
		self.__last_checker = self.__todo:first()[2]
		self.__todo:pop()[1]()
		self:start()
	end
end

function stepper:update()
	if (self.__todo:size() > 0 and self.__last_checker()) then
		self.__last_checker = self.__todo:first()[2]
		self.__todo:pop()[1]()
	end
end

function stepper:size()
	return self.__todo:size()
end

return stepper
