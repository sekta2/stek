---@diagnostic disable: assign-type-mismatch

local function GetDatafiedResources()
    local all_resources = {}

    for ent_index, _ in pairs(stek.Resources.active_ents) do
        ---@type ent_stek_resource
        local ent = Entity(ent_index)
        if not (IsValid(ent) and ent:GetAmount() ~= 100) then continue end

        all_resources[#all_resources + 1] = { ent_index, ent:GetAmount() }
    end

    if #all_resources <= 0 then return false end

    local data = util.Compress(util.TableToJSON(all_resources))

    return data, #data
end

util.AddNetworkString("stek.SyncResourceAmount")
util.AddNetworkString("stek.SyncResourceAmountFull")

hook.Add("PlayerAuthed", "stek.Resources.SyncResoucesAmount", function(ply)
    local data, len = GetDatafiedResources()
    if not (data and len) then return end

    net.Start("stek.SyncResourceAmountFull")
    net.WriteUInt(len, 16)
    net.WriteData(data, len)
    net.Send(ply)
end)

---@param ent ent_stek_resource
---@param ply Player
hook.Add("GetPreferredCarryAngles", "stek.Resource.CarryAngles", function(ent, ply)
    if not ent.STek_Resource then return end

    return ent.CarryAngles or angle_zero
end)
