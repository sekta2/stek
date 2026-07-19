AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_resource: Entity
---@field Model string?
---@field Skin number?
---@field Color Color?
---@field Material string?
---@field CarryAngles Angle?
---@field InfoPosOffset Vector
---@field InfoAngleOffset Angle
---@field InfoHorizontal boolean
---@field InfoRenderSize number
---@field InfoTextColor Color?
---@field InfoIconSize number
---@field STek_Resource string
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Category = "STek: Resources"
ENT.Author = "sekta"

ENT.PhysicsSounds = true

function ENT:GetAmount()
    return self.amount or 100
end

if SERVER then
    function ENT:Initialize()
        if self.Model then
            self:SetModel(self.Model)
        end

        if self.Skin then
            self:SetSkin(self.Skin)
        end

        if self.Color then
            self:SetColor(self.Color)
        end

        if self.Material then
            self:SetMaterial(self.Material)
        end

        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetSolid(SOLID_VPHYSICS)

        self:PhysicsInit(SOLID_VPHYSICS)
        self:PhysWake()
        
        if self.DrawDist then
            local drawDistStr = tostring( self.DrawDist )
	        self:SetKeyValue("fademindist", drawDistStr) 
	        self:SetKeyValue("fademaxdist", drawDistStr) 
        end
        
        stek.Resources.RegisterActiveEntity(self)
        self:SetAmount(100, true)
    end

    ---@param activator Player
    function ENT:Use(activator)
        local phys = self:GetPhysicsObject()

        if not activator:IsPlayer() then return end
        if not (activator:GetGroundEntity() ~= self and IsValid(phys) and phys:IsMotionEnabled()) then return end

        activator:PickupObject(self)
    end

    function ENT:OnRemove()
        stek.Resources.UnRegisterActiveEntity(self:EntIndex())
    end

    function ENT:SyncAmount()
        net.Start("stek.SyncResourceAmount")
        net.WriteEntity(self)
        net.WriteUInt(self.amount, 8)
        net.SendPVS(self:GetPos())
    end

    function ENT:SetAmount(num, do_not_sync)
        self.amount = num
        if not do_not_sync then self:SyncAmount() end
    end
else
    net.Receive("stek.SyncResourceAmount", function()
        ---@type ent_stek_resource
        local resource_ent = net.ReadEntity()
        if not IsValid(resource_ent) then return end

        local amount = net.ReadUInt(8)
        resource_ent.amount = amount
    end)

    net.Receive("stek.SyncResourceAmountFull", function(len)
        local length = net.ReadUInt(16)

        local uncompressed = util.Decompress(net.ReadData(length))
        if not uncompressed then
            print("Resource amounts sync failed: Decompress step")
            return
        end

        local tbl = util.JSONToTable(uncompressed)
        if not tbl then
            print("Resource amounts failed: Un-Json step")
            return
        end

        for i = 1, #tbl do
            local data = tbl[i]

            ---@type ent_stek_resource
            local ent = Entity(data[1])
            if not IsValid(ent) then continue end

            ent.amount = data[2]
        end

        print("Resource amounts synced! " .. len .. " bits")
    end)

    function ENT:Draw()
        self:DrawModel()

        cam.Start3D2D(self:LocalToWorld(self.InfoPosOffset), self:LocalToWorldAngles(self.InfoAngleOffset), self.InfoRenderSize)

        if self.InfoHorizontal then
            stek.Draw.ResourceInfoHorizontal(self.STek_Resource, self:GetAmount(), 0, 0, self.InfoIconSize, self.InfoTextColor)
        else
            stek.Draw.ResourceInfoVertical(self.STek_Resource, self:GetAmount(), 0, 0, self.InfoIconSize, self.InfoTextColor)
        end

        cam.End3D2D()
    end
end
