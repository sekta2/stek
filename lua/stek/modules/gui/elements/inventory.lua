local GUI = stek.GUI
local Resources = stek.Resources

---@class stek_inv: DFrame
local PANEL = {}

local color_bg_dark = Color(0, 0, 0, 100)
local color_bg_light = Color(0, 0, 0, 50)
local color_white_trans = Color(255, 255, 255, 150)
local color_white_full = Color(255, 255, 255, 255)
local color_hover = Color(61, 118, 192, 100)

function PANEL:Init()
    self:SetSize(800, 450)
    self:SetTitle("Inventory")
    self:MakePopup()
    self:Center()
    self:ShowCloseButton(true)
    self:SetDraggable(true)

    -- Attempt to get local inventory. Note: Networking must be implemented elsewhere to populate this on client.
    self.Inventory = LocalPlayer().stek_inventory or (stek.Inv and stek.Inv.Create(LocalPlayer()))

    -- Left Panel: Player Model
    local left_panel = vgui.Create("DPanel", self)
    left_panel:SetPos(20, 40)
    left_panel:SetSize(300, 390)
    left_panel.Paint = function(s, w, h)
        surface.SetDrawColor(color_bg_dark)
        surface.DrawRect(0, 0, w, h)
    end
    self.left_panel = left_panel

    self:InitPlayerModel(left_panel)

    -- Right Panel: Inventory Content
    local right_panel = vgui.Create("DPanel", self)
    right_panel:SetPos(340, 40)
    right_panel:SetSize(440, 390)
    right_panel.Paint = function(s, w, h)
        surface.SetDrawColor(color_bg_light)
        surface.DrawRect(0, 0, w, h)
    end
    self.right_panel = right_panel

    local scroll = vgui.Create("DScrollPanel", right_panel)
    scroll:Dock(FILL)
    scroll:DockMargin(10, 10, 10, 10)
    self.scroll = scroll

    self:UpdateInfo()
    self:PopulateInventory()
end

function PANEL:InitPlayerModel(parent)
    local model_panel = vgui.Create("DModelPanel", parent)
    model_panel:Dock(FILL)
    model_panel:SetModel(LocalPlayer():GetModel())

    local ply = LocalPlayer()
    local fake_ent = model_panel:GetEntity()

    if IsValid(fake_ent) then
        local mn, mx = fake_ent:GetRenderBounds()
        local size = 0
        size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
        size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
        size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

        model_panel:SetFOV(40)
        model_panel:SetCamPos(Vector(size, size, size * 0.5))
        model_panel:SetLookAt(Vector(0, 0, size * 0.5))

        fake_ent:SetSkin(ply:GetSkin())
        for _, g in pairs(ply:GetBodyGroups()) do
            fake_ent:SetBodygroup(g.id, ply:GetBodygroup(g.id))
        end

        if fake_ent.GetPlayerColor then
            fake_ent.GetPlayerColor = function() return Vector(GetConVarString("cl_playercolor")) end
        end
    end

    local drag_btn = vgui.Create("DButton", parent)
    drag_btn:Dock(FILL)
    drag_btn:SetText("")
    drag_btn.Paint = function() end
    drag_btn:SetCursor("sizewe")
    drag_btn:SetTooltip("Drag to rotate")

    local is_dragging = false
    local last_x = 0
    local ang = 0

    drag_btn.OnMousePressed = function()
        is_dragging = true
        last_x = gui.MouseX()
    end
    drag_btn.OnMouseReleased = function()
        is_dragging = false
    end
    drag_btn.OnCursorExited = function()
        if not input.IsMouseDown(MOUSE_LEFT) then is_dragging = false end
    end

    model_panel.LayoutEntity = function(s, ent)
        if is_dragging then
            local mx = gui.MouseX()
            ang = ang + (mx - last_x) * 0.5
            last_x = mx
        end
        ent:SetAngles(Angle(0, ang, 0))
    end
end

function PANEL:UpdateInfo()
    local inv = self.Inventory
    local vol = 0
    local max_vol = 100 -- Default

    if inv then
        if inv.GetVolume then vol = inv:GetVolume() end
        max_vol = inv.max_volume or 100
    end

    self:SetTitle("Inventory | Volume: " .. vol .. "/" .. max_vol)
end

function PANEL:PopulateInventory()
    self.scroll:Clear()

    local inv = self.Inventory
    if not (inv and inv.resources) then return end

    local layout = self.scroll:Add("DIconLayout")
    layout:Dock(FILL)
    layout:SetSpaceX(5)
    layout:SetSpaceY(5)

    -- Resources
    for res_id, amount in pairs(inv.resources) do
        local res = Resources.GetByID(res_id)
        if not res then continue end

        local pnl = layout:Add("DButton")
        pnl:SetSize(64, 64)
        pnl:SetText("")

        pnl.Paint = function(s, w, h)
            surface.SetDrawColor(color_bg_dark)
            surface.DrawRect(0, 0, w, h)

            if s:IsHovered() then
                surface.SetDrawColor(color_hover)
                surface.DrawOutlinedRect(0, 0, w, h, 2)
            end

            local icon = res:GetIcon()
            if icon then
                surface.SetDrawColor(255, 255, 255, 255)
                surface.SetMaterial(icon)
                surface.DrawTexturedRect(16, 5, 32, 32)
            end

            draw.SimpleText(amount .. " U", "DermaDefault", w / 2, h - 10, color_white_full, TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER)
        end

        local tooltip = res:GetName()
        if res.volume then
            tooltip = tooltip .. "\nVolume: " .. (res.volume * amount)
        end
        pnl:SetTooltip(tooltip)

        pnl.DoClick = function()
            local menu = DermaMenu()
            menu:AddOption("Drop", function()
                -- Placeholder for drop logic
            end)
            menu:Open()
        end
    end
end

function PANEL:Paint(w, h)
    GUI.BlurBackground(self)
end

vgui.Register("stek_inv", PANEL, "DFrame")
