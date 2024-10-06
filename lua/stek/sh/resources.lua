stek.resources = {}

-- helper function
function stek.format_resource(id)
    local str = string.upper(id)
    str = string.Replace(str, " ", "_")

    return str
end

-- shared function
function stek.add_resource(id)
    local index = #stek.resources + 1

    stek.resources[index] = id

    _G["STEK_RESOURCE_" .. stek.format_resource(id)] = index
end

-- shared function
function stek.get_resource(index)
    return stek.resources[index]
end

