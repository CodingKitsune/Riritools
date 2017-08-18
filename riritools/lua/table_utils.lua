local rt_json = require("riritools.lua.json")

local pairs = pairs
local sub = string.sub
local sfind = string.find
local setmetatable = setmetatable
local type = type

local closest_key_name = function(targetString, list)
	local weights = {}
	local biggestWeight = -1
	for _, value in pairs(list) do
		for i=#value, 1, -1 do
			local bufferString = sub(value, 1, i)
			if (sfind(targetString, bufferString)) then
				weights[i] = weights[i] or {}
				table.insert(weights[i], value)
				if (i > biggestWeight) then
					biggestWeight = i
				end
			end
		end
	end
	return biggestWeight > -1 and weights[biggestWeight] or nil
end

local function print_error_message(t, k, should_kill_game)
	local errorString
	if (should_kill_game == true) then
		errorString =
		"[ERROR] - Attempt to access non-existent key in read-only table: ["..tostring(t)..", key: "..tostring(k).."]"
	else
		errorString =
		"[WARNING] - Attempt to access non-existent key in read-only table: ["..tostring(t)..", key: "..tostring(k).."]"
	end
	local keys = {}
	local n = 0
	for key, _ in pairs(t) do
	  n=n+1
	  keys[n]=key
	end
	local closestStrings = closest_key_name(tostring(k), keys)
	if (closestStrings) then
		errorString = errorString.."\n Did you mean... "
		for _, value in pairs(closestStrings) do
			errorString = errorString.."["..value.."] "
		end
	end
	if (should_kill_game == true) then
		msg.post("@system:", "exit", {code=1})
		error(errorString)
	else
		print(errorString)
	end
end

local function make_warning_table(table)
	return setmetatable(table, {__index = function(t, k)
		print_error_message(t, k, false)
	end})
end

local function make_read_only_table(table)
	setmetatable(table, {__index = function(t, k)
		print_error_message(t, k, true)
	end})
	return setmetatable({}, {
		__index = table,
		__newindex = function(_, key, value)
			msg.post("@system:", "exit", {code=1})
			error(
				"[ERROR] - Attempt to modify read-only table: ["..
				tostring(table)..", key: "..tostring(key)..", value: "..tostring(value).."]"
			)
		end,
		__metatable = false
	})
end

local function make_shallow_copy(orig)
    local copy
    if type(orig) == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
			if (orig_value) then
	            copy[orig_key] = orig_value
	        end
        end
    else
        copy = orig
    end
    return copy
end

local function make_deep_copy(obj, allowed_types, seen)
	if type(obj) ~= 'table' then
		return obj
	end
	if seen and seen[obj] then
		return seen[obj]
	end
	local s = seen or {}
	local res
	if (not allowed_types or allowed_types.metatable) then
		res = setmetatable({}, getmetatable(obj))
	else
		res = {}
	end
	s[obj] = res
	for k, v in pairs(obj) do
		if (not allowed_types or allowed_types[type(v)]) then
			res[make_deep_copy(k, allowed_types, s)] = make_deep_copy(v, allowed_types, s)
		end
	end
	return res
end

local function get_table_length(obj)
	local length = 0
	for _, v in pairs(obj) do
		if (v ~= nil) then
			length = length + 1
		end
	end
	return length
end

local function remove_empty_subtables(obj, seen)
	seen = seen or {}
	for key, value in pairs(obj) do
		if (type(value) == "table") then
			if (get_table_length(value) == 0) then
				obj[key] = nil
			else
				if (seen[obj] == false) then
					obj[key] = remove_empty_subtables(value)
				end
			end
		end
	end
	seen[obj] = true
	return obj
end

local function print_table(table, indent)
	indent = indent or 0
	local formatting
	local type_k
	local type_v
	local keyString
	for key, value in pairs(table) do
		formatting = string.rep("  ", indent)
		type_k = type(key)
		type_v = type(value)
		if (type_k ~= "userdata" and type_k ~= "table") then
			keyString = ""..key
		elseif (type_k == "userdata") then
			keyString = "(unknown userdata)"
		elseif (type_k == "table") then
			keyString = "(unknown table)"
		end
		if type_v == "table" then
			pprint(formatting.. keyString .. ": {")
			print_table(value, indent+1)
			pprint(string.rep("  ", indent).."}")
		elseif type_v == "boolean" then
			pprint(formatting..keyString..": "..tostring(value).." [boolean]")
		elseif type_v == "string" then
			pprint(formatting..keyString..": \""..value.."\" [string]")
		elseif type_v == "userdata" then
			pprint(formatting..keyString..": UNKNOWN [userdata]")
		elseif type_v == "number" then
			pprint(formatting..keyString..": "..value.." [number]")
		elseif type_v == "function" then
			pprint(formatting..keyString..": UNKNOWN [function]")
		end
	end
end

local function mix_into(target, table)
	for k, v in pairs(table) do
		if (v) then
			target[k] = v
		end
	end
end

local function serialize_to_table(obj, remove_class_underscore, remove_class, seen)
	seen = seen or {}
	local serializableTable = {}
	for k, v in pairs(obj) do
		local type_v = type(v)
		if (type_v ~= "function" and type_v ~= "userdata") then
			if (type_v == "table") then
				if (not seen[obj[k]]) then
					if (rawget(v, "class") and type(v.class) == "table") then
						serializableTable[tostring(k)] = v:serialize_to_table(remove_class_underscore, remove_class)
					else
						seen[v] = true
						serializableTable[tostring(k)] = serialize_to_table(v, remove_class_underscore, remove_class, seen)
					end
				end
			else
				serializableTable[tostring(k)] = type_v == "number" and v or tostring(v)
			end
		end
	end
	return serializableTable
end

local function serialize(obj)
	return rt_json.encode(serialize_to_table(obj))
end

local function sanitize_numbers(obj, seen)
	seen = seen or {}
	for k, v in pairs(obj) do
		local type_v = type(v)
		if (type_v == "string") then
			obj[k] = tonumber(v) or v
		elseif (type_v == "table") then
			seen[v] = true
			obj[k] = sanitize_numbers(v, seen)
		end
		if (type(k) == "string") then
			local new_k = tonumber(k)
			if (new_k) then
				obj[new_k] = obj[k]
				obj[k] = nil
			end
		end
	end
	return obj
end

local function find(table, x)
	for k, v in pairs(table) do
		if (x == v) then
			return k
		end
	end
	return nil
end

local function linear_find(table, x)
	for i=1, #table do
		if (x == table[i]) then
			return i
		end
	end
	return nil
end

local function find_with(x, comp)
	for k, v in pairs(table) do
		if (comp(x, v)) then
			return k
		end
	end
	return nil
end

local table_utils = make_read_only_table {
	make_warning_table = make_warning_table,
	make_read_only_table = make_read_only_table,
	make_shallow_copy = make_shallow_copy,
	make_deep_copy = make_deep_copy,
	remove_empty_subtables = remove_empty_subtables,
	get_table_length = get_table_length,
	mix_into = mix_into,
	serialize_to_table = serialize_to_table,
	serialize = serialize,
	sanitize_numbers = sanitize_numbers,
	find = find,
	linear_find = linear_find,
	find_with = find_with,
	print = print_table
}

return table_utils
