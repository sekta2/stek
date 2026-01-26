local GUI = stek.GUI

---@class stek_button: stek_base
local PANEL = {}

function PANEL:Init()
    self.text = "stek_button"
    self.style = "normal"

    self:SetCursor("hand")
end

function PANEL:OnClick()
end

function PANEL:OnLeftClick()
end

function PANEL:OnRightClick()
end

function PANEL:OnMouseReleased(key)
    self:OnClick()

    if key == MOUSE_LEFT then
        self:OnLeftClick()
    elseif key == MOUSE_RIGHT then
        self:OnRightClick()
    end
end

---

local Style = GUI.Style:new()
local Blur = GUI.BlurBackground

Style:Add("normal", {
    Paint = function(self, width, height)
        surface.SetDrawColor(50, 50, 50, 100)
        surface.DrawRect(0, 0, width, height)

        draw.SimpleText(self.text or "", "DermaDefault", width / 2, height / 2, color_white, TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER)
    end
})

---

function PANEL:Think()
    Style:Think(self)
end

function PANEL:Paint(width, height)
    Style:Paint(self, width, height)
end

vgui.Register("stek_button", PANEL, "stek_base")
