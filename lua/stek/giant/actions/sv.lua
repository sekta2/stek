util.AddNetworkString("s_actions.act")
util.AddNetworkString("s_actions.err")

net.Receive("s_actions.act", function(_, ply)
    local action = net.ReadSmartUInt()

    local st = s_actions.list[action]
    if not st then return end
    if st.is_client then return end

    local args = net.ReadTable(true)
    local check_func = st.check_func

    local success, c_args = check_func(ply, args, st.args)

    if not success then
        net.Start("s_actions.err")
            net.WriteString(c_args)
        net.Send(ply)

        return
    end

    if not ply.s_acts_cooldowns then ply.s_acts_cooldowns = {} end
    local time = ply.s_acts_cooldowns[action]

    if time and time > CurTime() then
        net.Start("s_actions.err")
            net.WriteString("Wait " .. math.floor(time - CurTime()) .. " more seconds.")
        net.Send(ply)

        return
    end

    ply.s_acts_cooldowns[action] = CurTime() + st.cooldown

    local func = st.func
    func(ply, c_args)
end)