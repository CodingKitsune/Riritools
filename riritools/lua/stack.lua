local class = require("riritools.lua.class")
local container = require("riritools.lua.container")
local default_linear_data_mixin = require("riritools.lua.container_default_linear_data_mixin")
local default_sort_mixin = require("riritools.lua.container_default_sort_mixin")
local stack_mixin = require("riritools.lua.container_stack_mixin")

local stack = class("rt.stack", container)

stack:include(default_linear_data_mixin)
stack:include(default_sort_mixin)
stack:include(stack_mixin)

return stack
