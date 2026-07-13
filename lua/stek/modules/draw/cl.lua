local Draw = {}

local SetDrawColor = surface.SetDrawColor
local SetMaterial = surface.SetMaterial
local DrawTexturedRect = surface.DrawTexturedRect
local SimpleText = draw.SimpleText

local COLOR_MAIN = Color(255, 255, 255, 159)
local COLOR_WHITE = Color(255, 255, 255, 159)

---@param res_id string
---@param amount number
---@param x number
---@param y number
---@param size number
---@param text_color Color?
function Draw.ResourceInfoHorizontal(res_id, amount, x, y, size, text_color)
    text_color = text_color or COLOR_WHITE

    local res = stek.Resources.GetByID(res_id)
    local font = "STek-Stencil"
    local icon = res:GetIcon()

    if icon then
        SetMaterial(icon)
    end

    SetDrawColor(COLOR_MAIN)
    DrawTexturedRect(x - size * 0.5, y - size * 0.5, size, size)

    local textAmt = amount .. " UNITS"

    SimpleText(res:GetName(), font, x - size * 0.5 - 5, y, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    SimpleText(textAmt, font, x + size * 0.5 + 5, y, text_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

---@param res_id string
---@param amount number
---@param x number
---@param y number
---@param size number
---@param text_color Color?
function Draw.ResourceInfoVertical(res_id, amount, x, y, size, text_color)
    text_color = text_color or COLOR_WHITE

    local res = stek.Resources.GetByID(res_id)
    local font = "STek-Stencil"
    local icon = res:GetIcon()

    if icon then
        SetMaterial(icon)
    end

    SetDrawColor(COLOR_MAIN)

    DrawTexturedRect(x - size * 0.5, y - size * 0.5, size, size)

    local textAmt = amount .. " UNITS"

    SimpleText(res:GetName(), font, x, y - size * 0.5, text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    SimpleText(textAmt, font, x, y - size * 0.5 + size, text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

stek.Draw = Draw
