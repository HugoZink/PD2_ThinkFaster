dofile(ModPath .. "core.lua")

Hooks:Add('LocalizationManagerPostInit', 'betterjokersmenu_loadlocalization', function(loc)
	loc:load_localization_file(ThinkFaster.ModPath .. 'menu/thinkfaster_en.json', false)
end)

Hooks:Add('MenuManagerInitialize', 'thinkfastermenu_init', function(menu_manager)

	MenuCallbackHandler.thinkfastersave = function(this, item)
		ThinkFaster:Save()
	end

	MenuCallbackHandler.thinkfaster_donothing = function(this, item)
		-- do nothing
	end

	MenuCallbackHandler.thinkfaster_task_throughput_persecond = function(this, item)
		ThinkFaster.settings.task_throughput = tonumber(item:value())
		ThinkFaster:Save()
	end

	MenuHelper:LoadFromJsonFile(ThinkFaster.ModPath .. 'menu/thinkfastermenu.json', ThinkFaster, ThinkFaster.settings)
end)
