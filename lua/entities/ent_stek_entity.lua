---@diagnostic disable: invisible

AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_entity: Entity
---@field Prefab Prefab
---@field STekBased true
---@field private _components { [string]: ComponentBase }
---@field private _components_list ComponentBase[]
local ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.STekBased = true

function ENT:SetupPrefab()
    if not self.Prefab then return end

    for name, data in pairs(self.Prefab.components) do
        local comp = self:AddComponent(name)
        local SharedValuesPreset = comp.SharedValuesPreset
        for index, value in pairs(data) do
            if SharedValuesPreset[index] then
                comp.SharedValues[index] = value
                goto skip
            end
            comp[index] = value

            ::skip::
        end
    end
end

function ENT:Initialize()
    self._components = {}
    self._components_list = {}

    self:SetupPrefab()

    for i = 1, #self._components_list do
        local comp = self._components_list[i]
        comp:_run_function("Initialize")
    end

    stek.Components.RegisterActiveEntity(self)
end

---

function ENT:AddComponent(id)
    local component = stek.Components.Spawn(id)
    component:SetEntity(self)

    self._components[id] = component
    self._components_list[#self._components_list + 1] = component

    return component
end

function ENT:GetComponent(id)
    return self._components[id]
end

---

function ENT:OnRemove(fullUpdate)
    for i = 1, #self._components_list do
        local comp = self._components_list[i]
        comp:_run_function("OnRemove", fullUpdate)
    end

    for i = 1, #self._components_list do
        local comp = self._components_list[i]
        comp:Destroy()
    end

    self._components = nil
    self._components_list = nil

    stek.Components.UnRegisterActiveEntity(self:EntIndex())
end

if SERVER then
    function ENT:OnTakeDamage(CDamageInfo)
        for i = 1, #self._components_list do
            local comp = self._components_list[i]
            comp:_run_function("OnTakeDamage", CDamageInfo)
        end
    end

    function ENT:Use(activator, caller, useType, value)
        for i = 1, #self._components_list do
            local comp = self._components_list[i]
            comp:_run_function("Use", activator, caller, useType, value)
        end
    end
else
    function ENT:ClientUse(ply)
        for i = 1, #self._components_list do
            local comp = self._components_list[i]
            comp:_run_function("ClientUse", ply)
        end
    end

    function ENT:Draw(flags)
        self:DrawModel(flags)

        for i = 1, #self._components_list do
            local comp = self._components_list[i]
            comp:_run_function("Draw", flags)
        end
    end

    function ENT:DrawTranslucent(flags)
        for i = 1, #self._components_list do
            local comp = self._components_list[i]
            comp:_run_function("DrawTranslucent", flags)
        end
    end
end
