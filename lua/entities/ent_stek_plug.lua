AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_plug: Entity
---@field InitialEntity Entity?
---@field TouchCallback fun(InitialEntity:Entity, TouchEntity:Entity, Plug:ent_stek_plug)?
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Author = "sekta"

ENT.PhysicsSounds = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_lab/tpplug.mdl")

        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetSolid(SOLID_VPHYSICS)

        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:PhysWake()
    end

    function ENT:SetupPlug()
        local InitialEntity = self.InitialEntity
        if not (InitialEntity and IsValid(InitialEntity)) then return end

        local constr, rope = constraint.Rope(
            self.InitialEntity, -- Entity 1
            self,               -- Entity 2
            0,                  -- Bone 1
            0,                  -- Bone 2
            vector_origin,      -- LocalPos 1
            Vector(10.5, 0, 0), -- LocalPos 2
            500,                -- Length
            0,                  -- Add length
            500,                -- Force Limit
            15,                 -- Width
            "cable/cable2"      -- Material
        )

        rope:CallOnRemove("RemovePlugOnRemovedRope", function(ent)
            self:Remove()
        end)

        return constr, rope
    end

    ---@param activator Player
    function ENT:Use(activator)
        activator:PickupObject(self)
    end

    function ENT:OnRemove()
    end

    function ENT:PhysicsCollide(data, phys)
        if not (data.Speed >= 50) then return end

        local callback = self.TouchCallback
        if not (callback and self.InitialEntity) then return end

        callback(self.InitialEntity, data.HitEntity, self)
    end

    local pickup_angle = Angle(180, 0, 0)
    function ENT:GetPreferredCarryAngles()
        return pickup_angle
    end
else
    function ENT:Draw()
        self:DrawModel()
    end
end
