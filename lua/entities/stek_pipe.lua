AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Труба"
ENT.Category = "STek - Разное"

ENT.Spawnable = true

if SERVER then
    function ENT:Initialize()
        if SERVER then self.act_cd = CurTime() + 1 end

        self:SetModel("models/props_c17/FurnitureWashingmachine001a.mdl")

        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

        if SERVER then
            self:PhysicsInit(SOLID_VPHYSICS)
            self:SetUseType(SIMPLE_USE)

            local phys = self:GetPhysicsObject()

            if IsValid(phys) then
                phys:Wake()
                phys:SetMass(30)
            end
        end
    end
else
    function ENT:Draw()
        self:DrawModel()
    end
end