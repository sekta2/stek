local InventoryClass = {}
InventoryClass.__index = InventoryClass

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

function InventoryClass:GetVolume()
    local volume = 0

    for res_id, count in pairs(self.resources) do
        local res = stek.Resources.GetByID(res_id)
        volume = volume + (res.volume * count)
    end

    return volume
end

function InventoryClass:GetFreeSpace()
    return self.max_volume - self:GetVolume()
end

---

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