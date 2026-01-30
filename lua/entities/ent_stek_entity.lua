AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_entity: Entity
---@field private _components { [string]: ComponentBase }
local ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

function ENT:Initialize()

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

if SERVER then
    function ENT:OnTakeDamage()
        for k, v in pairs(self._components) do
            if v.OnTakeDamage then
                v:OnTakeDamage(v)
            end
        end
    end
end
