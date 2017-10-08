local class = require("riritools.lua.class")
local rt_msgs = require("riritools.lua.riritools_msgs")
local rt_urls = require("riritools.lua.riritools_urls")
local d_msgs = require("riritools.lua.defold_msgs")

local animation_sound = class("rt.animation_sound")

local warn = rt_msgs.SET_WARN_CHANGE_CONFIG_FIELD
local changed_config_field = rt_msgs.CHANGED_CONFIG_FIELD
local rt_play_sound = rt_msgs.PLAY_SOUND
local set_gain = d_msgs.SET_GAIN
local register_msg = {field = "se_volume", value = true}
local post = msg.post
local player

function animation_sound:__initialize()
	player = player or rt_urls.GO_PLAYER
	self.__sounds = {}
	self.__current_animation = ""
	post(player, warn, register_msg)
end

function animation_sound:register_sound(animation_name, sound_component_name)
	self.__sounds[animation_name] = sound_component_name
end

function animation_sound:update(current_animation)
	if (self.__current_animation ~= current_animation) then
		self.__current_animation = current_animation
		post("#sound_"..self.__current_animation, rt_play_sound)
	end
end

function animation_sound:on_message(message_id, message)
	if (message_id == changed_config_field) then
		post("#sound_"..self.__current_animation, set_gain, {gain = message.value})
	end
end

return animation_sound
