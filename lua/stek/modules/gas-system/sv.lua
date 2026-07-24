local SHG_SIZE = 50

---@class GasSystemModule
local GasSystem = stek.GasSystem

util.AddNetworkString("stek.GasSystem.SyncParticles")
util.AddNetworkString("stek.GasSystem.NewParticle")
util.AddNetworkString("stek.GasSystem.RemoveParticle")

function GasSystem.SyncAll()
    local count = GasSystem.pull:Count()

    net.Start("stek.GasSystem.SyncParticles")
    net.WriteUInt(count, 13)

    GasSystem.pull:Foreach(function(cell)
        ---@type GasParticle
        local Particle = cell.data

        net.WriteUInt(Particle.uid, 13)
        net.WriteUInt(Particle.type_obj.uid, GasSystem.bits_count)
        net.WriteVector(Particle.pos)
    end)

    net.Broadcast()
end

---

local function is_valid_vector(v)
    return v and v.x == v.x and v.y == v.y and v.z == v.z
end

local function find_free_pos(pos, mins, maxs)
    if not is_valid_vector(pos) then return Vector(0, 0, 0) end

    local range = 1
    local data = {
        mins = mins,
        maxs = maxs,
        mask = bit.bor(MASK_SOLID, MASK_WATER)
    }

    local variants = {}
    local i = 0
    local max_iterations = 500

    while (#variants < 15 and i < max_iterations) do
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

    if #variants == 0 then
        return pos
    end

    table.sort(variants, function(a, b)
        return a:Distance(pos) < b:Distance(pos)
    end)

    return variants[1]
end

function GasSystem.Update()
    if not GasSystem.pull then return end

    local to_collision_update = {}

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
        elseif trace.Hit then
            Particle.pos = trace.HitPos + trace.HitNormal * 1

            local CurVelAng, Speed = Particle.velocity:Angle(), Particle.velocity:Length()
            CurVelAng:RotateAroundAxis(trace.HitNormal, 180)
            Particle.velocity = -(CurVelAng:Forward() * Speed)
        else
            Particle.pos = trace.HitPos
        end

        local pos = Particle.pos
        local shg_lastpos = Particle.shg_lastpos
        local new_shgpos = Vector(math.ceil(pos.x / SHG_SIZE), math.ceil(pos.y / SHG_SIZE), math.ceil(pos.z / SHG_SIZE))

        if new_shgpos ~= shg_lastpos then
            GasSystem.shg:RemoveObject(shg_lastpos.x, shg_lastpos.y, shg_lastpos.z, Particle)
            GasSystem.shg:AddObject(new_shgpos.x, new_shgpos.y, new_shgpos.z, Particle)

            Particle.shg_lastpos = new_shgpos
        end

        Particle.nextupdate = CurTime() + math.Rand(1, 1.5)
        Particle.lastupdatetime = CurTime()

        to_collision_update[#to_collision_update+1] = Particle
    end)

    for i = 1, #to_collision_update do
        ---@type GasParticle
        local Particle = to_collision_update[i]
        local shg_pos = Particle.shg_lastpos

        for x = -1, 1 do
            for y = -1, 1 do
                for z = -1, 1 do
                    local shgcell = GasSystem.shg:GetCell(shg_pos.x + x, shg_pos.y + y, shg_pos.z + z)
                    if shgcell then
                        for i = 1, #shgcell do
                            ---@type GasParticle
                            local other_par = shgcell[i]
                            if other_par == Particle then goto skip end

                            local collision_axis = Particle.pos - other_par.pos
                            local dist = collision_axis:Length()
                            local min_dist = 20 + 20

                            if dist < min_dist then
                                local n
                                if dist < 0.0001 then
                                    n = VectorRand():GetNormalized()
                                else
                                    n = collision_axis / dist
                                end

                                local delta = min_dist - dist

                                local trace1 = util.TraceHull({
                                    start = Particle.pos,
                                    endpos = Particle.pos + 0.5 * delta * n,
                                    mins = Vector(-10, -10, -10),
                                    maxs = Vector(10, 10, 10),
                                    mask = bit.bor(MASK_SOLID, MASK_WATER)
                                })

                                local trace2 = util.TraceHull({
                                    start = other_par.pos,
                                    endpos = other_par.pos - 0.5 * delta * n,
                                    mins = Vector(-10, -10, -10),
                                    maxs = Vector(10, 10, 10),
                                    mask = bit.bor(MASK_SOLID, MASK_WATER)
                                })

                                Particle.pos = trace1.HitPos
                                other_par.pos = trace2.HitPos
                            end

                            ::skip::
                        end
                    end
                end
            end
        end
    end

    if #to_collision_update >= 1 then
        local count = #to_collision_update

        net.Start("stek.GasSystem.SyncParticles")
        net.WriteUInt(count, 13)

        for i = 1, #to_collision_update do
            ---@type GasParticle
            local Particle = to_collision_update[i]

            net.WriteUInt(Particle.uid, 13)
            net.WriteUInt(Particle.type_obj.uid, GasSystem.bits_count)
            net.WriteVector(Particle.pos)
        end

        net.Broadcast()
    end
end

hook.Add("Tick", "stek.GasSystem.ServerUpdate", function()
    GasSystem.Update()
end)
