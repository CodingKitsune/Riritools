local class = require("riritools.lua.class")
local table_utils = require("riritools.lua.table_utils")
local string_utils = require("riritools.lua.string_utils")

local getn = table.getn

local dictionary = class("rt.dictionary")
local trim_to_alphanumeric = string_utils.trim_to_alphanumeric

function dictionary:__initialize()
	self.__entries = {}
end

function dictionary:get(name)
	return self.__entries[trim_to_alphanumeric(name)]
end

function dictionary:get_size()
	return getn(self.__entries)
end

function dictionary:load(filepath)
	local json_string = sys.load_resource(filepath)
	if (json_string) then
		self.__entries = json.decode(json_string)
		self.__entries = table_utils.make_read_only_table(self.__entries)
		return true
	else
		pprint("[ERROR] - JSON file  ["..filepath.."] does not exist!")
		return false
	end
end

function dictionary:load_as_hash(filepath)
	local json = sys.load_resource(filepath)
	if (json) then
		self.__entries = {}
	    for key, _ in ipairs(json) do
			self.__entries[hash(key)] = json[key]
	    end
		return true
	else
		pprint("[ERROR] - JSON file ["..filepath.."] does not exist!")
		return false
	end
end

return dictionary
