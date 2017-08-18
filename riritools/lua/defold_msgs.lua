local table_utils = require("riritools.lua.table_utils")

local defold_messages = table_utils.make_read_only_table {
	LAYOUT_CHANGED = hash("layout_changed"),

	ACQUIRE_INPUT_FOCUS = hash("acquire_input_focus"),
	ENABLE = hash("enable"),
	DISABLE = hash("disable"),
	RELEASE_INPUT_FOCUS = hash("release_input_focus"),
	SET_PARENT = hash("set_parent"),

	SET_VIEW_PROJECTION = hash("set_view_projection"),
	CLEAR_COLOR = hash("clear_color"),
	DRAW_LINE = hash("draw_line"),
	DRAW_TEXT = hash("draw_text"),
	WINDOW_RESIZED = hash("window_resized"),

	EXIT = hash("exit"),
	REBOOT = hash("reboot"),
	SET_UPDATE_FREQUENCY = hash("set_update_frequency"),
	START_RECORD = hash("start_record"),
	STOP_RECORD = hash("stop_record"),
	TOGGLE_PHYSICS_DEBUG = hash("toggle_physics_debug"),
	TOGGLE_PROFILE = hash("toggle_profile"),

	ACQUIRE_CAMERA_FOCUS = hash("acquire_camera_focus"),
	RELEASE_CAMERA_FOCUS = hash("release_camera_focus"),
	SET_CAMERA = hash("set_camera"),

	ASYNC_LOAD = hash("async_load"),
	FINAL = hash("final"),
	INIT = hash("init"),
	LOAD = hash("load"),
	PROXY_LOADED = hash("proxy_loaded"),
	PROXY_UNLOADED = hash("proxy_unloaded"),
	SET_TIME_STEP = hash("set_time_step"),
	UNLOAD = hash("unload"),

	APPLY_FORCE = hash("apply_force"),
	COLLISION_RESPONSE = hash("collision_response"),
	CONTACT_POINT_RESPONSE = hash("contact_point_response"),
	RAY_CAST_RESPONSE = hash("ray_cast_response"),
	TRIGGER_RESPONSE = hash("trigger_response"),

	MODEL_ANIMATION_DONE = hash("model_animation_done"),
	PLAY_SOUND = hash("play_sound"),
	SET_GAIN = hash("set_gain"),
	STOP_SOUND = hash("stop_sound"),

	SPINE_ANIMATION_DONE = hash("spine_animation_done"),
	SPINE_EVENT = hash("spine_event"),

	ANIMATION_DONE = hash("animation_done"),
	PLAY_ANIMATION = hash("play_animation")
}

return defold_messages
