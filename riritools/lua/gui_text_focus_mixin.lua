local component_with_focus = nil

local function has_text_focus(self)
	return component_with_focus == self
end

local function acquire_text_focus(self)
	if (component_with_focus ~= self) then
		component_with_focus = self
		gui.show_keyboard(self.__keyboard_type, false)
	end
end

local function release_text_focus(self)
	if (component_with_focus == self) then
		component_with_focus = nil
		gui.hide_keyboard()
	end
end

local gui_text_focus_mixin = {
	appended_methods = {
		has_text_focus = has_text_focus,
		acquire_text_focus = acquire_text_focus,
		release_text_focus = release_text_focus,
	}
}

return gui_text_focus_mixin
