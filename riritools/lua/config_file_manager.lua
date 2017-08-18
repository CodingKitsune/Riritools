local table_file_manager = require("riritools.lua.table_file_manager")

local config_file_manager = table_file_manager:new()

config_file_manager.default = {
	se_volume=1.0,
	bgm_volume=1.0,
	me_volume=1.0,
	bgs_volume=1.0
}

config_file_manager.schema = {
	"se_volume",
	"bgm_volume",
	"me_volume",
	"bgs_volum"
}

return config_file_manager
