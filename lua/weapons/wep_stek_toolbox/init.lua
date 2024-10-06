AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:Craft(recipe_id)
    local owner = self:GetOwner()
    local recipe = self.Recipes[recipe_id]
    local hull = recipe.hull
    
    local tr = self:HullTrace(hull.mins, hull.maxs)
    local pos = tr.HitPos

    local func = recipe.func
    func(owner, pos)
end

--[[------------------------]]--

function SWEP:PrimaryAttack()
    local recipe = self.Recipes["wood_table"]
    local hull = recipe.hull

    local tr = self:HullTrace(hull.mins, hull.maxs)
    local check = self:CanCraftTrace(tr.HitPos, hull.mins, hull.maxs)

    if check then self:Craft("wood_table") end
end