---# Конфиг модуль
---Хранит в себе настройки аддона
---@class ConfigModule
---@field raw table "Сырая" таблица которая хранит все настройки
local Config = {
    raw = {},
    addons = {},
    addons_index = {},
    addons_list = {}
}

---Возвращает "сырую" таблицу со всеми настройками
---@return table
function Config.Get()
    return Config.raw
end

---

---Добаляет аддон и возвращает его настроки
---@return table
function Config.AddAddon(name)
    local tbl = {}

    Config.addons[name] = tbl
    Config.addons_index[name] = true
    table.insert(Config.addons_list, name)

    return tbl
end

---Возвращает настройки аддона
---@return table
function Config.GetAddon(name)
    return Config.addons[name]
end

---Проверяет есть ли такой аддон, возвращает true если существует, иначе false
---@return boolean
function Config.ExistsAddon(name)
    return Config.addons_index[name] and true or false
end

---

---Загружает главные настройки
function Config.LoadMain()
    local toml = file.Read("stek/config/main.txt", "DATA")
    if toml then
        local raw = TOML.parse(toml, {strict = false})
        Config.raw = raw
    end
end

---Загружает настройки аддонов
function Config.LoadAddons()
    for i = 1, #Config.addons_list do
        local name = Config.addons_list[i]

        local addon_toml = file.Read("stek/config/addons/" .. name .. ".txt", "DATA")
        if not addon_toml then continue end

        local addon_raw = TOML.parse(addon_toml, {strict = false})
        Config.addons[name] = addon_raw
    end
end

---Загружает все настройки
function Config.Load()
    Config.LoadMain()
    Config.LoadAddons()
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

stek.Config = Config