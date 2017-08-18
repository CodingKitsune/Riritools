local table_utils = require("riritools.lua.table_utils")

local random = math.random

local registered_objects = setmetatable({}, {
	__mode = 'kv'
})

local function register(obj)
	if (obj and not obj.rid) then
		local registered = false
		local rid = 0
		while (not registered) do
			rid = random()
			if (not registered_objects[rid]) then
				registered = true
				registered_objects[rid] = true
				obj.rid = rid
			end
		end
		return rid
	end
end

local function unregister(obj)
	if (obj and obj.rid) then
		registered_objects[obj.rid] = nil
		obj.rid = nil
	end
end

local object_register = table_utils.make_read_only_table {
	register = register,
	unregister = unregister
}

return object_register
