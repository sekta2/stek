---@diagnostic disable assign-type-mismatch

util.AddNetworkString("stek.Craft")

net.Receive("stek.Craft", function(len, ply)
    local tr = ply:GetEyeTrace()

    ---@type ent_stek_craft_base
    local trace_ent = tr.Entity
    local distance = tr.StartPos:DistToSqr(tr.HitPos)

    -- Существует ли энтити
    if not (trace_ent and IsValid(trace_ent)) then return end

    -- Это стол для крафта?
    if not scripted_ents.IsBasedOn(trace_ent:GetClass(), "ent_stek_craft_base") then return end

    -- До него разрешённая дистанция?
    if distance > 10000 then return end

    local craft = net.ReadSTEKCraft()
    if not craft then return end

    local craft_table = stek.Craft.GetTableByID(trace_ent.CraftTable)
    local index = craft_table:GetCraftsIndex()

    -- Разрешён ли крафт в этом столе для крафта?
    if not index[craft.id] then return end

    print("craft allowed")
end)
