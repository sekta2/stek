-- THIS IS SHARED SCRIPT

local SERVER = SERVER

local elements = file.Find("stek/cl/elements/*.lua", "LUA")

for i = 1, #elements do
    local filename = elements[i]
    local path = "elements/" .. filename

    if SERVER then AddCSLuaFile(path) continue end
    include(path)
end

if SERVER then return end -- clean code

stek_gui = {
    draw_calls = {}
}

CreateClientConVar("stek_uistyle", "dark", true)
CreateClientConVar("stek_debug_ui", "0", true)

local blur_mat, blur_dark = Material("pp/blurscreen"), Color(0, 0, 0, 150)
function stek_gui.blur(panel, blur_level, w, h)
    local x, y = panel:LocalToScreen(0, 0)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(blur_mat)

    for i = 1, blur_level do
        blur_mat:SetFloat("$blur", i)
        blur_mat:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
    end

    surface.SetDrawColor(blur_dark)
    surface.DrawRect(0, 0, w or panel:GetWide(), h or panel:GetTall())
end

function stek_gui.add_draw_call(style, element, callback)
    local dc = stek_gui.draw_calls

    if not dc[style] then dc[style] = {} end

    local sc = dc[style]
    sc[element] = callback
end

function stek_gui.get_draw_call(style, element, pnl, w, h)
    local dc = stek_gui.draw_calls

    if not dc[style] then return end

    local sc = dc[style]
    local callback = sc[element]

    if not callback then return end

    callback(pnl, w, h)
end

concommand.Add("sui_testgui", function()
    if IsValid(PANELTEST) then PANELTEST:Remove() end

    PANELTEST = vgui.Create("sui_frame")
    PANELTEST:SetSize(800, 600)
    PANELTEST:Center()
end)

--[[------------------------]]--

-- sui_frame: dark
stek_gui.add_draw_call("dark", "sui_frame", function(pnl, w, h)
    draw.RoundedBox(6, 0, 0, w, h, Color(10, 10, 10, 255))
    draw.RoundedBox(6, 1, 1, w - 2, h - 2, Color(30, 30, 30, 255))
end)

-- sui_frame: blur
stek_gui.add_draw_call("blur", "sui_frame", function(pnl, w, h)
    stek_gui.blur(pnl, 5, w, h)
end)