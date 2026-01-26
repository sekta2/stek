---@class CraftData
---@field name string? Название крафта, используется когда не найдено переведённое название

---

---@class Craft: CraftData
---@field uid integer Уникальный Идентификатор крафта
---@field id string Идентификатор крафта
local CraftClass = {}
CraftClass.__index = CraftClass

---
---@param id string
---@param data CraftData
---@return Craft
function CraftClass:new(id, data)
    data = data or {}

    local Object = {
        id = id,
        uid = nil,

        name = data.name
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

---

local Craft = {
    list = {},
    index = {},

    bits_count = 1
}

function Craft.Create(id, data)
    if not id or (id and type(id) ~= "string") then error(("invalid craft id '%s'"):format("id")) end

    local Object = CraftClass:new(id, data)
    local uid = #Craft.list + 1

    Craft.list[uid] = Object
    Craft.index[id] = Object

    Object.uid = uid

    Craft.bits_count = stek.BitsForUnsignedInt(uid)
end

function Craft.GetByUID(uid)
    return Craft.list[uid]
end

function Craft.GetByID(id)
    return Craft.index[id]
end

stek.shared("net.lua")

stek.Craft = Craft
