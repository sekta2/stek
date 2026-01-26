local GasSystem = stek.GasSystem
GasSystem.serverpull = {}

---

function GasSystem.Draw()
    --- need to developed
    GasSystem.pull:Foreach(function(cell)
        ---@type GasParticle
        local Particle = cell.data

        local Pos = Particle.pos
    end)
end

hook.Add("PreDrawTranslucentRenderables", "stek.GasSystem.Draw", function(isDrawingDepth, isDrawSkybox, isDraw3DSkybox)
    GasSystem.Draw()
end)