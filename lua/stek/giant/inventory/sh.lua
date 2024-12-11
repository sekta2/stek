s_inv = {}

--[[------------------------]]--

STEK_INV_SLOT_HEAD = 1
STEK_INV_SLOT_BODY = 2
STEK_INV_SLOT_LEFTARM = 3
STEK_INV_SLOT_RIGHTARM = 4
STEK_INV_SLOT_LEFTLEG = 5
STEK_INV_SLOT_RIGHTLEG = 6
STEK_INV_SLOT_SPINE = 7

--[[------------------------]]--

STEK_NET_INV_FETCH = 1
STEK_NET_INV_DROP_RES = 2

--[[------------------------]]--

local INV = {}
INV.__index = INV

function INV:Initialize()
    self.slots = {}
    self.resources = {}
end

function INV:Destroy()
    setmetatable(self, {__mode = "v"})
    collectgarbage("collect")
end

function INV:Sync()
    local owner = self:GetOwner()

    if SERVER and owner and IsValid(owner) and owner:IsPlayer() then
        owner:INVSyncInventory()
    end
end

s_util.set_get_function(INV, "owner", "Owner")

--[[------------------------]]--

function INV:SetSlot(slot, ent)
    self.slots[slot] = ent

    self:Sync()
end

function INV:GetSlot(slot)
    return self.slots[slot]
end

--[[------------------------]]--

function INV:GetResourceLimit()
    local limit = 40
    return limit
end

function INV:GetResourceAvailableSpace()
    local limit = self:GetResourceLimit()

    local space = 0

    for k, v in pairs(self.resources) do
        space = space + v
    end

    return limit - space
end

function INV:AddResource(res, amount, ent)
    if not s_res.get_by_id(res) then return end

    local available = self:GetResourceAvailableSpace()

    local amount_allowed = math.Clamp(amount, 0, available)
    if amount_allowed <= 0 then return end

    if self.resources[res] then
        self.resources[res] = self.resources[res] + amount_allowed
    else
        self.resources[res] = amount_allowed
    end

    local owner = self:GetOwner()

    if ent and owner then
        s_util.res_effect(res, ent:LocalToWorld(ent:OBBCenter()), owner:LocalToWorld(owner:OBBCenter()), 1, 1, 1)
    end

    self:Sync()

    return amount_allowed
end

function INV:SubResource(res, amount)
    if not s_res.get_by_id(res) then return end

    if not self.resources[res] then return end

    amount = amount or self.resources[res]
    self.resources[res] = self.resources[res] - amount

    if self.resources[res] <= 0 then
        self.resources[res] = nil
    end

    self:Sync()

    return amount
end

function s_inv.new_object(ply)
    local inv = {}
    setmetatable(inv, INV)

    if ply and IsValid(ply) then inv:SetOwner(ply) end

    inv:Initialize()

    return inv
end