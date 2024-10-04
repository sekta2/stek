stek_actions = stek_actions or {
    list = {},
    uid_cache = {},
    uid = 0
}

-- shared function
function stek_actions.add_action(name, cooldown, func)
    -- Если действие существует - перезаписываем
    if stek_actions.list[name] then
        stek_actions.list[name].cooldown = cooldown
        stek_actions.list[name].func = func

        return
    end

    stek_actions.uid = stek_actions.uid + 1
    local uid = stek_actions.uid

    stek_actions.uid_cache[uid] = name
    stek_actions.list[name] = {
        name = name,
        cooldown = cooldown,
        func = func,
        uid = uid,

        CACHE_1 = name .. "_cooldown"
    }

    _G["STEK_ACTION_" .. string.upper(name)] = uid

    if CLIENT then
        concommand.Add("stek_action_" .. name, function()
            net.Start("stek.action")
            net.WriteUInt(uid, 5)
            net.SendToServer()
        end)
    end
end

-- server function
function stek_actions.exec_action(ply, name)
    local action = stek_actions.list[name]

    if not action then return end

    local cache = action.CACHE_1
    local cooldown = ply[cache] or 0

    if CurTime() < cooldown then return end

    local cooldown_value = action.cooldown
    ply[cache] = CurTime() + cooldown_value

    local func = action.func
    func(ply)
end

--[[------------------------]]--

if SERVER then
    util.AddNetworkString("stek.action")

    net.Receive("stek.action", function(_, ply)
        local action = net.ReadUInt(5)

        local itn = stek_actions.uid_cache[action]

        if itn then stek_actions.exec_action(ply, itn) end
    end)
end