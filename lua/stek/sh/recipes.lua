stek_recipes = {
    list = {},
    uid_cache = {},
    uid = 0
}

-- shared function
function stek_recipes.add_recipe(id, data)
    stek_recipes.uid = stek_recipes.uid + 1
    local uid = stek_recipes.uid

    stek_recipes.uid_cache[uid] = id
    stek_recipes.list[id] = data

    _G["STEK_RECIPE_" .. string.upper(id)] = uid
end

-- shared function
function stek_recipes.get_recipe(index)
    return stek_recipes.list[index]
end

function stek_recipes.get_recipe_by_uid(uid)
    return stek_recipes.list[stek_recipes.uid_cache[uid]]
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
    util.AddNetworkString("stek.dev.resetRecipes")

    concommand.Add("stek_reset_recipes", function(ply)
        if IsValid(ply) and not ply:IsSuperAdmin() then return end
    
        stek_recipes.list = {}
        stek_recipes.uid = 0
    
        stek_recipes.init()

        net.Start("stek.dev.resetRecipes")
        net.Broadcast()
    end)
else
    net.Receive("stek.dev.resetRecipes", function()
        stek_recipes.init()
    end)
end

--[[------------------------]]--

local basic_hull = {
    mins = -Vector(5, 5, 5),
    maxs = Vector(5, 5, 5)
}

local basic_craftables = {
    [STEK_RESOURCE_SCRAP] = 1
}

function stek_recipes.add_prop_recipe(id, model, name, desc, category, craft_type, craftables, hull)
    name = name or model
    desc = desc or "Проп который можно скрафтить"
    category = category or "Props"

    craft_type = craft_type or "toolbox"
    craftables = craftables or basic_craftables

    hull = hull or basic_hull

    stek_recipes.add_recipe(id, {
        name = name,
        desc = desc,
        craftables = craftables,
        craft_type = craft_type,

        category = category,

        model = model,
        hull = hull,

        func = function(ply, pos)
            local prop = ents.Create("prop_physics")
            prop:SetModel(model)
            prop:SetPos(pos + Vector(0, 0, 2))

            prop:Spawn()
        end
    })
end

function stek_recipes.init()
    stek_recipes.list = {}
    stek_recipes.uid_cache = {}
    stek_recipes.uid = 0

    print("[STEK] Loading recipes...")

    stek_recipes.add_prop_recipe("wood_table", "models/props_c17/FurnitureTable002a.mdl", "Wooden Table", _, _, _, _, {
        mins = -Vector(24, 24, 18),
        maxs = Vector(25, 24, 18)
    })

    stek_recipes.add_prop_recipe("plastic_cube", "models/hunter/blocks/cube075x075x075.mdl", "Plastic Cube", _, _, _, _, {
        mins = -Vector(18, 18, 18),
        maxs = Vector(18, 18, 18)
    })
end

stek_recipes.init()