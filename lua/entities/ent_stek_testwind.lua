AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName = "STek test wind"
ENT.Spawnable = true

local WindNormal = VectorRand()
local RealWind = WindNormal
-- Уменьшим WindSpeed, чтобы избежать избыточной нестабильности
local WindSpeed = 2500 

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
        self:SetMoveType(MOVETYPE_NONE) 
        self:SetSolid(SOLID_NONE) 
        self:SetUseType(SIMPLE_USE)
    end
else
    -- ====================================================================
    -- = КЛИЕНТСКАЯ ЛОГИКА
    -- ====================================================================
    
    function ENT:Initialize()
        self.Velocity = self.Velocity or vector_origin
        self.WindNormal = WindNormal
        self.RealWind = RealWind

        self:SetMoveType(MOVETYPE_NONE)
    end
    
    local oldpos

    function ENT:Draw()
        self:DrawModel()

        local nigga = stek.GetLerpedWind():GetNormalized()

        debugoverlay.Line(self:GetPos(), self:GetPos() + nigga * 100, 0, Color(255, 0, 0), false)

        if oldpos then
            debugoverlay.Line(oldpos, self:GetPos() + nigga * 100, 5000, Color(255, 0, 0), false)
        end

        oldpos = self:GetPos() + nigga * 100
    end
end