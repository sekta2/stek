AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:BuildEffect(pos, size)
    local eff = EffectData()
    eff:SetOrigin(pos + VectorRand())
    eff:SetScale(size * 0.03)

    util.Effect("eff_jack_gmod_ezbuildsmoke", eff, true, true)
end

function SWEP:Craft(recipe_id)
    local owner = self:GetOwner()
    local recipe = stek_recipes.get_recipe_by_uid(self:GetRecipe())
    if not recipe then return end

    local hull = recipe.hull

    local size = (hull.maxs.x + hull.maxs.y + hull.maxs.z) / 3
    
    local tr = self:HullTrace(hull.mins, hull.maxs)
    local pos = tr.HitPos

    local func = recipe.func
    func(owner, pos)

    self:BuildEffect(pos, size)
    for i = 1, math.random(2, 10) do
        sound.Play("snds_jack_gmod/ez_tools/" .. math.random(1, 27) .. ".ogg", pos, 60, math.random(80, 120))
    end
end

--[[------------------------]]--

function SWEP:Reload()
    local cooldown = self.reload_time or 0
    if CurTime() < cooldown then return end

    self.reload_time = CurTime() + 0.3

    self:SetRecipe(math.random(1, 2))
end

function SWEP:Deploy()
    if not IsValid(self:GetOwner()) then return end
    
    self:EmitSound("snds_jack_gmod/toolbox" .. math.random(1, 7) .. ".ogg", 65, math.random(90, 110))

    self:SetNextPrimaryFire(CurTime() + 1)
    self:SetNextSecondaryFire(CurTime() + 1)

    return true
end

function SWEP:PrimaryAttack()
    local recipe = stek_recipes.get_recipe_by_uid(self:GetRecipe())
    if not recipe then return end

    local hull = recipe.hull

    local tr = self:HullTrace(hull.mins, hull.maxs)
    local check = self:CanCraftTrace(tr.HitPos, hull.mins, hull.maxs)

    if check then self:Craft("wood_table") end

    self:SendWeaponAnim(PLAYER_ATTACK1)
end

function SWEP:SecondaryAttack()
end