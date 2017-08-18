local class = require("riritools.lua.class")
local socket = require("builtins.scripts.socket")

local local_data_transfer = class("rt.local_data_transfer")

function local_data_transfer:__initialize(target_ip)
	self.__target_ip = target_ip
	self.__socket = socket.tcp()

	pprint("AM HERE")
end

function local_data_transfer:setup(set_callback)
	--self.__socket:bind
end

function local_data_transfer:send(data)

end

function local_data_transfer:receive()

end

function local_data_transfer:close()
	self.__socket:close()
end

return local_data_transfer
