local class = require("riritools.lua.class")
local container = require("riritools.lua.container")
local default_linear_data_mixin = require("riritools.lua.container_default_linear_data_mixin")
local default_sort_mixin = require("riritools.lua.container_default_sort_mixin")
local backward_modifiable_mixin = require("riritools.lua.container_backward_modifiable_mixin")
local foward_modifiable_mixin = require("riritools.lua.container_foward_modifiable_mixin")

local deque = class("rt.deque", container)
deque:include(default_linear_data_mixin)
deque:include(default_sort_mixin)
deque:include(backward_modifiable_mixin)
deque:include(foward_modifiable_mixin)

return deque
