local table_utils = require("riritools.lua.table_utils")

local inputs = table_utils.make_read_only_table {
	TEXT = hash("text"),
	BACKSPACE = hash("backspace"),
	MOUSE_OK = hash("mouse_ok"),
	MOUSE_WHEEL_UP = hash("mouse_wheel_up"),
	MOUSE_WHEEL_DOWN = hash("mouse_wheel_down"),
	RESET = hash("reset"),
	TOUCH = hash("touch"),
	DEBUG1 = hash("debug1"),
	DEBUG2 = hash("debug2"),
	DEBUG3 = hash("debug3"),
	DEBUG4 = hash("debug4"),
	CAMERA_X_DOWN = hash("camera_x_down"),
	CAMERA_X_UP = hash("camera_x_up"),
	CAMERA_Y_DOWN = hash("camera_y_down"),
	CAMERA_Y_UP = hash("camera_y_up"),
	CAMERA_Z_DOWN = hash("camera_z_down"),
	CAMERA_Z_UP = hash("camera_z_up"),
	CAMERA_RX_DOWN = hash("camera_rx_down"),
	CAMERA_RX_UP = hash("camera_rx_up"),
	CAMERA_RY_DOWN = hash("camera_ry_down"),
	CAMERA_RY_UP = hash("camera_ry_up"),
	CAMERA_RZ_DOWN = hash("camera_rz_down"),
	CAMERA_RZ_UP = hash("camera_rz_up"),
	CAMERA_TOGGLE_TARGET = hash("camera_toggle_target"),
	TOGGLE_PROFILE = hash("toggle_profile"),
	TOGGLE_PHYSICS_DEBUG = hash("toggle_physics_debug"),
	TOGGLE_LOG = hash("toggle_log"),
	TOGGLE_RECORDING = hash("toggle_recording"),
}

return inputs
