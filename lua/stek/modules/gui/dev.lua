STEK_GLOBAL_DEV_PANEL = nil

concommand.Add("stek_dev_inv", function()
    if IsValid(STEK_GLOBAL_DEV_PANEL) then
        STEK_GLOBAL_DEV_PANEL:Remove()
        STEK_GLOBAL_DEV_PANEL = nil
    end

    STEK_GLOBAL_DEV_PANEL = stek.GUI.CreateInventory()
end)
