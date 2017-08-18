local table_utils = require("riritools.lua.table_utils")
local algorithms = require("riritools.lua.algorithms")
local wh = require("riritools.lua.window_helper")

local function is_mouse_in_area(action, area_position, area_size)
	return algorithms.is_point_inside_rect({x = action.screen_x * wh.scale_x, y = action.screen_y * wh.scale_y}, {
		x = area_position.x,
		y = area_position.y,
		width = area_size.x,
		height = area_size.y
	})
end

local function is_touch_in_area(action_touch, area_position, area_size)
	local result = false
	for _,touch_event in ipairs(action_touch or {}) do
		result = algorithms.is_point_inside_rect(touch_event, {
			x = area_position.x,
			y = area_position.y,
			width = area_size.x,
			height = area_size.y
		})
		if (result) then
			break
		end
	end
	return result
end

local function is_action_in_area(mouse_position, action_touch, area_position, area_size)
	return (is_mouse_in_area(mouse_position, area_position, area_size)
		or is_touch_in_area(action_touch, area_position, area_size))
end

local function animate_shake(obj, node)
	local base_pos_x = obj.helper_shake_position[node].x
	local base_pos_y = obj.helper_shake_position[node].y
	local time = obj.helper_shake_time[node]
	if (obj.helper_shake_count[node] > 0) then
		local invert = -obj.helper_shake_inverter[node]
		local delta = obj.helper_shake_delta[node]
		gui.animate(node, "position.x", base_pos_x + (invert * delta), gui.EASING_LINEAR,
					time, 0, animate_shake)
		gui.animate(node, "position.y", base_pos_y + (invert * delta), gui.EASING_LINEAR,
					time, 0)

		obj.helper_shake_count[node] = obj.helper_shake_count[node] - 1
		obj.helper_shake_inverter[node] = invert
	elseif (obj.helper_shake_count[node] == 0) then
		gui.animate(node, "position.x",
			base_pos_x, gui.EASING_LINEAR, time, 0, function(obj_after, node_after)
				obj_after.helper_shake_count[node_after] = obj_after.helper_shake_count[node_after] - 1
			end)
		gui.animate(node, "position.y", base_pos_y, gui.EASING_LINEAR, time, 0)
	end
end

local function shake_node(obj, node, shake_delta, shake_time, shake_count)
	obj.helper_shake_count = obj.helper_shake_count or {}
	obj.helper_shake_time = obj.helper_shake_time or {}
	obj.helper_shake_delta = obj.helper_shake_delta or {}
	obj.helper_shake_inverter = obj.helper_shake_inverter or {}
	obj.helper_shake_position = obj.helper_shake_position or {}
	if (not obj.helper_shake_count[node] or obj.helper_shake_count[node] < 0) then
		obj.helper_shake_count[node] = shake_count
		obj.helper_shake_time[node] = shake_time
		obj.helper_shake_delta[node] = shake_delta
		obj.helper_shake_inverter[node] = 1
		obj.helper_shake_position[node] = gui.get_position(node)
		animate_shake(obj, node)
	end
end

local function shake_gui_component(obj, component, shake_delta, shake_time, shake_count)
	shake_node(obj, component.__base_node, shake_delta, shake_time, shake_count)
end

local function animate_zoom_bounce(obj, node)
	local base_scale_x = obj.helper_zoom_bounce_scale[node].x
	local base_scale_y = obj.helper_zoom_bounce_scale[node].y
	local invert = -obj.helper_zoom_bounce_inverter[node]
	local time = (invert == -1) and obj.helper_zoom_bounce_time_in[node] or obj.helper_zoom_bounce_time_out[node]
	if (obj.helper_zoom_bounce_count[node] > 0) then
		local delta = obj.helper_zoom_bounce_delta[node]
		gui.animate(node, "scale.x", base_scale_x + (invert * delta), gui.EASING_LINEAR,
					time, 0, animate_zoom_bounce)
		gui.animate(node, "scale.y", base_scale_y + (invert * delta), gui.EASING_LINEAR,
					time, 0)

		obj.helper_zoom_bounce_count[node] = obj.helper_zoom_bounce_count[node] - 1
		obj.helper_zoom_bounce_inverter[node] = invert
	elseif (obj.helper_zoom_bounce_count[node] == 0) then
		gui.animate(node, "scale.x",
			base_scale_x, gui.EASING_LINEAR, time, 0, function(obj_after, node_after)
				obj_after.helper_zoom_bounce_count[node_after] = obj_after.helper_zoom_bounce_count[node_after] - 1
			end)
		gui.animate(node, "scale.y", base_scale_y, gui.EASING_LINEAR, time, 0)
	end
end

local function zoom_bounce_node(obj, node, zoom_delta, zoom_in_time, zoom_out_time, zoom_count)
	obj.helper_zoom_bounce_count = obj.helper_zoom_bounce_count or {}
	obj.helper_zoom_bounce_time_in = obj.helper_zoom_bounce_time_in or {}
	obj.helper_zoom_bounce_time_out = obj.helper_zoom_bounce_time_out or {}
	obj.helper_zoom_bounce_delta = obj.helper_zoom_bounce_delta or {}
	obj.helper_zoom_bounce_inverter = obj.helper_zoom_bounce_inverter or {}
	obj.helper_zoom_bounce_scale = obj.helper_zoom_bounce_scale or {}
	if (not obj.helper_zoom_bounce_count[node] or obj.helper_zoom_bounce_count[node] < 0) then
		obj.helper_zoom_bounce_count[node] = zoom_count
		obj.helper_zoom_bounce_time_in[node] = zoom_in_time
		obj.helper_zoom_bounce_time_out[node] = zoom_out_time
		obj.helper_zoom_bounce_delta[node] = zoom_delta
		obj.helper_zoom_bounce_inverter[node] = 1
		obj.helper_zoom_bounce_scale[node] = gui.get_scale(node)
		animate_zoom_bounce(obj, node)
	end
end

local function zoom_bounce_gui_component(obj, component, zoom_delta, zoom_in_time, zoom_out_time, zoom_count)
	zoom_bounce_node(obj, component.__base_node, zoom_delta, zoom_in_time, zoom_out_time, zoom_count)
end

local gui_helper = table_utils.make_read_only_table {
	is_touch_in_area = is_touch_in_area,
	is_mouse_in_area = is_mouse_in_area,
	is_action_in_area = is_action_in_area,
	shake_node = shake_node,
	shake_gui_component = shake_gui_component,
	zoom_bounce_node = zoom_bounce_node,
	zoom_bounce_gui_component = zoom_bounce_gui_component,
	--add shine, bounce
}

return gui_helper
