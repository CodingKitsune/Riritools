local class = require("riritools.lua.class")
local queue = require("riritools.lua.queue")
local d_msgs = require("riritools.lua.defold_msgs")

local animation_done = d_msgs.ANIMATION_DONE
local play_animation = d_msgs.PLAY_ANIMATION
local gmatch = string.gmatch

local animation_queue = class("rt.animation_queue")

local hash = hash
local post = msg.post

function animation_queue:__initialize()
	self.component = nil
	self.animation_collision_updater = nil
	self.animation_sound = nil
	self.before_change_function = nil
	self.before_change_function_args = nil
	self.after_change_function = nil
	self.after_change_function_args = nil

	self.__todo = queue:new()
	self.__current_animation = nil
end

function animation_queue:__start_animation()
	local animation = self.__todo:pop()
	if (self.before_change_function and self.__current_animation ~= animation) then
		self.before_change_function(self, self.before_change_function_args)
	end
	self.__current_animation = animation
	post(self.component, play_animation, {id=hash(animation)})
	self:update_collision_body(animation)
	self:update_animation_sound(animation)
	if (self.after_change_function) then
		self.after_change_function(self, self.after_change_function_args)
	end
end

function animation_queue:on_message(message_id, message)
	if (self.animation_sound) then
		self.animation_sound:on_message(message_id, message)
	end
	if (message_id == animation_done) then
		self.__current_animation = nil
		if (self.component and self.__todo:size() > 0) then
			self:__start_animation()
		end
	end
end

function animation_queue:play_animations(animation_names)
	self.__todo = queue:new()
	self.__current_animation = nil
	for token in gmatch(animation_names, "([^|]+)") do
		self.__todo:push(token)
	end
	if (self.__todo:size() > 0) then
		self:__start_animation()
	end
end

function animation_queue:get_current_animation()
	return self.__current_animation
end

function animation_queue:update_collision_body(animation)
	if (animation and self.animation_collision_updater) then
		self.animation_collision_updater:update(animation)
	end
end

function animation_queue:update_animation_sound(animation)
	if (animation and self.animation_sound) then
		self.animation_sound:update(animation)
	end
end

return animation_queue
