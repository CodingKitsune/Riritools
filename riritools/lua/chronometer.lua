local class = require("riritools.lua.class")
local time = require("riritools.lua.time_utils")

local floor = math.floor
local milliseconds_in_seconds = time.milliseconds_in_seconds
local seconds_to_milliseconds = time.seconds_to_milliseconds
local seconds_to_minutes = time.seconds_to_minutes
local seconds_to_hours = time.seconds_to_hours
local hours_in_seconds = time.hours_in_seconds
local minutes_in_seconds = time.minutes_in_seconds
local hours_to_seconds = time.hours_to_seconds
local minutes_to_seconds = time.minutes_to_seconds
local pairs = pairs

local chronometer = class("chronometer")

chronometer.static.states = {STOPPED=0, RUNNING=1, PAUSED=2}

local stopped = chronometer.static.states.STOPPED
local running = chronometer.static.states.RUNNING
local paused = chronometer.static.states.PAUSED

chronometer.static.auto_update_list = setmetatable({}, {__mode = "k"})

local chronometer_list = chronometer.static.auto_update_list

chronometer.static.auto_update_function = function(dt)
	for chrono, _ in pairs(chronometer_list) do
		chrono:update(dt)
	end
end

function chronometer:__initialize(secs, is_auto_update)
	self.__secs = secs or 0
	self.__state = paused
	if (is_auto_update) then
		chronometer_list[self] = true
	end
end

function chronometer:update(dt)
	if (self.__state == running) then
		self.__secs = self.__secs + dt
	end
end

function chronometer:get_state()
	return self.__state
end

function chronometer:set_state(state)
	self.__state = state
	if (state == stopped) then
		self.__secs = 0
	end
end

function chronometer:pause()
	self:set_state(paused)
end

function chronometer:resume()
	self:set_state(running)
end

function chronometer:stop()
	self:set_state(stopped)
end

function chronometer:restart()
	self.__state = running
	self.__secs = 0
end

function chronometer:as_milliseconds()
	return seconds_to_milliseconds(self.__secs)
end

function chronometer:as_seconds()
	return self.__secs
end

function chronometer:as_minutes()
	return seconds_to_minutes(self.__secs)
end

function chronometer:as_hours()
	return seconds_to_hours(self.__secs)
end

function chronometer:get_hours()
	return hours_in_seconds(self.__secs)
end

function chronometer:get_minutes()
	return minutes_in_seconds(self.__secs - hours_to_seconds(self:get_hours()))
end

function chronometer:get_seconds()
	return floor(self.__secs - hours_to_seconds(self:get_hours()) - minutes_to_seconds(self:get_minutes()))
end

function chronometer:get_milliseconds()
	return milliseconds_in_seconds(self.__secs - hours_to_seconds(self:get_hours())
		- minutes_to_seconds(self:get_minutes()) - self:get_seconds())
end

return chronometer
