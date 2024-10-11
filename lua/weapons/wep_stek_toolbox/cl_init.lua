include("shared.lua")

function SWEP:GetCraftModel()
    if not self.craft_model then
        local recipe = stek_recipes.get_recipe_by_uid(self:GetRecipe())
        local model = recipe and recipe.model or "models/hunter/blocks/cube05x05x05.mdl"

        self.craft_model = ClientsideModel(model)
    end

    return self.craft_model
end

--[[------------------------]]--

function SWEP:Holster(wep)
    if IsValid(self.craft_model) then
        self.craft_model:Remove()
        self.craft_model = nil
    end
end

function SWEP:OnRemove()
    if IsValid(self.craft_model) then
        self.craft_model:Remove()
        self.craft_model = nil
    end
end

function SWEP:ViewModelDrawn()
    local recipe = stek_recipes.get_recipe_by_uid(self:GetRecipe())
    --print(recipe, self:GetRecipe())
    if not recipe then return end

    local model = self:GetCraftModel()

    if not IsValid(model) then return end

    local hull = recipe.hull
    local mins, maxs = hull.mins, hull.maxs

    local tr = self:HullTrace(mins, maxs)
    local check = self:CanCraftTrace(tr.HitPos, mins, maxs)

    model:SetPos(tr.HitPos)
    model:SetMaterial("models/wireframe")

    if check then
        model:SetColor(Color(0, 255, 0))
    else
        model:SetColor(Color(255, 0, 0))
    end
end