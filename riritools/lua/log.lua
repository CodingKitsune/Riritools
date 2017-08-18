local table_utils = require("riritools.lua.table_utils")

local pprint = pprint

local log = {
	clear = nil,
	print = nil,
	contents = "",
	__print_count = 0,
}

log.clear = function()
	log.contents = ""
	log.__print_count = 0
end

log.print = function(...)
	log.__print_count = log.__print_count + 1
	if (log.__print_count > 20)  then
		log.clear()
	end
	pprint(...)
	local arguments = {...}
	local log_text = ""
	for _, v in pairs(arguments) do
		if (type(v) == "table") then
			log_text = log_text..table_utils.serialize(v)
		else
			log_text = log_text..tostring(v)
		end
	end
	log.contents = log_text.."\n"..log.contents
end


return log
