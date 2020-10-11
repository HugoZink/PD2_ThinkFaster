dofile(ModPath .. "core.lua")

Hooks:Add('LocalizationManagerPostInit', 'thinkfastermenu_loadlocalization', function(loc)
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
		local val = tonumber(item:value())
		if val then
			if val < 100 then
				val = 100
			end

			if val > 5000 then
				val = 5000
			end

			ThinkFaster.settings.task_throughput = val
			ThinkFaster:Save()
		end
	end

	MenuHelper:LoadFromJsonFile(ThinkFaster.ModPath .. 'menu/thinkfastermenu.json', ThinkFaster, ThinkFaster.settings)
end)
