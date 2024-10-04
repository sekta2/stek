stek.resources = {}

-- shared function
function stek.add_resource(id)
    local index = #stek.resources + 1

    stek.resources[index] = id

    _G["STEK_RESOURCE_" .. string.upper(id)] = index
end

-- shared function
function stek.get_resource(index)
    return stek.resources[index]
end