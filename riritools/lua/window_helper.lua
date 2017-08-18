local min = math.min
local window_width = render.get_window_width
local window_height = render.get_window_height
local width = render.get_width
local height = render.get_height

local window = {
	width = 0,
	height = 0,
	render_width = 0,
	render_height = 0,
	scale_x = 0.0,
	scale_y = 0.0,
	inverted_scale_x = 0.0,
	inverted_scale_y = 0.0,
	min_scale = 0.0,
	min_inverted_scale = 0.0,
	zoom = 0.0,
	is_3d_enabled = false
}

local function update_window(render_script)
	window.width = window_width()
	window.height = window_height()
	window.render_width = width()
	window.render_height = height()
	window.scale_x = (width() / window_width())
	window.inverted_scale_x = (window_width() / width())
	window.scale_y = (height() / window_height())
	window.min_scale = min(window.scale_x, window.scale_y)
    window.min_inverted_scale = min(window.inverted_scale_x, window.inverted_scale_y)
	window.inverted_scale_y = (window_height() / height())
	window.zoom = render_script.zoom
	window.is_3d_enabled = render.enable_3d
end

local render_helper = {
	update_window = update_window
}

render_helper = setmetatable(render_helper, { __index = window})

return render_helper
