local table_utils = require("riritools.lua.table_utils")

local urls

local function initialize()
	urls.GO_PLAYER = msg.url("main:/riritools/player")
	urls.SCREEN_MANAGER = msg.url("main:/riritools/screen_manager")
	urls.LEVEL_MANAGER = msg.url("main:/riritools/level_manager")
	urls.AUDIO_MANAGER = msg.url("main:/riritools/audio_manager")
	urls.TRANSITION_MANAGER = msg.url("main:/riritools/transition_manager")

	urls.initialize = nil

	urls = table_utils.make_read_only_table(urls)
end

urls = {
	GO_PLAYER = false,
	LEVEL_MANAGER = false,
	AUDIO_MANAGER = false,
	TRANSITION_MANAGER = false,
	dynamic = table_utils.make_warning_table {},
	initialize = initialize,
}

return urls
