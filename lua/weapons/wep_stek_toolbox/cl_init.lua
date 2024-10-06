include("shared.lua")

function SWEP:GetCraftModel()
    if not self.craft_model then
        self.craft_model = ClientsideModel("models/props_c17/FurnitureTable002a.mdl")
    end

    return self.craft_model
end

--[[------------------------]]--

function SWEP:OnRemove()
    if IsValid(self.craft_model) then
        self.craft_model:Remove()
    end
end

function SWEP:ViewModelDrawn()
    local model = self:GetCraftModel()

    local recipe = self.Recipes["wood_table"]
    local mins, maxs = recipe.hull.mins, recipe.hull.maxs

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