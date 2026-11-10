AddCSLuaFile()

STEK_NADE_SAFE = 0
STEK_NADE_READY = 1
STEK_NADE_ARMED = 2

---@alias STekNadeState 1|2|3

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_nade_base: Entity
---@field Model string?
---@field OnReady fun(self, activator: Player)?
---@field OnArmed fun(self)?
---@field state STekNadeState
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Author = "sekta"
ENT.StekNade = true

ENT.PhysicsSounds = true

if SERVER then
    function ENT:Initialize()
        self.state = STEK_NADE_SAFE

        if self.Model then
            self:SetModel(self.Model)
        end

        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetSolid(SOLID_VPHYSICS)

        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end
    end

    ---@param activator Player
    function ENT:Use(activator)
        if not activator:IsPlayer() then return end

        if activator:KeyDown(IN_WALK) then
            activator:PickupObject(self)
            self.state = STEK_NADE_READY

            if self.OnReady then
                self:OnReady(activator)
            end
        else
            activator:PickupObject(self)
        end
    end

    ---@param ply Player
    ---@param ent ent_stek_nade_base
    ---@param _ boolean
    hook.Add("OnPlayerPhysicsDrop", "stek.NadeDrop", function(ply, ent, _)
        if IsValid(ent) and ent.StekNade and ent.state == STEK_NADE_READY then
            ent.state = STEK_NADE_ARMED

            if ent.OnArmed then
                ent:OnArmed()
            end
        end
    end)
else
    function ENT:Draw()
        self:DrawModel()
    end
end
