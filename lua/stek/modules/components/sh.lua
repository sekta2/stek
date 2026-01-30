---@class ComponentBase
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

Components.Prefab = stek.shared("prefab.lua")

stek.Components = Components
