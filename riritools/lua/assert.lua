local remove = table.remove
local type = type
local error = error
local unpack = unpack

local function assert(a, ...)
  if a then
    return a, ...
  end
  local f = ...
  if type(f) == "function" then
    local args = {...}
    remove(args, 1)
    error(f(unpack(args)), 2)
  else
    error(f or "[ERROR] - assertion failed!", 2)
  end
end

return assert
