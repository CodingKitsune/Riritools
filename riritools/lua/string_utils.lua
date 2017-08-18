local table_utils = require("riritools.lua.table_utils")

local gsub = string.gsub
local find = string.find
local format = string.format
local pairs = pairs

local string = table_utils.make_read_only_table {

	trim = function(stringToTrim)
		return gsub(stringToTrim, "%s+", "")
	end,

	trim_to_letters = function(stringToTrim)
		return gsub(stringToTrim, "%A+", "")
	end,

	trim_to_alphanumeric = function(stringToTrim)
		return gsub(stringToTrim, "%W+", "")
	end,

	split = function(stringToSplit, sep)
	    sep = sep or ":"
	    local fields = {}
	    local pattern = format("([^%s]+)", sep)
	    gsub(stringToSplit, pattern, function(c) fields[#fields+1] = c end)
		return fields
	end,

	split_f = function(stringToSplit, sep, func)
	    sep = sep or ":"
	    local pattern = format("([^%s]+)", sep)
	    gsub(stringToSplit, pattern, func)
	end,

	closest_string = function(targetString, list)
		local weights = {}
		local biggestWeight = -1
		for _, value in pairs(list) do
			for i=#value, 1, -1 do
				local bufferString = string.sub(value, 1, i)
				if (find(targetString, bufferString)) then
					weights[i] = weights[i] or {}
					table.insert(weights[i], value)
					if (i > biggestWeight) then
						biggestWeight = i
					end
				end
			end
		end
		return (biggestWeight > -1) and weights[biggestWeight] or nil
	end

}

return string
