---@diagnostic disable inject-field

local GUI = stek.GUI

---@class stek_craft: DFrame
local PANEL = {}

local color_white_trans = Color(255, 255, 255, 100)
local color_white_full = Color(255, 255, 255, 255)
local color_hover = Color(50, 50, 50, 60)
local color_normal = Color(30, 30, 30, 60)
local color_bg_dark = Color(0, 0, 0, 100)
local color_bg_light = Color(0, 0, 0, 50)

function PANEL:Init()
    self:SetSize(1100, 500)
    self:SetTitle("Craft Panel")
    self:MakePopup()
    self:Center()
    self:ShowCloseButton(true)
    self:SetDraggable(true)

    surface.PlaySound("snds_jack_gmod/ez_gui/menu_open.ogg")

    local container = vgui.Create("DPanel", self)
    container:Dock(FILL)
    container.Paint = nil

    local left_panel = vgui.Create("DPanel", container)
    left_panel:Dock(LEFT)
    left_panel:SetWide(200)
    left_panel:DockMargin(0, 0, 5, 0)
    left_panel.Paint = function(s, w, h)
        surface.SetDrawColor(color_bg_light)
        surface.DrawRect(0, 0, w, h)
    end
    self.left_panel = left_panel

    local resources_scroll = vgui.Create("DScrollPanel", left_panel)
    resources_scroll:Dock(FILL)
    resources_scroll:DockMargin(5, 5, 5, 5)
    self.resources_scroll = resources_scroll

    local right_panel = vgui.Create("DPanel", container)
    right_panel:Dock(FILL)
    right_panel.Paint = function(s, w, h)
        surface.SetDrawColor(color_bg_light)
        surface.DrawRect(0, 0, w, h)
    end
    self.right_panel = right_panel

    local right_panel_container = vgui.Create("DPanel", right_panel)
    right_panel_container:Dock(FILL)
    right_panel_container:DockMargin(10, 10, 10, 10)
    right_panel_container.Paint = nil

    local tabs_panel = vgui.Create("DPanel", right_panel_container)
    tabs_panel:Dock(TOP)
    tabs_panel:SetHeight(24)
    tabs_panel.Paint = nil

    local categories = {}
    for i = 1, #stek.Craft.list do
        local craft = stek.Craft.list[i]
        if not categories[craft.category] then
            categories[craft.category] = {}
        end

        table.insert(categories[craft.category], craft)
    end
    self.categories = categories

    local categories_names = table.GetKeys(categories)
    table.sort(categories_names, function(a, b) return a < b end)
    self.default_category = categories_names[1]

    for i = 1, #categories_names do
        local name = categories_names[i]

        local tab_button = vgui.Create("DButton", tabs_panel)
        tab_button:Dock(LEFT)
        tab_button.tab_text = name

        surface.SetFont("DermaDefault")
        local text_w, text_h = surface.GetTextSize(name)

        tab_button:SetWide(text_w + 10)
        tab_button:SetText("")
        tab_button.Paint = function(s, w, h)
            surface.SetDrawColor(color_bg_light)
            surface.DrawRect(0, 0, w, h)

            draw.SimpleText(s.tab_text, "DermaDefault", w / 2, h / 2, color_white_full, TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER)
        end

        tab_button.DoClick = function(s)
            surface.PlaySound("snds_jack_gmod/ez_gui/click_smol.ogg")
            self:PopulateCrafts()
        end
    end

    local active_tab = vgui.Create("DPanel", right_panel_container)
    active_tab:Dock(FILL)
    active_tab.Paint = function(s, w, h)
        surface.SetDrawColor(color_bg_light)
        surface.DrawRect(0, 0, w, h)
    end
    self.active_tab = active_tab

    local crafts_scroll = vgui.Create("DScrollPanel", active_tab)
    crafts_scroll:Dock(FILL)
    crafts_scroll:DockMargin(5, 5, 5, 5)
    self.crafts_scroll = crafts_scroll

    -- Pass empty table initially, waiting for data sync logic elsewhere if needed
    self:PopulateResources({})
    self:PopulateCrafts()
