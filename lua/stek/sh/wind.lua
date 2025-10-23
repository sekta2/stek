stek.Wind = Vector(math.Rand(-1, 1), math.Rand(-1, 1), 0)
stek.WindLerps = {}

for i = 1, 5 do
    stek.WindLerps[i] = stek.Wind
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

    hook.Add("Tick", "stek.WindLerp", function()
        for i = 1, 5 do
            local current = stek.WindLerps[i]
            local forward = stek.WindLerps[i - 1] or stek.Wind

            stek.WindLerps[i] = LerpVector(FrameTime() * 2, current, forward)
        end
    end)
end

function stek.GetLerpedWind()
    local WindLerps = stek.WindLerps
    return WindLerps[#WindLerps]
end

if SERVER then
    util.AddNetworkString("stek.WindSync")

    function stek.SyncWind(ply)
        net.Start("stek.WindSync")
        net.WriteFloat(stek.Wind.x)
        net.WriteFloat(stek.Wind.y)

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
    end)
end