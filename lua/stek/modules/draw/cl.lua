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
---@param siz number
function Draw.ResourceInfoHorizontal(res_id, amount, x, y, siz)
    local res = stek.Resources.GetByID(res_id)
    local font = "JMod-Stencil"
    local icon = res:GetIcon()

    if icon then
        SetMaterial(icon)
    end

    SetDrawColor(COLOR_MAIN)

    DrawTexturedRect(x - siz * 0.5, y - siz * 0.5, siz, siz)

    local textAmt = amount .. " UNITS"

    SimpleText(res:GetName(), font, x - siz * 0.5, y, COLOR_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    SimpleText(textAmt, font, x + siz * 0.5, y, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function Draw.ResourceInfoVertical(res_id, amount, x, y, siz)
    local res = stek.Resources.GetByID(res_id)
    local font = "JMod-Stencil"
    local icon = res:GetIcon()

    if icon then
        SetMaterial(icon)
    end

    SetDrawColor(COLOR_MAIN)

    DrawTexturedRect(x - siz * 0.5, y - siz * 0.5, siz, siz)

    local textAmt = amount .. " UNITS"

    SimpleText(res:GetName(), font, x, y - siz * 0.5, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    SimpleText(textAmt, font, x, y - siz * 0.5 + siz, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

stek.Draw = Draw
