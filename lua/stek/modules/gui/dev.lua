STEK_GLOBAL_DEV_PANEL = nil

concommand.Add("stek_dev_inv", function()
    if IsValid(STEK_GLOBAL_DEV_PANEL) then
        STEK_GLOBAL_DEV_PANEL:Remove()
        STEK_GLOBAL_DEV_PANEL = nil
    end

    STEK_GLOBAL_DEV_PANEL = stek.GUI.CreateInventory()
    STEK_GLOBAL_DEV_PANEL:Center()
end)

concommand.Add("stek_dev_craft", function()
    if IsValid(STEK_GLOBAL_DEV_PANEL) then
        STEK_GLOBAL_DEV_PANEL:Remove()
        STEK_GLOBAL_DEV_PANEL = nil
    end

    STEK_GLOBAL_DEV_PANEL = stek.GUI.CreateCraftPanel()
    STEK_GLOBAL_DEV_PANEL:SetSize(1000, 450)
    STEK_GLOBAL_DEV_PANEL:Center()

    STEK_GLOBAL_DEV_PANEL:Refresh()
end)
