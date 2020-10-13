if not ThinkFaster then
    _G.ThinkFaster = {}
    
    ThinkFaster.ModPath = ModPath
    ThinkFaster.SavePath = SavePath .. "thinkfaster.json"

    ThinkFaster.settings = {
        task_throughput = 650,
        tailored_throughput_enabled = true, -- Use different throughputs than the default on some heists
        tailored_throughput_badlyoptimized = 300,
        tailored_throughput_verybadlyoptimized = 200
    }

    -- Tailored throughput definitions
    ThinkFaster.heist_throughput_definitions = {
        sah = "badlyoptimized", -- Shacklethorne Auction
        bph = "badlyoptimized", -- Hells Island
        des = "badlyoptimized", -- Henry's Rock
        vit = "badlyoptimized", -- White House
        mex = "badlyoptimized", -- Border Crossing
        mex_cooking = "badlyoptimized", -- Border Crystals
        bex = "verybadlyoptimized", -- San Martin
        pex = "verybadlyoptimized", -- Breakfast in Tijuana
        dih = "verybadlyoptimized", -- Diamond Heist
        peta = "verybadlyoptimized" -- Goat Simulator
    }

    ThinkFaster.current_throughput = 650

    -- Allows changing the throughput mid-game
    -- Value has to be written to here rather than executing this logic every frame in EnemyManager
    function ThinkFaster:refresh_current_throughput()
        ThinkFaster.current_throughput = ThinkFaster.settings.task_throughput

        if self.settings.tailored_throughput_enabled then
            -- Check if the current job needs a different throughput than the default
            local job = Global.level_data and Global.level_data.level_id
            if job and self.heist_throughput_definitions[job] then
                local name = self.heist_throughput_definitions[job]
                if self.settings["tailored_throughput_" .. name] then
                    ThinkFaster.current_throughput = self.settings["tailored_throughput_" .. name]
                end
            end
        end
    end

    -- Load menu settings
    function ThinkFaster:Load()
        local file = io.open(self.SavePath, 'r')
        if file then
            for k, v in pairs(json.decode(file:read('*all')) or {}) do
                self.settings[k] = v
            end
            file:close()
        end
    end

    -- Save current menu settings
    function ThinkFaster:Save()
        local file = io.open(self.SavePath, 'w+')
        if file then
            file:write(json.encode(self.settings))
            file:close()
        end
    end

    -- Immediately load/save settings to write a file and to load the settings early
    ThinkFaster:Load()
    ThinkFaster:Save()

    -- Initialize throughput with the freshly loaded settings
    ThinkFaster:refresh_current_throughput()
end
