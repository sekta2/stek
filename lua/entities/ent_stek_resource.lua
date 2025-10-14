---@class ent_stek_resource: ENT
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Category = "STek: Resources"
ENT.Author = "sekta"

function ENT:GetAmount()
    return self.amount or 100
end

if SERVER then
    util.AddNetworkString("stek.SyncResourceAmount")
    ---

    function ENT:Initialize()
        self:SetAmount(100, true)
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
        local resource_ent = net.ReadEntity()
        if not IsValid(resource_ent) then return end

        local amount = net.ReadUInt(8)
        resource_ent.amount = amount
    end)

    function ENT:Draw()
        self:DrawModel()
    end
end