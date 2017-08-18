local class = require("riritools.lua.class")
local container = require("riritools.lua.container")
local default_linear_data_mixin = require("riritools.lua.container_default_linear_data_mixin")
local default_sort_mixin = require("riritools.lua.container_default_sort_mixin")
local queue_mixin = require("riritools.lua.container_queue_mixin")

local queue = class("rt.queue", container)

queue:include(default_linear_data_mixin)
queue:include(default_sort_mixin)
queue:include(queue_mixin)

return queue
