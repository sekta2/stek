s_craft = {
    list = {},
    id_list = {}
}

function s_craft.add(id, struct)
    local m_struct = {
        id = id,
    }

    local uid = #s_craft.list + 1

    s_craft.list[uid] = m_struct
    s_craft.id_list[id] = m_struct

    s_util.print("Added new recipe: " .. id .. " | UID: " .. uid)

    return uid
end

function s_craft.get_by_id(id)
    return s_craft.id_list[id]
end

function s_craft.get_by_uid(uid)
    return s_craft.list[uid]
end

--[[------------------------]]--

function s_craft.load()

end