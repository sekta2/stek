---@class GasParticle
---@field type string
---@field pos Vector
---@field velocity Vector
---@field uid integer
---@field server_uid integer Идентификатор частицы на сервере, доступен только из client-side
---@field nextupdate number
---@field lastupdatetime number
---@field type_obj GasType
---@field lastpos Vector
local GasParticle = {}
GasParticle.__index = GasParticle

function GasParticle:new(type, pos)
    local object = {
        uid = nil,
        server_uid = nil,

        type = type,
        pos = pos,
        velocity = Vector(0, 0, 0),
        nextupdate = 0,
        lastupdatetime = CurTime(),
        lastpos = pos
    }

    object.type_obj = stek.GasSystem.GetByID(type)

    return setmetatable(object, self)
end

---

---@class GasSystemModule
---@field list GasType[]
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

hook.Add("PreCleanupMap", "stek.GasSystem.OnCleanup", function()
    GasSystem.InitPull()

    if CLIENT then
        GasSystem.serverpull = {}
    end
end)

function GasSystem.Init()
    GasSystem.InitPull()

    if CLIENT then
        GasSystem.serverpull = {}
    end
end

stek.GasSystem = GasSystem
