local class = require("riritools.lua.class")
local container = require("riritools.lua.container")
local default_linear_data_mixin = require("riritools.lua.container_default_linear_data_mixin")
local default_sort_mixin = require("riritools.lua.container_default_sort_mixin")
local modifiable_array_mixin = require("riritools.lua.container_modifiable_array_mixin")

local array = class("rt.array", container)

function array:__initialize(initial_size, initial_value)
	initial_size = initial_size or 0
	container.__initialize(self)
	for _=1, initial_size do
		self:add(initial_value)
	end
end

array:include(default_linear_data_mixin)
array:include(default_sort_mixin)
array:include(modifiable_array_mixin)

return array
