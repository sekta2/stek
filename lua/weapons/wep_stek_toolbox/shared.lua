SWEP.Base = "weapon_base"

SWEP.PrintName = "Crafting Tool"
--SWEP.Category = "Stek"

SWEP.Spawnable = true

SWEP.ViewModel = "models/jmod/ez/c_repairkit.mdl" --"models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel = "models/jmod/ez/c_repairkit.mdl" --"models/props_c17/tools_wrench01a.mdl"

function SWEP:HullTrace(mins, maxs, dist)
    dist = dist or 500

    local owner = self:GetOwner()

    local tr = util.TraceHull({
        start = owner:GetShootPos(),
        endpos = owner:GetShootPos() + owner:GetAimVector() * dist,

        mins = mins,
        maxs = maxs,

        filter = owner
    })

    return tr
end

function SWEP:CanCraftTrace(pos, mins, maxs)
    pos = pos - Vector(0, 0, maxs.z)

    local tr = util.TraceHull({
        start = pos,
        endpos = pos,

        mins = Vector(mins.x / 4, mins.y / 4, mins.z / 12),
        maxs = Vector(maxs.x / 4, maxs.y / 4, maxs.z / 12)
    })

    return tr.Hit
end

--[[------------------------]]--

function SWEP:Initialize()
    self:SetHoldType("fist")
end

function SWEP:SetupDataTables()
    self:NetworkVar("Int", 0, "Recipe")

    if SERVER then
        self:SetRecipe(0)
    else
        self:NetworkVarNotify("Recipe", function(ent, name, old, new)
            local recipe = stek_recipes.get_recipe_by_uid(new)

            if recipe and ent.craft_model then
                ent.craft_model:SetModel(recipe.model)
            end
        end)
    end
end