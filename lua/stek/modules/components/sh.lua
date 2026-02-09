---@diagnostic disable: assign-type-mismatch, need-check-nil
---@class ComponentBase
---@field base_class ComponentBase Базовый класс текущего компонента
---@field uid number Уникальный Идентификатор текущего компонента
---@field id string Идентификатор текущего компонента
---@field SharedValues { [string]: any }
---@field SharedValuesPreset { [string]: string }
---@field private _entity ent_stek_entity
local ComponentBase = {
    SharedValuesPreset = {}
}

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

---

SHAREDVALUES_TYPES = {
    ["string"] = {
        write = net.WriteString,
        read = net.ReadString
    },
    ["int8"] = {
        write = function(v) net.WriteInt(v, 8) end,
        read = function() return net.ReadInt(8) end
    },
    ["uint8"] = {
        write = function(v) net.WriteUInt(v, 8) end,
        read = function() return net.ReadUInt(8) end
    },
    ["int16"] = {
        write = function(v) net.WriteInt(v, 16) end,
        read = function() return net.ReadInt(16) end
    },
    ["uint16"] = {
        write = function(v) net.WriteUInt(v, 16) end,
        read = function() return net.ReadUInt(16) end
    },
    ["float"] = {
        write = net.WriteFloat,
        read = net.ReadFloat
    },
    ["double"] = {
        write = net.WriteDouble,
        read = net.ReadDouble
    },
    ["bool"] = {
        write = net.WriteBool,
        read = net.ReadBool
    },
    ["vector"] = {
        write = net.WriteVector,
        read = net.ReadVector
    },
    ["angle"] = {
        write = net.WriteAngle,
        read = net.ReadAngle
    },
    ["entity"] = {
        write = net.WriteEntity,
        read = net.ReadEntity
    },
    ["table"] = {
        write = function(v) net.WriteTable(v, false) end,
        read = function() net.ReadTable(false) end
    },
    ["table_sequential"] = {
        write = function(v) net.WriteTable(v, true) end,
        read = function() net.ReadTable(true) end
    }
}

if SERVER then
    util.AddNetworkString("stek.CSharedValue")

    function ComponentBase:SyncSharedValue(key)
        local ent = self:GetEntity()
        if not IsValid(ent) then return end

        local data_type = self.SharedValuesPreset[key]

        net.Start("stek.CSharedValue")
            net.WriteEntity(ent)
            net.WriteUInt(self.uid, stek.Components.bits_count)
            net.WriteString(key)
            SHAREDVALUES_TYPES[data_type].write(self.SharedValues[key])
        net.Broadcast()
    end

    function ComponentBase:SetSharedValue(key, value)
        if not self.SharedValuesPreset[key] then error(("Unknown shared value '%s'"):format(key)) end
        self.SharedValues[key] = value

        self:SyncSharedValue(key)
    end
else
    net.Receive("stek.CSharedValue", function(len)
        ---@type ent_stek_entity?
        local ent = net.ReadEntity()
        if not IsValid(ent) then return end

        local component_uid = net.ReadUInt(stek.Components.bits_count)
        local component_id = stek.Components.list[component_uid].id

        local comp = ent:GetComponent(component_id)
        if not comp then return end

        local key = net.ReadString()
        local data_type = comp.SharedValuesPreset[key]

        comp.SharedValues[key] = SHAREDVALUES_TYPES[data_type].read()
    end)
end

function ComponentBase:GetSharedValue(key)
    if not self.SharedValuesPreset[key] then error(("Unknown shared value '%s'"):format(key)) end
    return self.SharedValues[key]
end

---

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
        local SharedValuesPreset = t.class["SharedValuesPreset"]
        if SharedValuesPreset and SharedValuesPreset[k] then
            return t:GetSharedValue(k)
        end

        return t.class[k]
    end,

    __newindex = function(t, k, v)
        if not_allowed_names[k] then
            error("Setting value to variable " .. k .. " not allowed (" .. t.id .. ")")
        end

        local SharedValuesPreset = t.SharedValuesPreset
        if SharedValuesPreset and SharedValuesPreset[k] then
            if CLIENT then error(("Setting shared value '%s' on client not allowed!"):format(k)) end
            t:SetSharedValue(k, v)

            return
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
    object.SharedValues = {}

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
