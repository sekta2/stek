---@class ComponentBase
---@field base_class ComponentBase Базовый класс текущего компонента
---@field uid number Уникальный Идентификатор текущего компонента
---@field id string Идентификатор текущего компонента
---@field private _entity ent_stek_entity
local ComponentBase = {}

---Устанавливает энтити для этого компонента
---@param ent ent_stek_entity
function ComponentBase:SetEntity(ent)
    self._entity = ent
end

---Возвращает энтити к которому присвоен этот компонент
---@return ent_stek_entity
function ComponentBase:GetEntity()
    return self._entity
end

---Возвращает указанный компонент энтити
---@param id string
function ComponentBase:GetComponent(id)
    local ent = self._entity
    return ent:GetComponent(id)
end

---

local ComponentMeta = {
    __index = function(t, k)
        return t.base_class[k]
    end
}

local not_allowed_names = {
    uid = true,
    id = true,
    class = true,
    base_class = true
}

local ObjectComponentMeta = {
    __index = function(t, k)
        return t.class[k]
    end,

    __newindex = function(t, k, v)
        if not_allowed_names[k] then
            error("Setting value to variable " .. k .. " not allowed (" .. t.id .. ")")
        end

        t[k] = v
    end
}

---@class ComponentsModule
---@field Prefab ComponentsPrefabModule
local Components = {
    list = {},
    index = {},

    bits_count = 1
}

---Создаёт класс компонента
---@param id string Идентификатор компонента
---@return ComponentBase
function Components.Create(id)
    local uid = #Components.list + 1

    local component_class = setmetatable({ base_class = ComponentBase, uid = uid, id = id }, ComponentMeta)

    Components.list[uid] = component_class
    Components.index[id] = component_class

    Components.bits_count = stek.BitsForUnsignedInt(uid)

    return component_class
end

---@generic T:ComponentBase
---Создаёт новый экземпляр компонента
---@param id `T` Идентификатор компонента
---@return T
function Components.Spawn(id)
    local class = Components.index[id]
    if not class then error(("Unknown component '%s'"):format(id)) end

    local object = setmetatable({ class = class }, ObjectComponentMeta)
    return object
end

---@type ComponentsPrefabModule
Components.Prefab = stek.shared("prefab.lua")

function Components.Init()
    local files, _ = file.Find("stek/components/*.lua", "LUA")

    for i = 1, #files do
        local filename = files[i]
        stek.shared("stek/components/" .. filename)
    end

    Components.Prefab.Init()
end

stek.Components = Components
