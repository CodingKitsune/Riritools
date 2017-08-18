local class = require("riritools.lua.class")
local string_utils = require("riritools.lua.string_utils")

local table_file_manager = class("table_file_manager")

function table_file_manager:__initialize()
	self.schema = {}
	self.default = {}
end

function table_file_manager:pack_unpack(target, data)
	for _, value in pairs(self.schema) do
		target[value] = data[value]
	end
end

function table_file_manager:save(data, filename)
	filename = filename or "game.table"
	local save = {}
	self:pack_unpack(save, data)
	local folder = string_utils.trim(sys.get_config("project.title"))
	local file_path = sys.get_save_file(folder, filename)
	if (not sys.save(file_path, save)) then
		error("[ERROR] - Could not save file!")
	end
end

function table_file_manager:load(data, filename)
	filename = filename or "game.table"
	local folder = string_utils.trim(sys.get_config("project.title"))
	local file_path = sys.get_save_file(folder, filename)
	local save_data = sys.load(file_path)
	self:pack_unpack(data, save_data)
	self:verify_data(data)
end

function table_file_manager:verify_data(data)
	for key, value in pairs(self.default) do
		if (data[key] == nil) then
			data[key] = value
		end
	end
end

function table_file_manager:reset(data)
	for key, _ in pairs(data) do
		data[key] = nil
	end
	for key, _ in pairs(self.default) do
		data[key] = self.default[key]
	end
end

return table_file_manager
