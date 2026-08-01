---@class Inventory
---@field resources { [string]: number }
---@field container Entity[]
---@field owner Entity?
---@field object Entity?
---@field max_volume number
local InventoryClass = {}
InventoryClass.__index = InventoryClass

STEK_ARMOR_HEAD = 1
STEK_ARMOR_EYES = 2
STEK_ARMOR_EARS = 3
STEK_ARMOR_LOWER_FACE = 4
STEK_ARMOR_SHOULDER_LEFT = 5
STEK_ARMOR_SHOULDER_RIGHT = 6
STEK_ARMOR_FOREARM_LEFT = 7
STEK_ARMOR_FOREARM_RIGHT = 8
STEK_ARMOR_CHEST = 9
STEK_ARMOR_BACK = 10
STEK_ARMOR_WAIST = 11
STEK_ARMOR_PELVIS = 12
STEK_ARMOR_THIGH_LEFT = 13
STEK_ARMOR_THIGH_RIGHT = 14
STEK_ARMOR_CALF_LEFT = 15
STEK_ARMOR_CALF_RIGHT = 16

---
---@return Inventory
function InventoryClass:new()
    local Object = {
        resources = {},
        container = {},

        owner = nil,
        object = nil,

        max_volume = 100,
    }

    return setmetatable(Object, self)
end

---
---@return number
function InventoryClass:GetVolume()
    local volume = 0

    for res_id, count in pairs(self.resources) do
        local res = stek.Resources.GetByID(res_id)
        volume = volume + (res.volume * count)
    end

    return volume
end

---
---@return number
function InventoryClass:GetFreeSpace()
    return self.max_volume - self:GetVolume()
end

---

---
---@param res string
---@param count number
---@return number|false
function InventoryClass:AddResource(res, count)
    local free = self:GetFreeSpace()
    if free <= 0 then
        return false
    end

    local res_object = stek.Resources.GetByID(res)

    local all_resource_volume = res_object.volume * count

    if all_resource_volume <= free then
        self.resources[res_object.id] = (self.resources[res_object.id] or 0) + count
        return count
    else
        local can_contain = math.floor(free / res_object.volume)
        if can_contain >= 1 then
            self.resources[res_object.id] = (self.resources[res_object.id] or 0) + can_contain
            return can_contain
        else
            return false -- not enough space
        end
    end
end

---
---@param res string
---@param count number
---@return number|false
function InventoryClass:SubResource(res, count)
    if not self.resources[res] then return false end

    local can_substract = math.min(count, self.resources[res])
    self.resources[res] = self.resources[res] - can_substract

    if self.resources[res] <= 0 then
        self.resources[res] = nil
    end

    return can_substract
end

---

local Inv = {}

function Inv.Create(owner, object)
    if owner and not object then
        object = owner
    end

    local Object = InventoryClass:new()
    Object.owner = owner
    Object.object = object

    return Object
end

stek.Inv = Inv
