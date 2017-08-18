local class = require("riritools.lua.class")
local rt_urls = require("riritools.lua.riritools_urls")
local rt_msgs = require("riritools.lua.riritools_msgs")
local table_utils = require("riritools.lua.table_utils")

local pushed_screen = rt_msgs.PUSHED_SCREEN
local popped_screen = rt_msgs.POPPED_SCREEN
local enabled_screen = rt_msgs.ENABLED_SCREEN
local disabled_screen = rt_msgs.DISABLED_SCREEN
local find = table_utils.find

local ipairs=ipairs
local post=msg.post

local screen_connector_manager = class("rt.screen_connector_manager")

screen_connector_manager.static.connectors = {}
screen_connector_manager.static.active_screens = {}
screen_connector_manager.static.global_connectors = {}

local connectors = screen_connector_manager.static.connectors
local active_screens = screen_connector_manager.static.active_screens
local global_connectors = screen_connector_manager.static.global_connectors

function screen_connector_manager:__initialize()
	post(rt_urls.SCREEN_MANAGER, rt_msgs.WARN_SCREEN_CHANGES)
end

function screen_connector_manager:update(player, dt)
	local connector
	for _, screen in ipairs(active_screens) do
		connector = connectors[screen]
		if (connector) then
			connector:update(player, dt)
		end
	end
	for _, global_connector in ipairs(global_connectors) do
		global_connector:update(player, dt)
	end
end

function screen_connector_manager:on_message(player, message_id, message, sender)
	local screen = message.screen
	if (screen and connectors[screen]) then
		if (message_id == pushed_screen) then
			table.insert(active_screens, screen)
			connectors[screen]:init(player)
		elseif (message_id == popped_screen) then
			connectors[screen]:final(player)
			table.remove(active_screens, find(active_screens, screen))
		elseif (message_id == enabled_screen) then
			connectors[screen]:on_enable(player)
		elseif (message_id == disabled_screen) then
			connectors[screen]:on_disable(player)
		end
	end

	local connector
	for _, active_screen in ipairs(active_screens) do
		connector = connectors[active_screen]
		if (connector) then
			connector:on_message(player, message_id, message, sender)
		end
	end

	for _, global_connector in ipairs(global_connectors) do
		global_connector:on_message(player, message_id, message, sender)
	end
end

function screen_connector_manager:on_input(player, action_id, action)
	local connector
	for _, screen in ipairs(active_screens) do
		connector = connectors[screen]
		if (connector) then
			connector:on_input(player, action_id, action)
		end
	end

	for _, global_connector in ipairs(global_connectors) do
		global_connector:on_input(player, action_id, action)
	end
end

function screen_connector_manager:final(player)
	local connector
	for _, screen in ipairs(active_screens) do
		connector = connectors[screen]
		if (connector) then
			connector:final(player)
		end
	end
	for _, global_connector in pairs(global_connectors) do
		global_connector:final(player)
	end
end

function screen_connector_manager:on_reload(player)
	local connector
	for _, screen in ipairs(active_screens) do
		connector = connectors[screen]
		if (connector) then
			connector:final(player)
		end
	end
	for _, global_connector in ipairs(global_connectors) do
		global_connector:on_reload(player)
	end
end

return screen_connector_manager
