---@class ConfigModule
local Config = stek.Config

function Config.InitCommands()
    concommand.Add("stek_config_save", function(ply)
        if not (ply == NULL or ply:IsSuperAdmin()) then return end
        Config.Save()

        print("Config saved")
    end)

    concommand.Add("stek_config_save_onlymain", function(ply)
        if not (ply == NULL or ply:IsSuperAdmin()) then return end
        Config.SaveMain()

        print("Main Config saved")
    end)

    concommand.Add("stek_config_save_onlyaddons", function(ply)
        if not (ply == NULL or ply:IsSuperAdmin()) then return end
        Config.SaveAddons()

        print("Addons Config saved")
    end)

    ---
    
    concommand.Add("stek_config_load", function(ply)
        if not (ply == NULL or ply:IsSuperAdmin()) then return end
        Config.Load()

        print("Config loaded")
    end)

    concommand.Add("stek_config_load_onlymain", function(ply)
        if not (ply == NULL or ply:IsSuperAdmin()) then return end
        Config.LoadMain()

        print("Main Config loaded")
    end)

    concommand.Add("stek_config_load_onlyaddons", function(ply)
        if not (ply == NULL or ply:IsSuperAdmin()) then return end
        Config.LoadAddons()

        print("Addons Config loaded")
    end)
end