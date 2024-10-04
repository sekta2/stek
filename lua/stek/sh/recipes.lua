stek_recipes = stek_recipes or {
    list = {},
    uid = 0
}

-- shared function
function stek_recipes.add_recipe(id, name, desc, craftables, craft_type)
    -- Если рецепт существует - перезаписываем
    if stek_recipes.list[id] then
        stek_recipes.list[id].name = name
        stek_recipes.list[id].desc = desc
        stek_recipes.list[id].craftables = craftables
        stek_recipes.list[id].craft_type = craft_type

        return
    end

    stek_recipes.uid = stek_recipes.uid + 1
    local uid = stek_recipes.uid

    stek_recipes.list[id] = {
        id = id,

        name = name,
        desc = desc,

        uid = uid,

        craftables = craftables,
        craft_type = craft_type
    }

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

-- тут гениальные рецепты