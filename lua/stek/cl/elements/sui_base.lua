local _NAME = "sui_base"
local _BASE = "EditablePanel"

--[[------------------------]]--

local PANEL = {}

PANEL._NAME = _NAME
PANEL._BASE = _BASE

--[[------------------------]]--

function PANEL:SetStyle(style)
    self._ui_style = style
end

function PANEL:GetStyle()
    return self._ui_style or GetConVar("stek_uistyle"):GetString()
end

--[[------------------------]]--

function PANEL:Paint(w, h)
    stek_gui.get_draw_call(self:GetStyle(), self._NAME, self, w, h)

    if GetConVar("stek_debug_ui"):GetBool() then
        surface.SetDrawColor(255, 0, 0, 255)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end
end

--[[------------------------]]--

vgui.Register(_NAME, PANEL, _BASE)