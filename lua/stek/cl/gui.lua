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
    draw.SimpleText("wata//", "Default", 0, 0, color_white)
end)