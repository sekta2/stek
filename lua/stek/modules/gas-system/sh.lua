---@class GasParticle
---@field type string
---@field pos Vector
---@field uid integer
---@field server_uid integer Идентификатор частицы на сервере, доступен только из client-side
---@field type_obj GasType
local GasParticle = {}
GasParticle.__index = GasParticle

function GasParticle:new(type, pos)
    local object = {
        uid = nil,
        server_uid = nil,

        type = type,
        pos = pos,
    }

    object.type_obj = stek.GasSystem.GetByID(type)

    return setmetatable(object, self)
end

---

---@class GasSystemModule
---@field list table<integer, GasType>
---@field index table<string, GasType>
---@field pull SmartArray
---@field serverpull table<integer, GasParticle> Table(server_uid = ParticleObject), доступен только из client-side
---@field bits_count integer
local GasSystem = {
    list = {},
    index = {},

    bits_count = 1
}

function GasSystem.InitPull()
    GasSystem.pull = stek.SmartArray:new()
end

function GasSystem.Spawn(type, pos)
    local NewParticle = GasParticle:new(type, pos)

    local ParticleCell = GasSystem.pull:PlaceBefore(0, NewParticle)
    if not ParticleCell then return end

    NewParticle.uid = ParticleCell.uid

    return NewParticle
end

function GasSystem.GetParticle(uid)
    local Cell = GasSystem.pull:GetCell(uid)
    return Cell.data
end

---

---@class GasType
---@field uid integer
---@field id string
---@field base_size integer
---@field color Color

---@param id string
---@param data table
function GasSystem.Add(id, data)
    local uid = #GasSystem.list + 1

    local obj = {
        uid = uid,
        id = id,
        base_size = data.base_size,
        color = data.color
    }

    GasSystem.list[uid] = obj
    GasSystem.index[id] = obj

    GasSystem.bits_count = stek.BitsForUnsignedInt(uid)
end

---@param id string
---@return GasType
function GasSystem.GetByID(id)
    return GasSystem.index[id]
end

---@param uid integer
---@return GasType
function GasSystem.GetByUID(uid)
    return GasSystem.list[uid]
end

---

function GasSystem.Init()
    GasSystem.InitPull()

    GasSystem.Add("tear", {
        base_size = 1,
        color = Color(55, 55, 55)
    })
end

stek.GasSystem = GasSystem