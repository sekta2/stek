local GasSystem = stek.GasSystem

util.AddNetworkString("stek.GasSystem.SyncParticles")
util.AddNetworkString("stek.GasSystem.NewParticle")
util.AddNetworkString("stek.GasSystem.RemoveParticle")

function GasSystem.SyncAll()
    local count = GasSystem.pull:Count()

    net.Start("stek.GasSystem.SyncParticles")
    net.WriteUInt(count, 16)

    GasSystem.pull:Foreach(function(cell)
        ---@type GasParticle
        local Particle = cell.data

        net.WriteUInt(Particle.uid, 16)
        net.WriteUInt(Particle.type_obj.uid, GasSystem.bits_count)
    end)
end

---

function GasSystem.Update()

end