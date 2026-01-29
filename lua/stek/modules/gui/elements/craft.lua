local GUI = stek.GUI

---@class stek_craft: stek_base
local PANEL = {}

function PANEL:Init()
    local available_resources = vgui.Create("stek_base", self)
    available_resources.Paint = function(_, w, h)
        surface.SetDrawColor(0, 0, 0, 55)
        surface.DrawRect(0, 0, w, h)
    end

    self.available_resources = available_resources

    local crafts = vgui.Create("stek_base", self)
    crafts.Paint = function(_, w, h)
        surface.SetDrawColor(0, 0, 0, 55)
        surface.DrawRect(0, 0, w, h)
    end

    self.crafts = crafts
end

function PANEL:PerformLayout(w, h)
    local available_resources = self.available_resources
    available_resources:SetWide(w / 4 - 7.5)
    available_resources:SetTall(h - 10)

    available_resources:SetPos(5, 5)

    local crafts = self.crafts
    crafts:SetWide(w - (w / 4) - 7.5)
    crafts:SetTall(h - 10)

    crafts:SetPos(w - crafts:GetWide() - 5, 5)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 55)
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("stek_craft", PANEL, "stek_base")
