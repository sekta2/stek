---@class GUIModule
local GUI = {}

local blur_material = Material("pp/blurscreen")

---Делает размытие на фоне панельки
---@param Panel Panel
function GUI.BlurBackground(Panel)
    if not (IsValid(Panel) and Panel:IsVisible()) then return end

    local layers, density, alpha = 1, 1, 255
    local x, y = Panel:LocalToScreen(0, 0)
    local Num, Dark = 5, 150

    local width, height = Panel:GetSize()

    surface.SetDrawColor(255, 255, 255, alpha)
    surface.SetMaterial(blur_material)

    for i = 1, Num do
        blur_material:SetFloat("$blur", (i / layers) * density)
        blur_material:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
    end

    surface.SetDrawColor(0, 0, 0, Dark)
    surface.DrawRect(0, 0, width, height)
end

---

local function methodMaker(method_name)
    return function(self, panel, ...)
        local style_tbl = self.list[panel.style]
        if not style_tbl then return end

        local fn = style_tbl[method_name]
        if not fn then return end

        fn(panel, ...)
    end
end

---Класс стиля для элементов
---@class GUI_Style
---@field list table<any, table>
local Style = {}
Style.__index = Style

function Style:new()
    local object = {
        list = {}
    }

    return setmetatable(object, self)
end

function Style:Add(name, tbl)
    self.list[name] = tbl
end

Style.Think = methodMaker("Think")
Style.Paint = methodMaker("Paint")

GUI.Style = Style

---

---@return stek_button
function GUI.CreateButton(text, x, y, width, height, style, parent)
    local Button = vgui.Create("stek_button", parent)
    Button:SetText(text)
    Button:SetSize(width, height)
    Button:SetPos(x, y)
    if style then Button:SetStyle(style) end

    return Button
end

---@return stek_inv
function GUI.CreateInventory()
    return vgui.Create("stek_inv")
end

---

stek.GUI = GUI

--- Load elements

local elements, _ = file.Find("stek/modules/gui/elements/*.lua", "LUA")

for i = 1, #elements do
    local filename = elements[i]
    stek.client("elements/" .. filename)
end

stek.client("dev.lua")
