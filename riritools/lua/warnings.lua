local class = require("riritools.lua.class")

local engine_exceptions = {
	init = true,
	update = true,
	on_message = true,
	on_input = true,
	on_reload = true,
	final = true,
	__dm_script_instance__ = true,
	label = true,
	particlefx = true,
	tilemap = true,
	physics = true,
	__PhysicsContext = true,
	factory = true,
	collectionfactory = true,
	sprite = true,
	sound = true,
	spine = true,
	resource = true,
	model = true,
	window = true,
	collectionproxy = true,
}

local function allow_global_index(index)
	engine_exceptions[index] = true
end

local function disallow_global_index(index)
	engine_exceptions[index] = nil
end

setmetatable(_G, {
	__index = function(_, key)
		if (not engine_exceptions[key]) then
			msg.post("@system:", "exit", {code=1})
			error("[ERROR] - Global table non-existent index accessed: [key: "..tostring(key).."]")
		end
	end,

	__newindex = function(table, key, value)
		if (not engine_exceptions[key] and not class.get_class_by_name(key)) then
			print("[WARNING] - Global table modified: [key: "..tostring(key)..", value: "..tostring(value).."]")
		end
		rawset(table, key, value)
	end
})

local warnings = {
	allow_global_index = allow_global_index,
	disallow_global_index = disallow_global_index
}

return warnings
