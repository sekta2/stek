---@class GasSystemModule
local GasSystem = stek.GasSystem
GasSystem.serverpull = {}

---

function GasSystem.Draw()
    if not GasSystem.pull then return end

    --- need to developed
    GasSystem.pull:Foreach(function(cell)
        ---@type GasParticle
        local Particle = cell.data

        local Pos = Particle.pos
        cam.Start2D()
        local screen_pos = Pos:ToScreen()
        draw.SimpleText("(--+--)", "Default", screen_pos.x, screen_pos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        cam.End2D()
    end)
end

hook.Add("PreDrawTranslucentRenderables", "stek.GasSystem.Draw", function(isDrawingDepth, isDrawSkybox, isDraw3DSkybox)
    GasSystem.Draw()
end)

net.Receive("stek.GasSystem.SyncParticles", function(len, _)
    local count = net.ReadUInt(10)

    for i = 1, count do
        local server_uid = net.ReadUInt(10)
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
