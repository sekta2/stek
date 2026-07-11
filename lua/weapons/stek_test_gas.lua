AddCSLuaFile()

SWEP.Spawnable = true
SWEP.Primary = {
    Automatic = true
}

function SWEP:PrimaryAttack()
    if not SERVER then return end
    local tr = self:GetOwner():GetEyeTrace()

    stek.GasSystem.Spawn("test", tr.HitPos)
end

stek.GasSystem.Add("test", {})
