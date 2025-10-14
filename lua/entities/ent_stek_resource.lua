---@class ent_stek_resource: ENT
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Category = "STek: Resources"
ENT.Author = "sekta"

function ENT:GetAmount()
    return self.amount
end

if SERVER then
    util.AddNetworkString("stek.SyncResourceAmount")

    function ENT:SetAmount(num)
        self.amount = num
    end
else
    function ENT:Draw()
        self:DrawModel()
    end
end