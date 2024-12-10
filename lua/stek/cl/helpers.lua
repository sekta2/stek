concommand.Add("target_ent", function(ply)
    local tr = ply:GetEyeTrace()

    s_util.print("Target ent: ", tr.Entity)
end)