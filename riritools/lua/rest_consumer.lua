local class = require("riritools.lua.class")
local table_utils = require("riritools.lua.table_utils")

local rest_consumer = class("rt.rest_consumer")

function rest_consumer:__initialize(url, port)
	self.url = url or "http://127.0.01"
	self.port = port or "8080"
	self.default_headers = {}
	self.default_data = {}
	self.default_callback = nil
	self.auto_serialize = true
	self.timeout = 1000
	self.default_serialize_request_to = nil
	self.default_serialize_response_to = nil
end

function rest_consumer:__do_http_method(method, service_name, callback, headers, data,
			serialize_request_to, serialize_response_to)
	headers = headers or {}
	data = data or {}
	callback = callback or self.default_callback
	serialize_request_to = serialize_request_to or self.default_serialize_request_to
	serialize_response_to = serialize_response_to or self.default_serialize_response_to
	local sent_headers = {}
	local sent_data = {}
	table_utils.mix_into(sent_headers, self.default_headers)
	table_utils.mix_into(sent_headers, headers)
	table_utils.mix_into(sent_data, self.default_data)
	table_utils.mix_into(sent_data, data)
	setmetatable(sent_data, getmetatable(self.default_data))
	setmetatable(sent_data, getmetatable(data))
	if (self.auto_serialize) then
		sent_headers["Content-Type"] = "application/json"

		if (serialize_request_to) then
			sent_data.class = serialize_request_to
			setmetatable(sent_data, serialize_request_to.__instanceDict)
		end

		local sent_json = sent_data.class and sent_data:serialize()
			or table_utils.serialize(sent_data)
		local serializable_callback = function(self, id, response)
			if (response.status ~= 0) then
				response.response = class.deserialize(response.response)
				if (serialize_response_to) then
					response.response.class = serialize_response_to
					setmetatable(response.response, serialize_response_to.__instanceDict)
				end
			end
			callback(self, id, response)
		end
		http.request(self.url..":"..self.port.."/"..service_name, method, 
			serializable_callback, sent_headers, sent_json,{timeout=self.timeout})
	else
		http.request(self.url..":"..self.port.."/"..service_name, method, 
			callback, sent_headers, sent_data, {timeout=self.timeout})
	end
end

function rest_consumer:get(service_name, callback, headers, 
		serialize_request_to, serialize_response_to)
	self:__do_http_method("GET", service_name, callback, headers, 
			serialize_request_to, serialize_response_to)
end

function rest_consumer:post(service_name, callback, headers,
		data, serialize_request_to, serialize_response_to)
	self:__do_http_method("POST", service_name, callback, headers, 
		data, serialize_request_to, serialize_response_to)
end

function rest_consumer:put(service_name, callback, headers,
		data, serialize_request_to, serialize_response_to)
	self:__do_http_method("PUT", service_name, callback, headers,
		data, serialize_request_to, serialize_response_to)
end

function rest_consumer:delete(service_name, callback, headers,
		data,serialize_request_to, serialize_response_to)
	self:__do_http_method("DELETE", service_name, callback, headers,
		data, serialize_request_to, serialize_response_to)
end

function rest_consumer:patch(service_name, callback, headers,
			data, serialize_request_to, serialize_response_to)
	self:__do_http_method("PATCH", service_name, callback, headers,
		data, serialize_request_to, serialize_response_to)
end

return rest_consumer
