local class = require("riritools.lua.class")
local chronometer = require("riritools.lua.chronometer")

local pairs = pairs
local min = math.min

local linear_animator = class("rt.linear_animator")

function linear_animator:__initialize()
	self.__animations = setmetatable({}, {__mode="k"})
end

function linear_animator:update()
	for target, animations in pairs(self.__animations) do
		for property_name, animation in pairs(animations) do
			if (animation.timer:get_seconds() >= animation.transition_time) then
				animation.target[property_name] = animation.property_new_value
				if (animation.complete_function) then
					animation.complete_function(animation.target)
				end
				self.__animations[target][property_name] = nil
			else
				animation.target[property_name] = animation.initial_value +
						(animation.delta *
							(min(animation.timer:as_seconds(), animation.transition_time) / animation.transition_time)
						)
				if (animation.in_progress_function) then
					animation.in_progress_function(animation.target)
				end
			end

		end
	end
end

function linear_animator:animate(target, property_name, property_new_value, time,
								complete_function, in_progress_function)

	if (not self.__animations[target] or not self.__animations[target][property_name]) then
		self.__animations[target] = self.__animations[target] or {}
		self.__animations[target][property_name] = {}
		local animation = self.__animations[target][property_name]
		animation.timer = chronometer:new(time, true)
		animation.transition_time = time
		animation.complete_function = complete_function
		animation.in_progress_function = in_progress_function
		animation.target = target
		animation.initial_value = target[property_name]
		animation.property_new_value = property_new_value
		animation.delta = animation.property_new_value - animation.initial_value
		animation.timer:restart()
	end
end

return linear_animator
