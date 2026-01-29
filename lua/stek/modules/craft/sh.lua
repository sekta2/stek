---@class CraftOutputDataResource
---@field resource string Идентификатор ресурса
---@field amount integer Количество ресурса

---@class CraftOutputDataEntity
---@field class string Имя класса энтити
---@field amount integer Количество энтити

---@class CraftOutputDataProp
---@field model string Путь к модели пропа
---@field amount integer Количество пропов

---@class CraftOutput
---@field type "resource"|"entity"|"prop" Вариант результата крафта
---@field data CraftOutputDataResource|CraftOutputDataEntity|CraftOutputDataProp Данные результата крафта

---@class CraftData
---@field name string? Название крафта, используется когда не найдено переведённое название
---@field description string? Описание крафта
---@field resources { [string]: number } Ресуры нужные для крафта
---@field output fun()|CraftOutput Функция для спавна при успешном крафте, или структура CraftOutput

---

---@class Craft: CraftData
---@field uid integer Уникальный Идентификатор крафта
---@field id string Идентификатор крафта
local CraftClass = {}
CraftClass.__index = CraftClass

---Создаёт и возвращает объект крафта
---@param id string
---@param data CraftData
---@return Craft
function CraftClass:new(id, data)
    data = data or {}

    local Object = {
        id = id,
        uid = nil,

        name = data.name,
        description = data.description,
        resources = data.resources,
        output = data.output
    }

    return setmetatable(Object, self)
end

---Возвращает название крафта
---@return string
function CraftClass:GetName()
    local phrase_name = "craft_" .. self.id
    if not stek.Locale.Exists(phrase_name) then return self.name or self.id end

    return stek.Locale.Get("craft_" .. self.id)
end

---Возвращает описание крафта
---@return string
function CraftClass:GetDescription()
    local phrase_name = "craft_desc_" .. self.id
    if not stek.Locale.Exists(phrase_name) then return self.description end

    return stek.Locale.Get("craft_desc_" .. self.id)
end

---

---# Модуль для крафтов
---@class CraftModule
---@field list [Craft]
---@field index { [string]: Craft }
---@field bits_count number
local Craft = {
    list = {},
    index = {},

    bits_count = 1
}

---Создаёт новый крафт и возвращает его
---@param id string
---@param data CraftData
---@return Craft
function Craft.Create(id, data)
    if not id or (id and type(id) ~= "string") then error(("invalid craft id '%s'"):format("id")) end

    local Object = CraftClass:new(id, data)
    local uid = #Craft.list + 1

    Craft.list[uid] = Object
    Craft.index[id] = Object

    Object.uid = uid

    Craft.bits_count = stek.BitsForUnsignedInt(uid)

    return Object
end

---Возвращает крафт по указанному UID
---@param uid integer Уникальный Идентификатор ресурса
---@return Craft
function Craft.GetByUID(uid)
    return Craft.list[uid]
end

---Возвращает крафт по указанному идентификатору
---@param id string Идентификатор ресурса
---@return Craft
function Craft.GetByID(id)
    return Craft.index[id]
end

stek.shared("net.lua")
stek.shared("register.lua")(Craft)

stek.Craft = Craft
