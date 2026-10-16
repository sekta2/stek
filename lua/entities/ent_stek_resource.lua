AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_resource: Entity
---@field Model string?
---@field Skin number?
---@field Color Color?
---@field Material string?
---@field CarryAngles Angle?
---@field DrawDist number?
---@field InfoPosOffset Vector
---@field InfoAngleOffset Angle
---@field InfoHorizontal boolean
---@field InfoRenderSize number
---@field InfoTextColor Color?
---@field InfoIconSize number
---@field STek_Resource string
---@field SpawnTime number
---@field MergeLock boolean
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Category = "STek: Resources"
ENT.Author = "sekta"

ENT.PhysicsSounds = true

---@return number
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
            local draw_dist_str = tostring(self.DrawDist)

            self:SetKeyValue("fademindist", draw_dist_str)
            self:SetKeyValue("fademaxdist", draw_dist_str)
        end

        self.SpawnTime = CurTime()
        self.MergeLock = false

        stek.Resources.registerActiveEntity(self)
        --self:SetAmount(100, true)
    end

    ---@param activator Player
    function ENT:Use(activator)
        local phys = self:GetPhysicsObject()

        if not activator:IsPlayer() then return end
        if not (activator:GetGroundEntity() ~= self and IsValid(phys) and phys:IsMotionEnabled()) then return end

        local amount = self:GetAmount()

        local is_division = activator:KeyDown(IN_WALK) and activator:KeyDown(IN_SPEED)
        if is_division and amount > 1 then
            local div_amount = math.floor(amount / 2)
            self:SetAmount(amount - div_amount)

            ---@type ent_stek_resource
            local new_res = ents.Create(self:GetClass())
            new_res:SetAmount(div_amount)

            new_res:SetPos(self:GetPos())
            new_res:SetAngles(self:GetAngles())

            new_res:Spawn()
            activator:PickupObject(new_res)
        else
            activator:PickupObject(self)
        end
    end

    ---@param ent ent_stek_resource
    function ENT:Touch(ent)
        if not (IsValid(ent) and ent.STek_Resource == self.STek_Resource and not self.MergeLock and not ent.MergeLock) then return end
        if ((CurTime() - ent.SpawnTime) < 2) or ((CurTime() - self.SpawnTime) < 2) then return end

        local conf = stek.Config.get()
        local max_amount = conf.resources.max_amount

        local self_amount, ent_amount = self:GetAmount(), ent:GetAmount()
        if self_amount == max_amount then return end

        local amount = math.min(self_amount + ent_amount, max_amount)

        if self_amount >= ent_amount then
            self.MergeLock = true

            local ent_substract = amount - self_amount
            ent:SetAmount(ent_amount - ent_substract)
            self:SetAmount(amount)

            if ent_substract == ent_amount then
                ent:Remove()
            end

            self.MergeLock = false
        end
    end

    function ENT:OnRemove()
        stek.Resources.unRegisterActiveEntity(self:EntIndex())
    end

    function ENT:SyncAmount()
        net.Start("stek.SyncResourceAmount")
        net.WriteEntity(self)
        net.WriteUInt(self.amount, 8)
        net.Broadcast()
    end

    ---@param num number
    ---@param do_not_sync boolean?
    function ENT:SetAmount(num, do_not_sync)
        self.amount = num
        if not do_not_sync then self:SyncAmount() end
    end
else
    local delayed_ents = {}

    ---@param entity ent_stek_resource
    hook.Add("OnEntityCreated", "stek.Resource.Sync", function(entity)
        if not scripted_ents.IsBasedOn(entity:GetClass(), "ent_stek_resource") then return end

        local delayed = delayed_ents[entity:EntIndex()]
        if delayed then
            entity.amount = delayed
            delayed_ents[entity:EntIndex()] = nil
        end
    end)

    net.Receive("stek.SyncResourceAmount", function()
        local ent_index = net.ReadUInt(13)
        local amount = net.ReadUInt(8)

        ---@type ent_stek_resource?
        local resource_ent = Entity(ent_index)
        if not (resource_ent and IsValid(resource_ent)) then
            delayed_ents[ent_index] = amount
            return
        end

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
            stek.Draw.resourceInfoHorizontal(self.STek_Resource, self:GetAmount(), 0, 0, self.InfoIconSize, self.InfoTextColor)
        else
            stek.Draw.resourceInfoVertical(self.STek_Resource, self:GetAmount(), 0, 0, self.InfoIconSize, self.InfoTextColor)
        end

        cam.End3D2D()
    end
end
