local GasParticle = {}
GasParticle.__index = GasParticle

function GasParticle:new(pos)
    local object = {
        pos = pos,
    }

    return setmetatable(object, self)
end

---

local GasSystem = {
    list = {},
    pull = {},

    bits_count = 1
}

function GasSystem.Spawn()
    --- TODO
end

function GasSystem.Add(id, data)
    --- TODO
end

stek.GasSystem = GasSystem