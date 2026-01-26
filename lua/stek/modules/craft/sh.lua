local Craft = {
    list = {},
    index = {},

    bits_count = 1
}

function Craft.Create(id, data)
    local uid = #Craft.list + 1

    Craft.list[uid] = data
    Craft.index[id] = data

    Craft.bits_count = stek.BitsForUnsignedInt(uid)
end

function Craft.GetByUID(uid)
    return Craft.list[uid]
end

function Craft.GetByID(id)
    return Craft.index[id]
end

stek.shared("net.lua")

stek.Craft = Craft
