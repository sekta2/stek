---@param ent ent_stek_resource
---@param ply Player
hook.Add("GetPreferredCarryAngles", "stek.Resource.CarryAngles", function(ent, ply)
    if not ent.STek_Resource then return end

    return ent.CarryAngles or angle_zero
end)