end

function PANEL:OnClose()
    surface.PlaySound("snds_jack_gmod/ez_gui/menu_close.ogg")
end

function PANEL:Paint(w, h)
    GUI.BlurBackground(self)
end

function PANEL:PopulateResources(resource_table)
    self.resources_scroll:Clear()

    for res_id, amount in pairs(resource_table) do
        local res = stek.Resources.GetByID(res_id)
        if not res then continue end

        local panel = self.resources_scroll:Add("DPanel")
        panel:SetTall(40)
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 5)

        panel.Paint = function(s, w, h)
            surface.SetDrawColor(color_bg_dark)
            surface.DrawRect(0, 0, w, h)

            local icon = res:GetIcon()
            if icon then
                surface.SetDrawColor(255, 255, 255, 200)
                surface.SetMaterial(icon)
                surface.DrawTexturedRect(5, 4, 32, 32)
            end

            draw.SimpleText(res:GetName(), "DermaDefault", 45, h / 2, color_white_full, TEXT_ALIGN_LEFT,
                TEXT_ALIGN_CENTER)
            draw.SimpleText("x" .. amount, "DermaDefault", w - 10, h / 2, color_white_trans, TEXT_ALIGN_RIGHT,
                TEXT_ALIGN_CENTER)
        end
    end
end

function PANEL:PopulateCrafts(category)
    category = category or self.default_category

    self.crafts_scroll:Clear()
    if not (stek.Craft and stek.Craft.list) then return end

    local items = self.categories[category]

    for i = 1, #items do
        ---@type Craft
        local craft = items[i]

        local btn = self.crafts_scroll:Add("DButton")
        btn:SetText("")
        btn:SetTall(42)
        btn:Dock(TOP)
        btn:DockMargin(0, 0, 0, 5)

        local icon = craft:GetIcon()

        local desc = craft:GetDescription() or ""
        desc = desc .. "\n\nRequirements:"

        for res_id, amount in pairs(craft.resources) do
            local res = stek.Resources.GetByID(res_id)
            local name = res and res:GetName() or res_id
            desc = desc .. "\n" .. name .. ": x" .. amount
        end

        btn:SetTooltip(desc)

        btn.Paint = function(s, w, h)
            local hovered = s:IsHovered()
            local col = hovered and 50 or 30

            surface.SetDrawColor(col, col, col, 60)
            surface.DrawRect(0, 0, w, h)

            local text_offset = 5

            if icon then
                surface.SetDrawColor(255, 255, 255, 255)
                surface.SetMaterial(icon)
                surface.DrawTexturedRect(5, 5, 32, 32)
                text_offset = 47
            end

            draw.SimpleText(craft:GetName(), "DermaDefault", text_offset, 15,
                hovered and color_white_full or color_white_trans, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            local rx = w - 10

            for res_id, amount in pairs(craft.resources) do
                local res = stek.Resources.GetByID(res_id)
                local txt = "x" .. amount

                surface.SetFont("DermaDefault")
                local tw, th = surface.GetTextSize(txt)

                draw.SimpleText(txt, "DermaDefault", rx - tw, 15, color_white_trans, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                rx = rx - (tw + 5)

                if res then
                    local res_icon = res:GetIcon()
                    if res_icon then
                        surface.SetDrawColor(255, 255, 255, 150)
                        surface.SetMaterial(res_icon)
                        surface.DrawTexturedRect(rx - 32, 5, 32, 32)
                        rx = rx - 35
                    end
                end
            end
        end

        btn.DoClick = function()
            surface.PlaySound("garrysmod/ui_click.wav")
            print("Crafting: " .. craft.id)
        end
    end
end

vgui.Register("stek_craft", PANEL, "DFrame")
