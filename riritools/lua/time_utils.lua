local table_utils = require("riritools.lua.table_utils")

local floor = math.floor

local time = table_utils.make_read_only_table {

	milliseconds_to_seconds = function(milliseconds)
		return (milliseconds * 0.001)
	end,

	milliseconds_to_minutes = function(milliseconds)
		return (milliseconds * 0.00001666666)
	end,

	milliseconds_to_hours = function(milliseconds)
		return (milliseconds * 0.000000277777778)
	end,

	seconds_to_milliseconds = function(secs)
		return secs * 1000
	end,

	seconds_to_minutes = function(secs)
		return secs * 0.01666666666
	end,

	seconds_to_hours = function(secs)
		return secs * 0.00027777777
	end,

	minutes_to_milliseconds = function(mins)
		return mins * 60000
	end,

	minutes_to_seconds = function(mins)
		return mins * 60
	end,

	minutes_to_hours = function(mins)
		return mins * 0.01666666666
	end,

	hours_to_milliseconds = function(hours)
		return hours * 3600000
	end,

	hours_to_seconds = function(hours)
		return hours * 3600
	end,

	hours_to_minutes = function(hours)
		return hours * 60
	end,

	milliseconds_in_seconds = function(seconds)
		return floor(seconds * 1000)
	end,

	milliseconds_in_minutes = function(minutes)
		return floor(minutes * 60000)
	end,

	milliseconds_in_hours = function(hours)
		return floor(hours * 3600000)
	end,

	seconds_in_milliseconds = function(milliseconds)
		return floor(milliseconds * 0.001)
	end,

	seconds_in_minutes = function(minutes)
		return floor(minutes * 60)
	end,

	seconds_in_hours = function(hours)
		return floor(hours * 3600)
	end,

	minutes_in_milliseconds = function(milliseconds)
		return floor(milliseconds * 0.00001666666)
	end,

	minutes_in_seconds = function(seconds)
		return floor(seconds * 0.01666666666)
	end,

	minutes_in_hours = function(hours)
		return floor(hours * 60)
	end,

	hours_in_milliseconds = function(milliseconds)
		return floor(milliseconds * 0.000000277777778)
	end,

	hours_in_seconds = function(seconds)
		return floor(seconds * 0.00027777777)
	end,

	hours_in_minutes = function(minutes)
		return floor(minutes * 0.01666666666)
	end,
}

return time
