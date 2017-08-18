local rt_msgs = require("riritools.lua.riritools_msgs")
local rt_inputs = require("riritools.lua.riritools_inputs")
local algorithms = require("riritools.lua.algorithms")

local is_between_inclusive = algorithms.is_between_inclusive

local chronometer = require("riritools.lua.chronometer")
local wh = require("riritools.lua.window_helper")

local default_sound_ok
local default_sound_error

local function is_in_a_container(parent)
	return parent and (parent.__is_a_container or (parent.__parent and is_in_a_container(parent.__parent)))
end

local function __initialize(self, _, params, parent)
	params = params or {}
	self.cooldown = params and params.cooldown or 0.2
	self.padding = {x=0, y=0}
	self.use_touch = false
	self.use_mouse = true
	self.mouse_binding = rt_inputs.MOUSE_OK
	self.__in_container = is_in_a_container(parent)
	self.__container_hierarchy = {}
	self.__is_active = false
	self.__is_enabled = false
	self.__cooldown_timer = chronometer:new(0, true)
	self.__cooldown_timer:restart()
	self.__no_sound = params.no_sound or false
	if (not params.no_sound) then
		default_sound_ok = default_sound_ok or msg.url("common_ui:/sound_button_ok")
		default_sound_error = default_sound_error or msg.url("common_ui:/sound_button_error")
		self.__sound_ok = params.sound_ok or default_sound_ok
		self.__sound_error = params.sound_error or default_sound_error
	end
end

local function setup(self)
	self:set_active(true)
	self:set_enabled(true)
end

local function __how_much_inside_component_check(self, position_x, position_y, component,
	position_hint, size_hint, gui_width_hint, gui_height_hint)

	if (self.__in_container and
		(not self:__visible_in_container(position_x, position_y) or not self:__inputable_in_container())) then
			return {x = -1, y=-1}
	end

	position_hint = position_hint or gui.get_screen_position(component)
	size_hint = size_hint or gui.get_size(component)

	gui_width_hint = gui_width_hint or gui.get_width()
	gui_height_hint = gui_height_hint or gui.get_height()

	local width_const = wh.render_width * gui_width_hint * gui_width_hint / wh.width
	local height_const = wh.render_height * gui_height_hint * gui_height_hint / wh.height

	local pos_x = position_x / width_const
    local pos_y = position_y / height_const
    local com_x = position_hint.x / width_const
    local com_y = position_hint.y / height_const

    local size_x = size_hint.x / width_const
    local size_y = size_hint.y / height_const

	size_x = size_x * wh.min_inverted_scale
	size_y = size_y * wh.min_inverted_scale

	local result = {
		x = (pos_x - com_x + (size_x * 0.5)) / size_x,
		y = (pos_y - com_y + (size_y * 0.5)) / size_y
	}

	if (not is_between_inclusive(result.x, {0 - self.padding.x, 1 + self.padding.x})
		or not is_between_inclusive(result.y, {0 - self.padding.y, 1 + self.padding.y})) then
		result.x = -1
		result.y = -1
	else
		result.x = result.x > 1 and 1 or (result.x < 0 and 0 or result.x)
		result.y = result.y > 1 and 1 or (result.y < 0 and 0 or result.y)
	end

	return result
end

local function __visible_in_container(self, position_x, position_y)
	if (self.__parent) then
		local parent_result = __visible_in_container(self.__parent, position_x, position_y)
		local self_result
		if (self.__parent.__is_a_container) then
			local result = __how_much_inside_component_check(self.__parent, position_x, position_y, self.__parent.__stencil)
			local is_parent_visible = (self.__parent.parent and self.__parent.parent.__is_a_container)
				and __how_much_inside_component_check(
					self.__parent.parent, position_x, position_y, self.__parent.parent.__stencil)
				or true
			self_result = (result.x ~= -1 and result.y ~= -1) and is_parent_visible
		else
			self_result = true
		end
		return self_result and parent_result
	else
		return true
	end
end

local function __inputable_in_container(self)
	if (self.__parent) then
		if (self.__parent.__is_a_container) then
			return self.__parent:can_pass_input()
		else
			return true
		end
	else
		return true
	end
end

local function __how_much_inside_component(self, action_id, action, component, multi_touch)
	if (action_id == rt_inputs.TOUCH) then
		if (multi_touch) then
			local result
			for _, event in ipairs(action.touch) do
				result = __how_much_inside_component_check(self, event.screen_x, event.screen_y, component)
				if (result.x ~= -1 and result.y ~= -1) then
					break
				end
			end
			return result
		else
			local event = action.touch[1]
			return __how_much_inside_component_check(self, event.screen_x, event.screen_y, component)
		end
	else
		return __how_much_inside_component_check(self, action.screen_x, action.screen_y, component)
	end
end

local function __is_inside_component_check(self, position_x, position_y, component, position_hint, size_hint)
	local how_much_inside = __how_much_inside_component_check(self, position_x, position_y, component)
	return (how_much_inside.x ~= -1 and how_much_inside.y ~= -1)
end

local function __check_press_touch(self, touch, component, multi_touch)
	local position = gui.get_screen_position(component)
	local size = gui.get_size(component)
	if (table.getn(touch) <= 0) then
		return false
	end
	if (multi_touch) then
		for _, event in ipairs(touch) do
			if (__is_inside_component_check(self, event.screen_x, event.screen_y, component, position, size)) then
				return true
			end
		end
		return false
	else
		local event = touch[1]
		return __is_inside_component_check(self, event.screen_x, event.screen_y, component, position, size)
	end
end

local function __has_clicked_ok_on_component(self, action_id, action, component, multi_touch)
	local result = (self.__is_active
	and ((self.use_mouse
		and action_id == self.mouse_binding
		and __is_inside_component_check(self, action.screen_x, action.screen_y, component))

		or (self.use_touch
			and action_id == rt_inputs.TOUCH
			and self:__check_press_touch(action.touch, component, multi_touch))
		)
	)

	if (result and not self.__is_enabled) then
		self:__emit_error()
		return false
	end

	return result
end

local function is_active(self)
	return self.__is_active
end

local function is_enabled(self)
	return self.__is_enabled
end

local function set_active(self, is_component_active)
	self.__cooldown_timer:restart()
	if (is_component_active) then
		self.__is_active = true
	else
		self.__is_active = false
		self.__cooldown_timer:stop()
	end
end

local function set_enabled(self, is_component_enabled)
	self.__cooldown_timer:restart()
	if (is_component_enabled) then
		self.__is_enabled = true
	else
		self.__is_enabled = false
		self.__cooldown_timer:stop()
	end
end

local function __emit_ok(self)
	msg.post(self.__sound_ok, rt_msgs.PLAY_SOUND)
end

local function __emit_error(self)
	msg.post(self.__sound_error, rt_msgs.PLAY_SOUND)
end

local gui_clickable = {
	appended_methods = {
		__visible_in_container = __visible_in_container,
		__inputable_in_container = __inputable_in_container,
		__check_press_touch = __check_press_touch,
		__has_clicked_ok_on_component = __has_clicked_ok_on_component,
		__how_much_inside_component = __how_much_inside_component,
		__is_inside_component_check = __is_inside_component_check,
		__emit_ok = __emit_ok,
		__emit_error = __emit_error,
		is_enabled = is_enabled,
		is_active = is_active,
		setup = setup,
	},
	prepended_methods = {
		__initialize = __initialize,
		set_enabled = set_enabled,
		set_active = set_active
	}
}

return gui_clickable
