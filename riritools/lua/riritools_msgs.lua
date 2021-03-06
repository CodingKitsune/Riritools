local table_utils = require("riritools.lua.table_utils")

local rt_msg = table_utils.make_read_only_table {
	DISABLE_STENCIL_MASK = hash("rt_disable_stencil_mask"),
	ENABLE_STENCIL_MASK = hash("rt_enable_stencil_mask"),
	SET_ZOOM = hash("rt_set_zoom"),
	SET_MIRROR = hash("rt_set_mirror"),

	DELETE_OBJECT = hash("rt_delete_object"),
	GET_OWNER = hash("rt_get_owner"),
	GOT_OWNER = hash("rt_got_owner"),
	SET_OWNER = hash("rt_set_owner"),

	PLAYER_INIT = hash("rt_player_init"),
	PLAYER_INIT_DONE = hash("rt_player_init_done"),
	SAVE_DATA = hash("rt_save_data"),
	LOAD_DATA = hash("rt_load_data"),
	LOADED_DATA = hash("rt_loaded_data"),
	GET_DATA = hash("rt_get_data"),
	GOT_DATA = hash("rt_got_data"),
	SET_DATA_FIELD = hash("rt_set_data_field"),
	GET_DATA_FIELD = hash("rt_get_data_field"),
	GOT_DATA_FIELD = hash("rt_got_data_field"),
	RESET_DATA = hash("rt_reset_data"),
	SAVE_CONFIG = hash("rt_save_config"),
	LOAD_CONFIG = hash("rt_load_config"),
	LOADED_CONFIG = hash("rt_loaded_config"),
	GET_CONFIG = hash("rt_get_config"),
	GOT_CONFIG = hash("rt_got_config"),
	SET_CONFIG_FIELD = hash("rt_set_config_field"),
	GET_CONFIG_FIELD = hash("rt_get_config_field"),
	GOT_CONFIG_FIELD = hash("rt_got_config_field"),
	RESET_CONFIG = hash("rt_reset_config"),
	CHANGED_CONFIG_FIELD = hash("rt_changed_config_field"),
	CHANGED_DATA_FIELD = hash("rt_changed_data_field"),
	SET_WARN_CHANGE_CONFIG_FIELD = hash("rt_warn_change_config_field"),
	SET_WARN_CHANGE_DATA_FIELD = hash("rt_warn_change_data_field"),
	CLEANUP = hash("rt_cleanup"),

	PLAY_SOUND = hash("rt_rt_play_sound"),
	STOP_SOUND = hash("rt_rt_stop_sound"),
	SET_GAIN = hash("rt_rt_set_gain"),
	CONFIG_SE_VOLUME = hash("rt_config_se_volume"),
	CONFIG_BGM_VOLUME = hash("rt_config_bgm_volume"),
	SET_CAMERA_TARGET = hash("rt_set_camera_target"),
	SET_CAMERA_POSITION = hash("rt_set_camera_position"),
	SET_CAMERA_OFFSET = hash("rt_set_camera_offset"),
	SET_CAMERA_DELAY = hash("rt_set_camera_delay"),
	SET_CAMERA_ANCHOR = hash("rt_set_camera_anchor"),
	SET_CAMERA_ZOOM = hash("rt_set_camera_zoom"),

	SCREEN_MANAGER_INIT = hash("rt_screen_manager_init"),
	SCREEN_MANAGER_INIT_DONE = hash("rt_screen_manager_init_done"),
	PUSH_SCREEN = hash("rt_push_screen"),
	PUSHED_SCREEN = hash("rt_pushed_screen"),
	POP_SCREEN = hash("rt_pop_screen"),
	POP_ALL_SCREENS = hash("rt_pop_all_screens"),
	POPPED_SCREEN = hash("rt_popped_screen"),
	POPPED_ALL_SCREENS = hash("rt_popped_all_screens"),
	ENABLE_SCREEN = hash("rt_enable_screen"),
	ENABLED_SCREEN = hash("rt_enabled_screen"),
	DISABLE_SCREEN = hash("rt_disable_screen"),
	DISABLED_SCREEN = hash("rt_disabled_screen"),
	PAUSE_SCREEN = hash("rt_pause_screen"),
	RESUME_SCREEN = hash("rt_resume_screen"),
	PAUSED_SCREEN = hash("rt_paused_screen"),
	RESUMED_SCREEN = hash("rt_resumed_screen"),
	PAUSE_ALL_SCREENS = hash("rt_pause_all_screens"),
	RESUME_ALL_SCREENS = hash("rt_resume_all_screens"),
	PAUSED_ALL_SCREENS = hash("rt_paused_all_screens"),
	RESUMED_ALL_SCREENS = hash("rt_resumed_all_screens"),
	IS_SCREEN_LOADED = hash("rt_is_screen_loaded"),
	IS_SCREEN_ENABLED = hash("rt_is_screen_enabled"),
	IS_SCREEN_PAUSED = hash("rt_is_screen_paused"),
	SET_SCREEN_TIME_STEP = hash("rt_set_screen_time_step"),
	GET_SCREEN_TIME_STEP = hash("rt_get_screen_time_step"),
	GOT_SCREEN_TIME_STEP = hash("rt_got_screen_time_step"),
	GOT_SCREEN_PARAMETERS = hash("rt_got_screen_parameters"),
	GET_ACTIVE_SCREENS = hash("rt_get_active_screens"),
	GOT_ACTIVE_SCREENS = hash("rt_got_active_screens"),
	WARN_SCREEN_CHANGES = hash("rt_warn_screen_changes"),

	EXIT_GAME = hash("rt_exit_game"),

	LEVEL_MANAGER_INIT = hash("rt_level_manager_init"),
	LEVEL_MANAGER_INIT_DONE = hash("rt_level_manager_init_done"),
	PUSH_LEVEL = hash("rt_push_level"),
	PUSHED_LEVEL = hash("rt_pushed_level"),
	POP_LEVEL = hash("rt_pop_level"),
	POP_ALL_LEVELS = hash("rt_pop_all_levels"),
	POPPED_LEVEL = hash("rt_popped_level"),
	POPPED_ALL_LEVELS = hash("rt_popped_all_level"),
	ENABLE_LEVEL = hash("rt_enable_level"),
	ENABLED_LEVEL = hash("rt_enabled_level"),
	DISABLE_LEVEL = hash("rt_disable_level"),
	DISABLED_LEVEL = hash("rt_disabled_level"),
	PAUSE_LEVEL = hash("rt_pause_level"),
	RESUME_LEVEL = hash("rt_resume_level"),
	PAUSED_LEVEL = hash("rt_paused_level"),
	RESUMED_LEVEL = hash("rt_resumed_level"),
	PAUSE_ALL_LEVELS = hash("rt_pause_all_levels"),
	RESUME_ALL_LEVELS = hash("rt_resume_all_levels"),
	PAUSED_ALL_LEVELS = hash("rt_paused_all_levels"),
	RESUMED_ALL_LEVELS = hash("rt_resumed_all_levels"),
	RESTART_LEVEL = hash("rt_restart_level"),
	RESTARTED_LEVEL = hash("rt_restarted_level"),
	RESTART_ALL_LEVELS = hash("rt_restart_all_levels"),
	RESTARTED_ALL_LEVELS = hash("rt_restarted_all_levels"),
	IS_LEVEL_LOADED = hash("rt_is_level_loaded"),
	IS_LEVEL_ENABLED = hash("rt_is_level_enabled"),
	IS_LEVEL_PAUSED = hash("rt_is_level_paused"),
	SET_LEVEL_TIME_STEP = hash("rt_set_level_time_step"),
	GET_LEVEL_TIME_STEP = hash("rt_get_level_time_step"),
	GOT_LEVEL_TIME_STEP = hash("rt_got_level_time_step"),
	GOT_LEVEL_PARAMETERS = hash("rt_got_level_parameters"),
	GET_ACTIVE_LEVELS = hash("rt_get_active_levels"),
	GOT_ACTIVE_LEVELS = hash("rt_got_active_levels"),
	WARN_LEVEL_CHANGES = hash("rt_warn_level_changes"),

	TRANSITION_IN = hash("rt_transition_in"),
	TRANSITION_OUT = hash("rt_transition_out"),
	TRANSITION_IN_DONE = hash("rt_transition_in_done"),
	TRANSITION_OUT_DONE = hash("rt_transition_out_done"),

	SEND_GUI_DATA = hash("rt_send_gui_data"),

	SET_CURSOR_ANIMATION = hash("rt_set_cursor_animation"),

	TOGGLE_LOG = hash("rt_toggle_log"),

	ENABLE_SYNCHRONIZER = hash("enable_synchronizer"),
	DISABLE_SYNCHRONIZER = hash("disable_synchronizer"),
	REGISTER_SLAVE = hash("register_slave"),
	REGISTER_MASTER = hash("register_master"),

	RIRITOOLS_INIT_DONE = hash("rt_riritools_init_done"),
}

return rt_msg
