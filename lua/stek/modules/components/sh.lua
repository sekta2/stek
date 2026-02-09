---@class ComponentBase
---@field base_class ComponentBase Базовый класс текущего компонента
---@field uid number Уникальный Идентификатор текущего компонента
---@field id string Идентификатор текущего компонента
---@field private _entity ent_stek_entity
local ComponentBase = {}

---@private
---@param name string
---@param ...any
function ComponentBase:_run_function(name, ...)
    local fn = self[name]
    if (not fn) or (fn and (type(fn) ~= "function")) then return end

    fn(self, ...)
end

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

function ComponentBase:Destroy()
    setmetatable(self, { __mode = "kv" })
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

        rawset(t, k, v)
    end
}

---@class ComponentsModule
---@field Prefab ComponentsPrefabModule
local Components = {
    list = {},
    index = {},

    entities_list = {},
    entities_index = {},

    bits_count = 1
}

function Components.RegisterActiveEntity(ent)
    Components.entities_index[ent:EntIndex()] = true
    Components.entities_list[#Components.entities_list + 1] = ent
end

function Components.UnRegisterActiveEntity(ent_index)
    Components.entities_index[ent_index] = nil
    for i = #Components.entities_list, 1, -1 do
        local ent = Components.entities_list[i]
        if IsValid(ent) and ent:EntIndex() == ent_index then
            table.remove(Components.entities_list, i)
            break
        end
    end
end

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
Components.Prefab = stek.shared("prefab.lua")(Components)

function Components.Init()
    local files, _ = file.Find("stek/components/*.lua", "LUA")

    for i = 1, #files do
        local filename = files[i]
        stek.shared("stek/components/" .. filename)
    end

    Components.Prefab.Init()

    hook.Add("Think", "stek.Components.Think", function()
        for i = 1, #Components.entities_list do
            local ent = Components.entities_list[i]
            for ii = 1, #ent._components_list do
                local comp = ent._components_list[ii]
                comp:_run_function("Think")
            end
        end
    end)
end

stek.Components = Components
