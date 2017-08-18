local class = require("riritools.lua.class")
local chronometer = require("riritools.lua.chronometer")
local time = require("riritools.lua.time_utils")

local regressive_chronometer = class("rt.regressive_chronometer", chronometer)

local floor = math.floor
local milliseconds_to_seconds = time.milliseconds_to_seconds
local seconds_to_milliseconds = time.seconds_to_milliseconds
local seconds_to_minutes = time.seconds_to_minutes
local seconds_to_hours = time.seconds_to_hours
local hours_in_seconds = time.hours_in_seconds
local minutes_in_seconds = time.minutes_in_seconds
local hours_to_seconds = time.hours_to_seconds
local minutes_to_seconds = time.minutes_to_seconds
local milliseconds_in_seconds = time.milliseconds_in_seconds

function regressive_chronometer:__initialize(secs, is_auto_update)
	chronometer.__initialize(self, 0, is_auto_update)
	self.__seconds_left = secs or 0
end

function regressive_chronometer:update(dt)
	chronometer.update(self, dt)
	if (self.__secs >= self.__seconds_left) then
		self:pause()
		self.__secs = self.__seconds_left
	end
end

function regressive_chronometer:set_milliseconds_left(milliseconds)
	self.__seconds_left = milliseconds_to_seconds(milliseconds)
end

function regressive_chronometer:set_seconds_left(secs)
	self.__seconds_left = secs
end

function regressive_chronometer:as_milliseconds_left()
	return seconds_to_milliseconds(self.__seconds_left) - self:as_milliseconds()
end

function regressive_chronometer:as_seconds_left()
	return self.__seconds_left - chronometer.as_seconds(self)
end

function regressive_chronometer:as_minutes_left()
	return seconds_to_minutes(self.__seconds_left) - self:as_minutes()
end

function regressive_chronometer:as_hours_left()
	return seconds_to_hours(self.__seconds_left) - self:as_hours()
end

function regressive_chronometer:get_hours_left()
	return hours_in_seconds(self.__seconds_left - self.__secs)
end

function regressive_chronometer:get_minutes_left()
	return minutes_in_seconds(self.__seconds_left - self.__secs - hours_to_seconds(self:get_hours_left()))
end

function regressive_chronometer:get_seconds_left()
	return floor(self.__seconds_left - self.__secs - hours_to_seconds(self:get_hours_left())
			 - minutes_to_seconds(self:get_minutes_left()))
end

function regressive_chronometer:get_milliseconds_left()
	return milliseconds_in_seconds(self.__seconds_left - self.__secs - hours_to_seconds(self:get_hours_left())
		- minutes_to_seconds(self:get_minutes_left()) - self:get_seconds_left())
end

return regressive_chronometer
