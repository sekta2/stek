local SHG_SIZE = 50

---@class GasSystemModule
local GasSystem = stek.GasSystem

util.AddNetworkString("stek.GasSystem.SyncParticles")
util.AddNetworkString("stek.GasSystem.NewParticle")
util.AddNetworkString("stek.GasSystem.RemoveParticle")

function GasSystem.SyncAll()
    local count = GasSystem.pull:Count()

    net.Start("stek.GasSystem.SyncParticles")
    net.WriteUInt(count, 10)

    GasSystem.pull:Foreach(function(cell)
        ---@type GasParticle
        local Particle = cell.data

        net.WriteUInt(Particle.uid, 10)
        net.WriteUInt(Particle.type_obj.uid, GasSystem.bits_count)
        net.WriteVector(Particle.pos)
    end)

    net.Broadcast()
end

---

local function find_free_pos(pos, mins, maxs)
    local range = 1
    local data = {
        mins = mins,
        maxs = maxs,
        mask = bit.bor(MASK_SOLID, MASK_WATER)
    }

    local variants = {}
    local i = 0
    while (#variants < 15) do
        i = i + 1
        data.start = pos + VectorRand() * range
        data.endpos = data.start

        local trace = util.TraceHull(data)

        if not trace.StartSolid then
            local new_trace = util.TraceHull({
                start = trace.HitPos,
                endpos = pos,
                mins = mins,
                maxs = maxs,
                mask = bit.bor(MASK_SOLID, MASK_WATER)
            })

            variants[#variants + 1] = new_trace.HitPos
        end

        range = range + 0.5
    end

    ---@param a Vector
    ---@param b Vector
    table.sort(variants, function(a, b)
        return a:Distance(pos) < b:Distance(pos)
    end)

    return variants[1]
end

function GasSystem.Update()
    if not GasSystem.pull then return end

    GasSystem.pull:Foreach(function(cell)
        ---@type GasParticle
        local Particle = cell.data
        if CurTime() < Particle.nextupdate then return end

        local dt = CurTime() - Particle.lastupdatetime

        local Force = (VectorRand(-4, 4) + Vector(0, 0, -8)) * dt
        Particle.velocity = Particle.velocity + Force
        Particle.velocity = Particle.velocity:GetNormalized() * math.min(Particle.velocity:Length(), 80)

        local trace = util.TraceHull({
            start = Particle.pos,
            endpos = Particle.pos + Particle.velocity * dt,
            mins = Vector(-10, -10, -10),
            maxs = Vector(10, 10, 10),
            mask = bit.bor(MASK_SOLID, MASK_WATER)
        })

        if trace.StartSolid then
            local newpos = find_free_pos(Particle.pos, Vector(-10, -10, -10), Vector(10, 10, 10))
            Particle.pos = newpos
            Particle.velocity = vector_origin
        elseif trace.Hit then
            Particle.pos = trace.HitPos + trace.HitNormal * 1

            local CurVelAng, Speed = Particle.velocity:Angle(), Particle.velocity:Length()
            CurVelAng:RotateAroundAxis(trace.HitNormal, 180)
            Particle.velocity = -(CurVelAng:Forward() * Speed)
        else
            Particle.pos = trace.HitPos
        end

        Particle.nextupdate = CurTime() + math.Rand(1, 1.5)
        Particle.lastupdatetime = CurTime()
    end)

    GasSystem.SyncAll()
end

hook.Add("Tick", "stek.GasSystem.ServerUpdate", function()
    GasSystem.Update()
end)
