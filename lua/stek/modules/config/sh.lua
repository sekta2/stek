---# Конфиг модуль
---Хранит в себе настройки аддона
---@class ConfigModule
---@field raw table "Сырая" таблица которая хранит все настройки
local Config = {
    raw = {
        inventory = {
            base_max_volume = 100
        },

        resources = {
            max_amount = 100
        }
    },

    addons = {},
    addons_index = {},
    addons_list = {}
}

---Возвращает "сырую" таблицу со всеми настройками
---@return table
function Config.get()
    return Config.raw
end

---

---Добаляет аддон и возвращает его настроки
---@return table
function Config.addAddon(name)
    local tbl = {}

    Config.addons[name] = tbl
    Config.addons_index[name] = true
    table.insert(Config.addons_list, name)

    return tbl
end

---Возвращает настройки аддона
---@return table
function Config.getAddon(name)
    return Config.addons[name]
end

---Проверяет есть ли такой аддон, возвращает true если существует, иначе false
---@return boolean
function Config.existsAddon(name)
    return Config.addons_index[name] and true or false
end

stek.Config = Config
