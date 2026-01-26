local GUI = stek.GUI

---@class stek_base: EditablePanel
local PANEL = {}

function PANEL:SetText(text)
    self.text = text
end

function PANEL:GetText()
    return self.text
end

function PANEL:SetStyle(style)
    self.style = style
end

function PANEL:GetStyle()
    return self.style
end

---

function PANEL:Init()
    self.text = ""
    self.style = "normal"
end

vgui.Register("stek_base", PANEL, "EditablePanel")
