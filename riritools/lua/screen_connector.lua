local class = require("riritools.lua.class")

local screen_connector = class("rt.screen_connector")

function screen_connector:__initialize(screen)
	self.screen = screen
end

function screen_connector:init()
end

function screen_connector:update()
end

function screen_connector:on_message()
end

function screen_connector:on_input()
end

function screen_connector:on_reload()
end

function screen_connector:final()
end

function screen_connector:on_enable()
end

function screen_connector:on_disable()
end

return screen_connector
