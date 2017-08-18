local class = require("riritools.lua.class")
local gui_component = require("riritools.lua.gui_component")
local delayed_function = require("riritools.lua.delayed_function")

local slideshow = class("rt.gui__slideshow", gui_component)

local function change_slide(slideshow_instance)
	if (slideshow_instance.__amount_of__slides > 0) then
		slideshow_instance.__current_slide = slideshow_instance.__current_slide + 1
		if (slideshow_instance.__current_slide > slideshow_instance.__amount_of__slides) then
			slideshow_instance.__current_slide = 1
		end
		gui.play_flipbook(slideshow_instance.__base_node,
				slideshow_instance.__slides[slideshow_instance.__current_slide])
	else
		gui.set_enabled(slideshow_instance.__base_node, false)
	end
	slideshow_instance.__delayed_function =
		delayed_function:new(slideshow_instance.__delay, change_slide, slideshow_instance)
end

function slideshow:__initialize(name, params, parent)
	gui_component.__initialize(self, name, parent, "slideshow", true)
	self.__delay = params.delay or 1.0
	self.__current_slide = params.starting_slide or 0
	self.__amount_of__slides = 0
	self:set_slides(params.slides or {})
end

function slideshow:set_slides(slides)
	self.__slides = slides
	local amount = 0
	for _, v in pairs(slides) do
		amount = v ~= nil and (amount + 1) or amount
	end
	self.__amount_of__slides = amount
	self.__current_slide = 1
	gui.set_enabled(self.__base_node, true)
	change_slide(self)
end

function slideshow:update(dt)
	self.__delayed_function:update(dt)
end

return slideshow
