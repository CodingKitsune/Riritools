local class = require("riritools.lua.class")
local container = require("riritools.lua.container")
local default_linear_data_mixin = require("riritools.lua.container_default_linear_data_mixin")
local hash_table_mixin = require("riritools.lua.container_hash_table_mixin")
local autosort_mixin = require("riritools.lua.container_default_autosort_mixin")

local map = class("rt.map", container)

map:include(default_linear_data_mixin)
map:include(hash_table_mixin)
map:include(autosort_mixin)

return map
