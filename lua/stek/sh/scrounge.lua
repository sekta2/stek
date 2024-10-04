stek_actions.add_action("scrounge", STEK_CFG_SCROUGE_COOLDOWN, function(ply)
    local pos = ply:GetPos()
    stek.make_scrounge(pos)
end)