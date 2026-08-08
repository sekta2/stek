AddCSLuaFile()

SWEP.Spawnable = true
SWEP.Primary = {
    Automatic = true
}

function SWEP:PrimaryAttack()
    if not SERVER then return end

    ---@type TraceResult
    local tr = self:GetOwner():GetEyeTrace() ---@diagnostic disable-line: undefined-field

    local par = stek.GasSystem.spawn("test", tr.StartPos + (tr.HitPos - tr.StartPos):GetNormalized() * 150)
    par.velocity = (tr.HitPos - tr.StartPos):GetNormalized() * 1000
end

stek.GasSystem.add("test", {})
