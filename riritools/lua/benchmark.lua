local table_utils = require("riritools.lua.table_utils")

local clock = os.clock()
local unpack = unpack

 local function how_long(method, sample_size, ...)
	local start_time = clock()
	for _= 1, sample_size do
		method(...)
	end
	return clock() - start_time
end

local function how_faster(method1, method1_args, method2, method2_args, sample_size)
	local method1_time = how_long(method1, sample_size, unpack(method1_args))
	local method2_time = how_long(method2, sample_size , unpack(method2_args))
	return method2_time / method1_time
end

local benchmark = table_utils.make_read_only_table {
	how_long = how_long,
	how_faster = how_faster,
}

return benchmark
