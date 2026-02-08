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
        local comp = stek.Components.Spawn(name)
        for index, value in pairs(data) do
            comp[index] = value
        end

        self._components[name] = comp
        self._components_list[#self._components_list+1] = comp
    end
end

function ENT:Initialize()
    for i = 1, #self._components_list do
        local comp = self._components_list[i]
        comp:_run_function("Initialize")
    end
end

---

function ENT:AddComponent(id)
    local component = stek.Components.Spawn(id)
    component:SetEntity(self)

    self._components[id] = component

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