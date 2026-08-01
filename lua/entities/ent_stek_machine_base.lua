AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_machine_base: Entity
---@field Model string? Путь к модели энтити
---@field Material string? Путь к материалу энтити
---@field Color Color? Цвет энтити
---@field Mass number? Масса энтити
---@field AfterInit fun(self: ent_stek_machine_base)? Кастомная функция инициализации
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Author = "sekta"

ENT.PhysicsSounds = true

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

        if self.AfterInit then
            self.AfterInit(self)
        end
    end
else
    function ENT:Draw()
        self:DrawModel()
    end
end
