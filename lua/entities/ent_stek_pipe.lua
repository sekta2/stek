AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_pipe: Entity
---@field ConnectorPlug ent_stek_plug
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
        if not activator:KeyDown(IN_WALK) then return end

        local connector = self.ConnectorPlug
        if connector and IsValid(connector) then
            connector:SetPos(activator:GetEyeTraceNoCursor().HitPos)
            activator:PickupObject(connector)

            return
        end

        local plug = stek.MakeConnector(self, activator:GetEyeTraceNoCursor().HitPos)
        plug.TouchCallback = function(_, TouchEntity, Plug)
            if not (TouchEntity:GetClass() == "ent_stek_pipe" and TouchEntity ~= self) then return end

            Plug:Remove()

            timer.Simple(0, function()
                local constr, rope = constraint.Rope(
                    self,          -- Entity 1
                    TouchEntity,   -- Entity 2
                    0,             -- Bone 1
                    0,             -- Bone 2
                    vector_origin, -- LocalPos 1
                    vector_origin, -- LocalPos 2
                    500,           -- Length
                    0,             -- Add length
                    2500,          -- Force Limit
                    15,            -- Width
                    "cable/cable2" -- Material
                )
            end)
        end

        activator:DropObject()
        activator:PickupObject(plug)

        self.ConnectorPlug = plug
    end

    function ENT:OnRemove()
    end
else
    function ENT:Draw()
        self:DrawModel()
    end
end
