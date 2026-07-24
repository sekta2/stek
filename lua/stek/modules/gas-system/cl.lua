---@class GasSystemModule
local GasSystem = stek.GasSystem
GasSystem.serverpull = {}

---

local Mat = Material("particle/smokestack")

function GasSystem.Draw()
    if not GasSystem.pull then return end

    GasSystem.pull:Foreach(function(cell)
        ---@type GasParticle
        local Particle = cell.data

        local Pos = Particle.pos
        local LastPos = Particle.lastpos

        render.SetMaterial(Mat)
        render.DrawSprite(LastPos, 150, 150, Color(255, 255, 255, 25))

        Particle.lastpos = LerpVector(FrameTime(), LastPos, Pos)
    end)
end

hook.Add("PreDrawTranslucentRenderables", "stek.GasSystem.Draw", function(isDrawingDepth, isDrawSkybox, isDraw3DSkybox)
    if isDrawingDepth or isDrawSkybox or isDraw3DSkybox then return end

    GasSystem.Draw()
end)

net.Receive("stek.GasSystem.SyncParticles", function(len, _)
    local count = net.ReadUInt(13)

    for i = 1, count do
        local server_uid = net.ReadUInt(13)
        local typo = net.ReadUInt(GasSystem.bits_count)
        local new_pos = net.ReadVector()

        local particle = GasSystem.serverpull[server_uid]
        if not particle then
            particle = GasSystem.Spawn(typo, new_pos)
            particle.server_uid = server_uid

            GasSystem.serverpull[server_uid] = particle
        end

        particle.pos = new_pos
    end
end)
