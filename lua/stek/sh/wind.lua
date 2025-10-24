stek.Wind = Vector(math.Rand(-1, 1), math.Rand(-1, 1), 0)
stek.WindSpeed = 0

stek.WindLerps = {}

for i = 1, 5 do
    stek.WindLerps[i] = {stek.Wind, 0}
end

function stek.WindInit()
    if SERVER then
        timer.Create("stek.ChangeWind", 5, 0, function()
            local Wind = stek.Wind
            local ChangeWind = Vector(math.Rand(-1, 1), math.Rand(-1, 1), 0) / 5

            stek.Wind = (Wind + ChangeWind):GetNormalized()

            stek.SyncWind()
        end)
    end

    local Seed = math.Rand(0, 255)

    hook.Add("Tick", "stek.WindLerp", function()
        local time = CurTime() / 10

        local first = stek.SimplexNoise.noise(time / 20, 1 / 20, Seed)
        local second = stek.SimplexNoise.noise(time / 120, 1 / 120, Seed)
        local val = (first + second) / 2
        stek.WindSpeed = val * 1000

        for i = 1, 5 do
            local current = stek.WindLerps[i]
            local forward = stek.WindLerps[i - 1] or {stek.Wind, stek.WindSpeed}

            stek.WindLerps[i] = {
                LerpVector(FrameTime() * 2, current[1], forward[1]),
                Lerp(FrameTime() * 2, current[2], forward[2])
            }
        end
    end)
end

function stek.GetLerpedWind()
    local WindLerps = stek.WindLerps
    return WindLerps[#WindLerps][1]
end

function stek.GetLerpedWindSpeed()
    local WindLerps = stek.WindLerps
    return WindLerps[#WindLerps][2]
end

if SERVER then
    util.AddNetworkString("stek.WindSync")

    function stek.SyncWind(ply)
        net.Start("stek.WindSync")
        net.WriteFloat(stek.Wind.x)
        net.WriteFloat(stek.Wind.y)
        net.WriteFloat(stek.WindSpeed)

        if ply then
            net.Send(ply)
        else
            net.Broadcast()
        end
    end

    hook.Add("PlayerAuthed", "stek.SyncWind", function(ply)
        stek.SyncWind(ply)
    end)
else
    net.Receive("stek.WindSync", function(len)
        stek.Wind = Vector(net.ReadFloat(), net.ReadFloat(), 0)
        stek.WindSpeed = net.ReadFloat()
    end)
end