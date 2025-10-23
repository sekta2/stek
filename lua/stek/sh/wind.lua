stek.Wind = Vector(math.random(), math.random(), math.Rand(-1, 0))
stek.WindLerps = {}

for i = 1, 15 do
    stek.WindLerps[i] = stek.Wind
end

function stek.WindInit()
    if SERVER then
        timer.Create("stek.ChangeWind", 5, 0, function()
            local Wind = stek.Wind
            local WindZ = Wind.z
            local ChangeWind = Vector(math.random(), math.random(), math.Rand(-1 - WindZ, 0 - WindZ))

            stek.Wind = (Wind + ChangeWind):GetNormalized()

            stek.SyncWind()
        end)
    end

    hook.Add("Tick", "stek.WindLerp", function()
        for i = 1, 15 do
            local current = stek.WindLerps[i]
            local forward = stek.WindLerps[i - 1] or stek.Wind

            stek.WindLerps[i] = LerpVector(FrameTime() * 2, current, forward)
        end
    end)
end

if SERVER then
    util.AddNetworkString("stek.WindSync")

    function stek.SyncWind(ply)
        net.Start("stek.WindSync")
        net.WriteDouble(stek.WindLerps[15].x)
        net.WriteDouble(stek.WindLerps[15].y)
        net.WriteDouble(stek.WindLerps[15].z)

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
        stek.Wind = Vector(net.ReadDouble(), net.ReadDouble(), net.ReadDouble())
    end)
end