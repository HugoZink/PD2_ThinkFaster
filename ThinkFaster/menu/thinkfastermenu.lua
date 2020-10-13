dofile(ModPath .. "core.lua")

Hooks:Add('LocalizationManagerPostInit', 'thinkfastermenu_loadlocalization', function(loc)
	loc:load_localization_file(ThinkFaster.ModPath .. 'menu/thinkfaster_en.json', false)
end)

Hooks:Add('MenuManagerInitialize', 'thinkfastermenu_init', function(menu_manager)

	MenuCallbackHandler.thinkfastersave = function(this, item)
		ThinkFaster:Save()
		ThinkFaster:refresh_current_throughput()
	end

	MenuCallbackHandler.thinkfaster_donothing = function(this, item)
		-- do nothing
	end

	MenuCallbackHandler.thinkfaster_task_throughput_persecond = function(this, item)
		local val = tonumber(item:value())
		if val then
			if val < 60 then
				val = 60
			end

			ThinkFaster.settings.task_throughput = val
			ThinkFaster:Save()
			ThinkFaster:refresh_current_throughput()
		end
	end

	MenuCallbackHandler.thinkfaster_tailored_throughput_enabled = function(this, item)
		ThinkFaster.settings.tailored_throughput_enabled = item:value() == 'on'
		ThinkFaster:Save()
		ThinkFaster:refresh_current_throughput()
	end

	MenuCallbackHandler.thinkfaster_tailored_throughput_badlyoptimized = function(this, item)
		local val = tonumber(item:value())
		if val then
			if val < 60 then
				val = 60
			end

			ThinkFaster.settings.tailored_throughput_badlyoptimized = val
			ThinkFaster:Save()
			ThinkFaster:refresh_current_throughput()
		end
	end

	MenuCallbackHandler.thinkfaster_tailored_throughput_verybadlyoptimized = function(this, item)
		local val = tonumber(item:value())
		if val then
			if val < 60 then
				val = 60
			end

			ThinkFaster.settings.tailored_throughput_verybadlyoptimized = val
			ThinkFaster:Save()
			ThinkFaster:refresh_current_throughput()
		end
	end

	MenuHelper:LoadFromJsonFile(ThinkFaster.ModPath .. 'menu/thinkfastermenu.json', ThinkFaster, ThinkFaster.settings)
end)
