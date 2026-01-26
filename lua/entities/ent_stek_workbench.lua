AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_workbench: Entity
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName = "Workbench"
ENT.Category = "STek: Machines"
ENT.Author = "sekta"
ENT.Spawnable = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/hunter/blocks/cube1x2x1.mdl")

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
end
