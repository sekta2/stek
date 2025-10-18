AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_resource: Entity
---@field Model string?
---@field Skin number?
---@field Color Color?
---@field Material string?
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Category = "STek: Resources"
ENT.Author = "sekta"

function ENT:GetAmount()
    return self.amount or 100
end

if SERVER then
    local function GetDatafiedResources()
        local all_resources = {}

        for ent_index, _ in pairs(stek.Resources.active_ents) do
            ---@type ent_stek_resource
            local ent = Entity(ent_index)
            if not (IsValid(ent) and ent:GetAmount() ~= 100) then continue end

            all_resources[#all_resources+1] = {ent_index, ent:GetAmount()}
        end

        if #all_resources <= 0 then return false end

        local data = util.Compress(util.TableToJSON(all_resources))

        return data, #data
    end

    util.AddNetworkString("stek.SyncResourceAmount")
    util.AddNetworkString("stek.SyncResourceAmountFull")

    hook.Add("PlayerAuthed", "stek.Resources.SyncResoucesAmount", function(ply)
        local data, len = GetDatafiedResources()
        if not (data and len) then return end

        net.Start("stek.SyncResourceAmountFull")
        net.WriteUInt(len, 16)
        net.WriteData(data, len)
        net.Send(ply)
    end)

    ---

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

        stek.Resources.RegisterActiveEntity(self)
        self:SetAmount(100, true)
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
        local resource_ent = net.ReadEntity()
        if not IsValid(resource_ent) then return end

        local amount = net.ReadUInt(8)
        resource_ent.amount = amount
    end)

    net.Receive("stek.SyncResourceAmountFull", function(len)
        local length = net.ReadUInt(16)

        local uncompressed = util.Decompress(net.ReadData(length))
        if not uncompressed then print("Resource amounts sync failed: Decompress step") return end

        local tbl = util.JSONToTable(uncompressed)
        if not tbl then print("Resource amounts failed: Un-Json step") return end

        for i = 1, #tbl do
            local data = tbl[i]

            local ent = Entity(data[1])
            if not IsValid(ent) then continue end

            ent.amount = data[2]
        end

        print("Resource amounts synced! " .. len .. " bits")
    end)

    function ENT:Draw()
        self:DrawModel()
    end
end