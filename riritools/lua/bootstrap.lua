local table_utils = require("riritools.lua.table_utils")
local rt_urls = require("riritools.lua.riritools_urls")
local rt_msgs = require("riritools.lua.riritools_msgs")
local d_msgs = require("riritools.lua.defold_msgs")

local function send_init_messages(obj)
	rt_urls.initialize()
	msg.post("main:/screens#common_ui", d_msgs.LOAD)
	msg.post(rt_urls.GO_PLAYER, rt_msgs.PLAYER_INIT)
	msg.post(rt_urls.SCREEN_MANAGER, rt_msgs.SCREEN_MANAGER_INIT)
	msg.post(rt_urls.LEVEL_MANAGER, rt_msgs.LEVEL_MANAGER_INIT)
	obj.rt_bs_init_components = 0
	obj.rt_bs_is_init = false
end

local function init(obj, first_screen)
	obj.rt_bs_first_screen = first_screen
	obj.rt_bs_init = 1
	send_init_messages(obj)
end

local function init2(obj, screen_options, transition_in_options)
	obj.rt_bs_screen_options = screen_options
	obj.rt_bs_transition_options = transition_in_options
	obj.rt_bs_init = 2
	send_init_messages(obj)
end

local function on_message(obj, message_id, _, sender)
	if (message_id == rt_msgs.SCREEN_MANAGER_INIT_DONE) then
		if (obj.rt_bs_init == 1) then
			msg.post(rt_urls.SCREEN_MANAGER, rt_msgs.PUSH_SCREEN, {screen=obj.rt_bs_first_screen})
			msg.post(rt_urls.TRANSITION_MANAGER, rt_msgs.TRANSITION_IN, {})
		elseif (obj.rt_bs_init == 2) then
			msg.post(rt_urls.SCREEN_MANAGER, rt_msgs.PUSH_SCREEN, obj.rt_bs_screen_options)
			msg.post(rt_urls.TRANSITION_MANAGER, rt_msgs.TRANSITION_IN, obj.rt_bs_transition_options)
		end
		obj.rt_bs_init_components = obj.rt_bs_init_components + 1
	elseif (message_id == rt_msgs.LEVEL_MANAGER_INIT_DONE) then
		obj.rt_bs_init_components = obj.rt_bs_init_components + 1
	elseif (message_id == rt_msgs.PLAYER_INIT_DONE) then
		obj.rt_bs_init_components = obj.rt_bs_init_components + 1
	elseif (message_id == d_msgs.PROXY_LOADED) then
		msg.post(sender, d_msgs.ENABLE)
		obj.rt_bs_init_components = obj.rt_bs_init_components + 1
	elseif (message_id == rt_msgs.RIRITOOLS_INIT_DONE) then
		go.delete()
		collectgarbage("step", 1)
	end
	if (obj.rt_bs_init_components == 4 and not obj.rt_bs_is_init) then
		obj.rt_bs_is_init = true
		msg.post(".", rt_msgs.RIRITOOLS_INIT_DONE)
	end
end

local bootstrap = table_utils.make_read_only_table {
	init = init,
	init2 = init2,
	on_message = on_message
}

return bootstrap
