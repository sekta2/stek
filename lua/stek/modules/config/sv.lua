---@class ConfigModule
local Config = stek.Config

---Загружает главные настройки
function Config.LoadMain()
    local toml = file.Read("stek/config/main.txt", "DATA")
    if toml then
        local raw = TOML.parse(toml, { strict = false })
        Config.raw = raw
    end
end

---Загружает настройки аддонов
function Config.LoadAddons()
    for i = 1, #Config.addons_list do
        local name = Config.addons_list[i]

        local addon_toml = file.Read("stek/config/addons/" .. name .. ".txt", "DATA")
        if not addon_toml then continue end

        local addon_raw = TOML.parse(addon_toml, { strict = false })
        Config.addons[name] = addon_raw
    end
end

---Загружает все настройки
function Config.Load()
    Config.LoadMain()
    Config.LoadAddons()

    if not file.Exists("stek/config.main.txt", "DATA") then
        Config.SaveMain()
    end
end

---

---Сохраняет главные настройки
function Config.SaveMain()
    local toml = TOML.encode(Config.Get())
    file.Write("stek/config/main.txt", toml)
end

---Сохраняет настройки аддонов
function Config.SaveAddons()
    for i = 1, #Config.addons_list do
        local name = Config.addons_list[i]

        local toml = TOML.encode(Config.addons[name])
        file.Write("stek/config/addons/" .. name .. ".txt", toml)
    end
end

---Сохраняет все настройки
function Config.Save()
    Config.SaveMain()
    Config.SaveAddons()
end

---

util.AddNetworkString("stek.ConfigSync")

---Возвращает сжатый конфиг и его длину
---@return string data
---@return integer len
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
