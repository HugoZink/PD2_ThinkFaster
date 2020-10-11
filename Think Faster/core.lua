if not ThinkFaster then
    _G.ThinkFaster = {}
    
    ThinkFaster.ModPath = ModPath
    ThinkFaster.SavePath = SavePath

    ThinkFaster.settings = {
        task_throughput = 1000
    }

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
end
