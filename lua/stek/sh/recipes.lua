stek_recipes = stek_recipes or {
    list = {},
    uid_cache = {},
    uid = 0
}

-- shared function
function stek_recipes.add_recipe(id, data)
    -- Если рецепт существует - перезаписываем
    if stek_recipes.list[id] then
        stek_recipes.list[id] = data

        return
    end

    stek_recipes.uid = stek_recipes.uid + 1
    local uid = stek_recipes.uid

    stek_actions.uid_cache[uid] = id
    stek_recipes.list[id] = data

    _G["STEK_RECIPE_" .. string.upper(id)] = uid
end

-- shared function
function stek_recipes.get_recipe(index)
    return stek_recipes.list[index]
end

-- shared function
function stek_recipes.get_recipes(craft_type)
    local recipes = table.Copy(stek_recipes.list)

    if craft_type then
        for k, v in pairs(recipes) do
            if v.craft_type ~= craft_type then
                recipes[k] = nil
            end
        end
    end

    return recipes
end

--[[------------------------]]--

if SERVER then
    concommand.Add("stek_reset_recipes", function(ply)
        if IsValid(ply) and not ply:IsSuperAdmin() then return end
    
        stek_recipes.list = {}
        stek_recipes.uid = 0
    
        stek_recipes.init()
    end)
end

--[[------------------------]]--

function stek_recipes.init()
    stek_recipes.add_recipe("wood_table", {
        name = "Wooden Table",
        desc = "TEST",
        craftables = {
            [STEK_RESOURCE_WOOD] = 25
        },
        craft_type = "toolbox",

        category = "Props",

        hull = {
            mins = -Vector(24, 24, 18),
            maxs = Vector(25, 24, 18)
        },

        func = function(ply, pos)
            local prop = ents.Create("prop_physics")
            prop:SetModel("models/props_c17/FurnitureTable002a.mdl")
            prop:SetPos(pos)

            prop:Spawn()
        end
    })
end

stek_recipes.init()