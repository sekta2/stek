---@class ConfigModule
local Config = stek.Config

---Загружает главные настройки
function Config.loadMain()
    local toml = file.Read("stek/config/main.txt", "DATA")
    if toml then
        local raw = TOML.parse(toml, { strict = false })
        Config.raw = raw
    end
end

---Загружает настройки аддонов
function Config.loadAddons()
    for i = 1, #Config.addons_list do
        local name = Config.addons_list[i]

        local addon_toml = file.Read("stek/config/addons/" .. name .. ".txt", "DATA")
        if not addon_toml then continue end

        local addon_raw = TOML.parse(addon_toml, { strict = false })
        if not Config.addons[name] then
            print("Loaded config for addon " .. name .. ", but there no inited addon")
        else
            Config.addons[name] = addon_raw
        end
    end
end

---Загружает все настройки
function Config.load()
    Config.loadMain()
    Config.loadAddons()

    Config.save()
end

---

---Сохраняет главные настройки
function Config.saveMain()
    local toml = TOML.encode(Config.get())
    file.Write("stek/config/main.txt", toml)
end

---Сохраняет настройки аддонов
function Config.saveAddons()
    for i = 1, #Config.addons_list do
        local name = Config.addons_list[i]

        local toml = TOML.encode(Config.addons[name])
        file.Write("stek/config/addons/" .. name .. ".txt", toml)
    end
end

---Сохраняет все настройки
function Config.save()
    Config.saveMain()
    Config.saveAddons()
end

---

util.AddNetworkString("stek.ConfigSync")

---Возвращает сжатый конфиг и его длину
---@return string data
---@return integer len
function Config.getCompressedConfig()
    local data = util.Compress(util.TableToJSON({
        raw = Config.raw,
        addons = Config.addons
    }))

    return data, #data
end

---Синхронизирует конфиг(главный + аддоны) со всеми игроками
function Config.broadcastSync()
    local data, len = Config.getCompressedConfig()

    net.Start("stek.ConfigSync")
    net.WriteUInt(len, 16)
    net.WriteData(data, len)
    net.Broadcast()
end

---Синхронизирует конфиг(главный + аддоны) с указанным игроком
---@param ply Player
function Config.playerSync(ply)
    local data, len = Config.getCompressedConfig()

    net.Start("stek.ConfigSync")
    net.WriteUInt(len, 16)
    net.WriteData(data, len)
    net.Send(ply)
end

---

hook.Add("PlayerAuthed", "stek.Config.PlayerSyncConfig", function(ply)
    Config.playerSync(ply)
end)

---

function Config.initCommands()
    concommand.Add("stek_config_save", function(ply)
        if not (ply == NULL or ply:IsSuperAdmin()) then return end
        Config.save()
        Config.broadcastSync()

        print("Config saved")
    end)

    concommand.Add("stek_config_save_onlymain", function(ply)
        if not (ply == NULL or ply:IsSuperAdmin()) then return end
        Config.saveMain()
        Config.broadcastSync()

        print("Main Config saved")
    end)

    concommand.Add("stek_config_save_onlyaddons", function(ply)
        if not (ply == NULL or ply:IsSuperAdmin()) then return end
        Config.saveAddons()
        Config.broadcastSync()

        print("Addons Config saved")
    end)

    ---

    concommand.Add("stek_config_load", function(ply)
        if not (ply == NULL or ply:IsSuperAdmin()) then return end
        Config.load()
        Config.broadcastSync()

        print("Config loaded")
    end)

    concommand.Add("stek_config_load_onlymain", function(ply)
        if not (ply == NULL or ply:IsSuperAdmin()) then return end
        Config.loadMain()
        Config.broadcastSync()

        print("Main Config loaded")
    end)

    concommand.Add("stek_config_load_onlyaddons", function(ply)
        if not (ply == NULL or ply:IsSuperAdmin()) then return end
        Config.loadAddons()
        Config.broadcastSync()

        print("Addons Config loaded")
    end)
end
