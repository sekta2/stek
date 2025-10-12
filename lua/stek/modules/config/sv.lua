---@class ConfigModule
local Config = stek.Config

util.AddNetworkString("stek.ConfigSync")

function Config.GetDatafiedConfig()
    local data = util.Compress(util.TableToJSON({
        raw = Config.raw,
        addons = Config.addons
    }))

    return data, #data
end

---Синхронизирует конфиг(главный + аддоны) со всеми игроками
function Config.BroadcastSync()
    local data, len = Config.GetDatafiedConfig()

    net.Start("stek.ConfigSync")
    net.WriteUInt(len, 16)
    net.WriteData(data, len)
    net.Broadcast()
end

---Синхронизирует конфиг(главный + аддоны) с указанным игроком
---@param ply Player
function Config.PlayerSync(ply)
    local data, len = Config.GetDatafiedConfig()

    net.Start("stek.ConfigSync")
    net.WriteUInt(len, 16)
    net.WriteData(data, len)
    net.Send(ply)
end

---

hook.Add("PlayerAuthed", "stek.Config.PlayerSyncConfig", function(ply)
    Config.PlayerSync(ply)
end)

---

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
        Config.BroadcastSync()

        print("Config loaded")
    end)

    concommand.Add("stek_config_load_onlymain", function(ply)
        if not (ply == NULL or ply:IsSuperAdmin()) then return end
        Config.LoadMain()
        Config.BroadcastSync()

        print("Main Config loaded")
    end)

    concommand.Add("stek_config_load_onlyaddons", function(ply)
        if not (ply == NULL or ply:IsSuperAdmin()) then return end
        Config.LoadAddons()
        Config.BroadcastSync()

        print("Addons Config loaded")
    end)
end