AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_item_base: Entity
---@field Model string?
---@field Material string?
---@field Color Color?
---@field Mass number?
---@field Weapon string
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Author = "sekta"

if SERVER then
    function ENT:Initialize()
        if self.Model then
            self:SetModel(self.Model)
        end

        if self.Material then
            self:SetMaterial(self.Material)
        end

        if self.Color then
            self:SetColor(self.Color)
        end

        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetSolid(SOLID_VPHYSICS)

        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            if self.Mass then
                phys:SetMass(self.Mass)
            end

            phys:Wake()
        end
    end

    function ENT:Use(ply)
        if ply:KeyDown(IN_WALK) then
            ply:PickupObject(self)
            return
        end

        ply:Give(self.Weapon)
        ply:SelectWeapon(self.Weapon)
        

        self:Remove()
    end
else
    function ENT:Draw()
        self:DrawModel()
    end
end
