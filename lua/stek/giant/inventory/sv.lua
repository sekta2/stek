local function PlayerSpawn(ply, tran)
    ply.inventory = s_inv.new_object(ply)
end

hook.Add("PlayerSpawn", "s_inv.ply_set_inventory", PlayerSpawn)

--[[------------------------]]--

local meta = FindMetaTable("Player")

function meta:GetInventory()
    return self.inventory
end

function meta:INVSyncInventory()
    local inv = self:GetInventory()
    if not inv then return end

    net.Start("s_inv.act")
        net.WriteUInt(STEK_NET_INV_FETCH, 2)
        net.WriteTable(inv.slots)
        net.WriteTable(inv.resources)
    net.Send(self)
end

--[[------------------------]]--

util.AddNetworkString("s_inv.act")

local actions = {
    [STEK_NET_INV_FETCH] = function(ply)
        ply:INVSyncInventory()
    end,

    [STEK_NET_INV_DROP_RES] = function(ply)
        local res = net.ReadSmartUInt()
        local amount = net.ReadUInt(8)

        local res_obj = s_res.get_by_uid(res)

        if not res_obj then return end

        local id = res_obj.id
        local inv = ply:GetInventory()

        if inv and inv.resources[id] then
            amount = math.Clamp(amount, 1, inv.resources[id])

            local allowed = inv:SubResource(id, amount)

            local ang = ply:GetAngles()
            local pos = ply:GetPos() + ang:Forward() * 90 + ang:Up() * 35

            local ent = ents.Create(res_obj.classname)
            ent:SetAmount(allowed)
            ent:SetPos(pos)
            ent:SetAngles(ang)

            ent:Spawn()
        end
    end
}

net.Receive("s_inv.act", function(_, ply)
    local action = net.ReadUInt(2)

    local fn = actions[action]
    if fn then fn(ply) end
end)