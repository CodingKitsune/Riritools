local table_utils = require("riritools.lua.table_utils")

local synchronizers = {}

local insert = table.insert
local remove = table.remove
local clock = os.clock

local function make_synchronizer()
	return {factories={}, objects={}, recycle_bin={}, types={}, responses={}, active=false, type=nil}
end

local function register_factory(url_factory, sync_id)
	local synchro = synchronizers[sync_id] or make_synchronizer()
	synchronizers[sync_id] = synchro
	local id = #synchro.factories+1
	synchro.factories[id] = url_factory
	return id
end

local function register_type(properties, factory_id, on_spawn_func, sync_id)
	local synchro = synchronizers[sync_id] or make_synchronizer()
	synchronizers[sync_id] = synchro
	local id = #synchro.types+1
	synchro.types[id] = {properties, factory_id, on_spawn_func}
	return id
end

--property = {id, get, set, type}
local function register_go(self, type, sync_id, extra_data, new_id)
	local synchro = synchronizers[sync_id] or make_synchronizer()
	synchronizers[sync_id] = synchro
	local recycle_bin = synchro.recycle_bin
	local recycle_bin_size = #recycle_bin
	local object_id
	if (new_id) then
		object_id = new_id
	else
		if (recycle_bin_size > 1) then
			object_id = recycle_bin[recycle_bin_size]
			remove(recycle_bin, recycle_bin_size)
		else
			object_id = #synchro.objects + 1
		end
	end
	synchro.objects[object_id] = {self, type, {}, extra_data}
	return object_id
end

local function remove_go(object_id, sync_id)
	local synchro = synchronizers[sync_id]
	if (synchro) then
		synchronizers[sync_id].objects[object_id] = nil
		insert(synchronizers[sync_id].recycle_bin, object_id)
	end
end

local function get(sync_id)
	return synchronizers[sync_id]
end

local function reset(sync_id)
	synchronizers[sync_id] = nil
end

local function add_response(on_response_func, on_response_func_arg, response_type, sync_id)
	local synchro = synchronizers[sync_id] or make_synchronizer()
	synchronizers[sync_id] = synchro
	--time_stamp, value, response_func, on_response_func_arg, response_type
	local id = #synchro.responses + 1
	synchro.responses[id] = {clock(), nil, on_response_func, on_response_func_arg, response_type}
	return id
end

local function set_response_value(id, value, sync_id)
	local synchro = synchronizers[sync_id] or make_synchronizer()
	synchronizers[sync_id] = synchro
	local response = synchro.responses[id]
	response[1] = (response[2] ~= value) and clock() or response[1]
	response[2] = value
end

local function is_active(sync_id)
	local synchro = synchronizers[sync_id]
	return (synchro and synchro.active)
end

local function is_slave(sync_id)
	local synchro = synchronizers[sync_id]
	return (synchro and synchro.type == 1)
end

local function is_master(sync_id)
	local synchro = synchronizers[sync_id]
	return (synchro and synchro.type == 0)
end

local function set_disconnect_function(disconnect_func, arg, sync_id)
	local synchro = synchronizers[sync_id] or make_synchronizer()
	synchronizers[sync_id] = synchro
	synchro.disconnect_func = {disconnect_func, arg}
end

local repository = table_utils.make_read_only_table {
	register_factory = register_factory,
	register_type = register_type,
	register_go = register_go,
	remove_go = remove_go,
	add_response = add_response,
	set_response_value = set_response_value,
	set_disconnect_function = set_disconnect_function,
	get = get,
	reset = reset,
	is_active = is_active,
	is_slave = is_slave,
	is_master = is_master,
}

return repository
