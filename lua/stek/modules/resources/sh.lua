---@class ResourceAutoEntity
---@field color Color?
---@field material string?
---@field model string?
---@field skin integer?

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
---@field list table<number, Resource>
---@field index table<string, Resource>
---@field bits_count number
local Resources = {
    list = {},
    index = {},

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

    Resources.bits_count = stek.CheckBits(uid)

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

stek.shared("net.lua")
stek.shared("register.lua")(Resources)

stek.Resources = Resources