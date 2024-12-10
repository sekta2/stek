s_inv.localInventory = s_inv.localInventory or s_inv.new_object()

local actions = {
    [STEK_NET_INV_FETCH] = function()
        local inv = s_inv.localInventory
        if not inv:GetOwner() then inv:SetOwner(LocalPlayer()) end

        local slots = net.ReadTable()
        local resources = net.ReadTable()

        inv.slots = slots
        inv.resources = resources
    end
}

net.Receive("s_inv.act", function()
    local action = net.ReadUInt(2)

    local fn = actions[action]
    if fn then fn() end
end)

--[[------------------------]]--

concommand.Add("stek_inv", function()
    net.Start("s_inv.act")
        net.WriteUInt(STEK_NET_INV_FETCH, 2)
    net.SendToServer()
end)

concommand.Add("stek_inv_drop_res", function(ply, cmd, args, argStr)
    local res = args[1]
    local amount = tonumber(args[2])

    local res_obj = res and s_res.get_by_id(res) or nil

    if res and res_obj and amount then
        local res_uid = res_obj.uid

        net.Start("s_inv.act")
            net.WriteUInt(STEK_NET_INV_DROP_RES, 2)
            net.WriteSmartUInt(res_uid)
            net.WriteUInt(amount, 8)
        net.SendToServer()
    end
end)

concommand.Add("stek_inv_debug", function()
    PrintTable(s_inv.localInventory.slots)
    PrintTable(s_inv.localInventory.resources)
end)