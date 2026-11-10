AddCSLuaFile()

STEK_BOMB_ACT_DOUBLE_USE = 0
STEK_BOMB_ACT_ALT_USE = 1

local double_use_time = 0.25

---@alias STekBombActivation 0|1

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_bomb_base: Entity
---@field Model string?
---@field ActivationType STekBombActivation?
---@field CanPickup boolean?
---@field ChangedState fun(self, activator: Player, new_state: boolean)?
---@field OnDetonation fun(self, col_data: CollisionData, phys: PhysObj)?
---@field DetonationSpeed number?
---@field state boolean
---@field last_use number
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Author = "sekta"

ENT.PhysicsSounds = true

if SERVER then
    function ENT:Initialize()
        self.state = false
        self.last_use = 0

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

        if self.ActivationType == STEK_BOMB_ACT_DOUBLE_USE then
            if (CurTime() - self.last_use) <= double_use_time then
                self.state = not self.state

                if self.ChangedState then
                    self:ChangedState(activator, self.state)
                end
            end
        else
            if activator:KeyDown(IN_WALK) then
                self.state = not self.state

                if self.ChangedState then
                    self:ChangedState(activator, self.state)
                end
            elseif (not activator:KeyDown(IN_WALK)) and self.CanPickup then
                activator:PickupObject(self)
            end
        end

        self.last_use = CurTime()
    end

    ---@param colData CollisionData
    ---@param phys PhysObj
    function ENT:PhysicsCollide(colData, phys)
        if (colData.HitSpeed:Length() >= (self.DetonationSpeed or 1000)) and self.OnDetonation then
            self:OnDetonation(colData, phys)
        end
    end
else
    function ENT:Draw()
        self:DrawModel()
    end
end
