local transitions = {}

local insert = table.insert

local function register(...)
	for _, transition in ipairs({...}) do
		insert(transitions, transition)
	end
end

local function get_all()
	return transitions
end

local define = setmetatable({register=register, get_all=get_all}, {__call=function(_, ...) register(...) end })

return define
