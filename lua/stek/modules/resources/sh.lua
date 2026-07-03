---@diagnostic disable: missing-fields

---@class ResourceAutoEntity
---@field color Color?
---@field material string?
---@field model string?
---@field skin integer?
---@field carryangles Angle? Углы поворота энтити при подборе игроком

---

---@class ResourceData
---@field name string? Название ресурса, используется когда не найдено переведённое название
---@field icon string? Путь к значку ресурса, если нет, то используется стандартный путь(см. :GetIconPath())
---@field volume number? Объём ресурса
---@field auto_entity boolean? Нужно ли автоматически создавать энтити для этого ресурса?
---@field entity ResourceAutoEntity? Параметры энтити ресурса

---

---@class Resource: ResourceData
---@field uid integer Уникальный Идентификатор ресурса
---@field id string Идентификатор ресурса
---@field volume number Объём ресурса
---@field auto_entity boolean Нужно ли автоматически создавать энтити для этого ресурса?
local ResourceClass = {}
ResourceClass.__index = ResourceClass

---Создаёт и возвращает объект ресурса
---@param id string Идентификатор ресурса
---@param data ResourceData Параметры ресурса
---@return Resource
function ResourceClass:new(id, data)
    data = data or {}

    local Object = {
        id = id,
        uid = nil,

        name = data.name,
        icon = data.icon,
        volume = data.volume or 10,

        auto_entity = data.auto_entity ~= nil and data.auto_entity or false,
        entity = data.entity
    }

    return setmetatable(Object, self)
end

---Возвращает название ресурса
---@return string
function ResourceClass:GetName()
    local phrase_name = "resource_" .. self.id
    if not stek.Locale.Exists(phrase_name) then return self.name or self.id end

    return stek.Locale.Get("resource_" .. self.id)
end

---Возвращает путь к значку ресурса
---@return string
function ResourceClass:GetIconPath()
    return self.icon or ("materials/stek/resources/" .. self.id .. ".png")
end

---Возвращает материал значка ресурса, если путь не валидный, возвращает nil
---@return IMaterial?
function ResourceClass:GetIcon()
    if self.icon_mat then
        return self.icon_mat
    end

    local path = self:GetIconPath()
    local mat = Material(path)

    if mat then
        self.icon_mat = mat
        return mat
    end
end

---

---# Ресурсный модуль
---Позволяет создавать ресурсы
---@class ResourceModule
---@field list [Resource]
---@field index { [string]: Resource }
---@field bits_count number
local Resources = {
    list = {},
    index = {},

    active_ents = {},

    bits_count = 1
}

---Создаёт новый ресурс и возвращает его
---@param id string Идентификатор ресурса
---@param data ResourceData Параметры ресурса
---@return Resource
function Resources.Add(id, data)
    if not id or (id and type(id) ~= "string") then error(("invalid resource id '%s'"):format("id")) end

    local Object = ResourceClass:new(id, data)
    local uid = #Resources.list + 1

    Resources.list[uid] = Object
    Resources.index[id] = Object

    Object.uid = uid

    Resources.bits_count = stek.BitsForUnsignedInt(uid)

    return Object
end

---Возвращает ресурс по указанному UID
---@param uid integer Уникальный Идентификатор ресурса
---@return Resource
function Resources.GetByUID(uid)
    return Resources.list[uid]
end

---Возвращает ресурс по указанному идентификатору
---@param id string Идентификатор ресурса
---@return Resource
function Resources.GetByID(id)
    return Resources.index[id]
end

---

function Resources.RegisterActiveEntity(ent)
    Resources.active_ents[ent:EntIndex()] = true
end

function Resources.UnRegisterActiveEntity(ent_index)
    Resources.active_ents[ent_index] = nil
end

---

function Resources.InitAutoEntities()
    for i = 1, #Resources.list do
        local res = Resources.list[i]
        local ent_data = res.entity
        if not (res.auto_entity and ent_data) then continue end

        ---@type ENT
        local NewENT = {
            Base = "ent_stek_resource",
            Type = "anim",

            PrintName = res:GetName(),
            Category = "STek: Resources",
            Spawnable = true,

            Model = ent_data.model,
            Skin = ent_data.skin,
            Color = ent_data.color,
            Material = ent_data.material,
            CarryAngles = ent_data.carryangles,

            STek_Resource = res.id
        }

        scripted_ents.Register(NewENT, "ent_stek_res_" .. res.id)
    end
end

stek.shared("net.lua")

stek.Resources = Resources
