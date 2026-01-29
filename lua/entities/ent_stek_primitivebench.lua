AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_primitivebench: ent_stek_machine_base
ENT = ENT

ENT.Base = "ent_stek_machine_base"
ENT.Type = "anim"

ENT.PrintName = "Crafting Table"
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
