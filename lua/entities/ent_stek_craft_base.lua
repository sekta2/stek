AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_craft_base: ent_stek_machine_base
---@field Model string
---@field CraftType string
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Author = "sekta"

ENT.PhysicsSounds = true

-- ENT.CraftType = "workbench"
-- ENT.Model = "models/hunter/blocks/cube1x2x1.mdl"

if SERVER then
    function ENT:Initialize()
        if self.Model then
            self:SetModel(self.Model)
        end

        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetSolid(SOLID_VPHYSICS)

        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:PhysWake()
    end
else
    function ENT:Draw()
        self:DrawModel()
    end

    function ENT:ClientUse()
        --- TODO: сделать вывод панельки
    end
end
