local socket = require("builtins.scripts.socket")
local class = require("riritools.lua.class")
local regressive_chronometer = require("riritools.lua.regressive_chronometer")
local routine_function = require("riritools.lua.routine_function")
local json = require("riritools.lua.json")
local hasher = require("riritools.lua.hasher")

local local_player_finder = class("rt.local_player_finder")

local decode = json.decode
local c_yield = coroutine.yield
local c_status = coroutine.status
local c_resume = coroutine.resume
local pairs = pairs
local tonumber = tonumber
local pcall = pcall

local function copy_player(player)
	return {
		ip = player.ip,
		port = player.port,
		name = player.name,
		id = player.id,
		action = player.action,
		game = player.game,
	}
end

local function copy_player_list(list)
	local new_list = {}
	for ip, player in pairs(list) do
		if (player) then
			new_list[ip] = copy_player(player)
		end
	end
	return new_list
end

local function get_message_from_data(data, hasher_instance)
	return decode(hasher_instance:decode(data))
end

local function listener_coroutine(state, listener, hasher, player, player_list, kill_list, ttl, on_player_found, on_player_found_arg, listen_func, listen_func_arg)
	local data, ip, port, is_converted, message
	while state.running do
		listener:settimeout(0)
		data, ip, port = listener:receivefrom()
		if (data) then
			is_converted, message = pcall(get_message_from_data, data, hasher)
			if (is_converted) then
				if ((not state.paused) and tonumber(message.id) and (message.action == "broadcast") and (message.game == player.game)) then
					if (message.id == player.id) then
						player.ip = ip
						player.port = port
					else
						if kill_list[ip] then
							local old_player = player_list[ip]
							if (message.id == old_player.id and message.name == old_player.name) then
								kill_list[ip] = nil
								old_player.ttl:restart()
							end
						elseif (not player_list[ip]) then
							message.ip = ip
							message.port = port
							message.ttl = regressive_chronometer:new(ttl)
							message.ttl:restart()
							player_list[ip] = message
							if (on_player_found) then
								on_player_found(message, copy_player_list(player_list), on_player_found_arg)
							end
						end
					end
				end
				if (listen_func) then
					listen_func(ip, port, message, hasher, player_list, listen_func_arg)
				end
			end
		end
		c_yield()
	end
	listener:close()
end

local function broadcaster_coroutine(state, broadcaster, hasher, broadcast_table, broadcast_string, port, broadcast_func, broadcast_func_arg)
	local success, error_msg
	while state.running do
		success = true
		if (not state.paused) then
			success, error_msg = broadcaster:sendto(broadcast_string, "255.255.255.255", port)
		end
		if (broadcast_func) then
			broadcast_func(broadcaster, hasher, broadcast_table, broadcast_string, port, broadcast_func_arg)
		end
		if (success) then
			c_yield()
		else
			state.running = false
		end
	end
	broadcaster:close()
end

local function disconnect_players(self)
	for ip, player in pairs(self.__players_to_kill) do
		if player then
			self.__player_list[ip] = nil
			self.__players_to_kill[ip] = nil
			if (self.__on_player_disconnect) then
				self.__on_player_disconnect(player, self.__player_list, self.__on_player_disconnect_arg)
			end
		end
	end
end

function local_player_finder:__initialize(params)
	math.randomseed(os.time())
	params = params or {}
	self.__on_player_found = params.on_player_found
	self.__on_player_found_arg = params.on_player_found_arg
	self.__on_player_disconnect = params.on_player_disconnect
	self.__on_player_disconnect_arg = params.on_player_disconnect_arg
	self.__player_time_to_live = params.player_time_to_live or 10
	self.__custom_listen_function = params.custom_listen_function
	self.__custom_listen_function_arg = params.custom_listen_function_arg
	self.__custom_broadcast_function = params.custom_broadcast_function
	self.__custom_broadcast_function_arg = params.custom_broadcast_function_arg
	self.__listener_port = params.listener_port or 50000
	self.__broadcaster_port = params.broadcaster_port or 50001
	self.__hasher_class = params.hasher_class or hasher
	self.__secret = params.secret or ""
	self.__hasher = self.__hasher_class:new(self.__secret)

	self.__player = {
		game = sys.get_config("project.title"),
		action = "broadcast",
		name = params.name or "player",
		id = math.random(0, 999999),
	}
	self.__player_list = {}
	self.__players_to_kill = {}
	self.__state = { running = true, paused = false }
	self.__broadcast_message_string = self.__hasher:encode(json.encode(self.__player))

	self.__listener = socket.udp()
	self.__listener:setsockname("*", self.__listener_port)
	self.__listener:settimeout(0)

	self.__listener_coroutine = coroutine.create(listener_coroutine)
	c_resume(self.__listener_coroutine, self.__state, self.__listener, self.__hasher, self.__player, self.__player_list, self.__players_to_kill, self.__player_time_to_live, self.__on_player_found, self.__on_player_found_arg, self.__custom_listen_function, self.__custom_listen_function_arg)

	self.__broadcaster = socket.udp()
	self.__broadcaster:setsockname("*", self.__broadcaster_port)
	self.__broadcaster:setoption("broadcast", true)
	self.__broadcaster:settimeout(0)
	self.__broadcaster_coroutine = coroutine.create(broadcaster_coroutine)
	c_resume(self.__broadcaster_coroutine, self.__state, self.__broadcaster, self.__hasher, self.__player, self.__broadcast_message_string, self.__listener_port, self.__custom_broadcast_function, self.__custom_broadcast_function_arg)

	self.__disconnect_routine = routine_function:new(4, disconnect_players, self)

end

function local_player_finder:get_broadcasting_player()
	return self.__player and copy_player(self.__player)
end

function local_player_finder:get_player_list()
	return copy_player_list(self.__player_list)
end

function local_player_finder:get_broadcasting_message_string()
	return self.__broadcast_message_string
end

function local_player_finder:close()
	self.__state.running = false
	self.__broadcaster:close()
	self.__listener:close()
end

function local_player_finder:pause()
	self.__state.paused = true
end

function local_player_finder:resume()
	self.__state.paused = false
end

function local_player_finder:is_closed()
	return not self.__state.running
end

function local_player_finder:update(dt)
	if (self.__state.running) then
		if (c_status(self.__listener_coroutine) == "suspended") then
			c_resume(self.__listener_coroutine, self.__state, self.__listener, self.__hasher, self.__player, self.__player_list, self.__players_to_kill, self.__player_time_to_live, self.__on_player_found, self.__on_player_found_arg, self.__custom_listen_function, self.__custom_listen_function_arg)
		end
		if (c_status(self.__broadcaster_coroutine) == "suspended") then
			c_resume(self.__broadcaster_coroutine, self.__state, self.__broadcaster, self.__hasher, self.__player, self.__broadcast_message_string, self.__listener_port, self.__custom_broadcast_function, self.__custom_broadcast_function_arg)
		end
		for ip, player in pairs(self.__player_list) do
			if (player) then
				player.ttl:update(dt)
				if (player.ttl:as_seconds_left() <= 0) then
					self.__players_to_kill[ip] = player
				end
			end
		end
		self.__disconnect_routine:update(dt)
	end
end

return local_player_finder
