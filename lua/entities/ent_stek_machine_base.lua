AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_machine_base: Entity
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Author = "sekta"

ENT.PhysicsSounds = true

if SERVER then
    function ENT:Initialize()

    end
else
    function ENT:Draw()
        self:DrawModel()
    end
end
