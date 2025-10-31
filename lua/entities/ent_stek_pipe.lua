AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_pipe: Entity
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Category = "STek: Pipes"
ENT.Author = "sekta"
ENT.Spawnable = true

ENT.PhysicsSounds = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_c17/FurnitureWashingmachine001a.mdl")
        self:SetMaterial("phoenix_storms/dome")

        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetSolid(SOLID_VPHYSICS)

        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:PhysWake()
    end

    ---@param activator Player
    function ENT:Use(activator)
    end

    function ENT:OnRemove()
    end
else
    function ENT:Draw()
        self:DrawModel()
    end
end