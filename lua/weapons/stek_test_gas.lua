AddCSLuaFile()

SWEP.Spawnable = true
SWEP.Primary = {
    Automatic = true
}

function SWEP:PrimaryAttack()
    if not SERVER then return end

    ---@type TraceResult
    local tr = self:GetOwner():GetEyeTrace()

    local par = stek.GasSystem.Spawn("test", tr.StartPos + (tr.HitPos - tr.StartPos):GetNormalized() * 150)
    par.velocity = (tr.HitPos - tr.StartPos):GetNormalized() * 1000
end

stek.GasSystem.Add("test", {})
