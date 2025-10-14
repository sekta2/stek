local GUI = stek.GUI

---@class stek_inv: DFrame
local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()

    self:SetSize(800, 400)
	self:SetDraggable(true)
	self:ShowCloseButton(true)
    self:SetTitle("Inventory | Current Inventory Weight: " .. "?" .. "kg. | Current Inventory Volume: " .. "?" .. "/" .. "?")

    self:MakePopup()
	self:Center()

    ---

    local PDispBG = vgui.Create("DPanel", self)
	PDispBG:SetPos(200, 30)
	PDispBG:SetSize(200, 360)

	function PDispBG:Paint(w, h)
		surface.SetDrawColor(50, 50, 50, 100)
		surface.DrawRect(0, 0, w, h)
	end

	local PlayerDisplay = vgui.Create("DModelPanel", PDispBG)
	PlayerDisplay:SetPos(0, 0)
	PlayerDisplay:SetSize(PDispBG:GetWide(), PDispBG:GetTall())
	PlayerDisplay:SetModel(ply:GetModel() or "models/player.mdl")

	local FakePly = PlayerDisplay:GetEntity()
	PlayerDisplay:SetLookAt(FakePly:GetBonePosition(0))
	PlayerDisplay:SetFOV(37)
	PlayerDisplay:SetCursor("arrow")
	self.PlayerDisplay = PlayerDisplay
	FakePly:SetLOD(0)

	local PDispBT = vgui.Create("DButton", self)
	PDispBT:SetPos(200, 30)
	PDispBT:SetSize(200, 360)
	PDispBT:SetText("")
	PDispBT:SetCursor("sizewe")
	PDispBT:SetTooltip("You can drag the model to rotate it.")

	function PDispBT:Paint(w, h)
		surface.SetDrawColor(0, 0, 0, 0)
		surface.DrawRect(0, 0, w, h)
	end

    local entAngs = nil
	local curDif = nil
	local lastCurPos = input.GetCursorPos()
	local doneOnce = false

	function PlayerDisplay:LayoutEntity(ent)

		if not PDispBT:IsDown() then
			entAngs = ent:GetAngles()
			doneOnce = false
		else
			if not doneOnce then
				lastCurPos = input.GetCursorPos()
				doneOnce = true
			end

			curDif = input.GetCursorPos() - lastCurPos

			ent:SetAngles( Angle( 0, entAngs.y + curDif % 360, 0 ) )
		end
	end

	FakePly:SetSkin(ply:GetSkin())

	for k, v in pairs( ply:GetBodyGroups() ) do
		local cur_bgid = ply:GetBodygroup( v.id )
		FakePly:SetBodygroup( v.id, cur_bgid )
	end
	FakePly.GetPlayerColor = function() return Vector( GetConVarString( "cl_playercolor" ) ) end

    ---

    local commands = {
        "bombdrop",
        "launch",
        "trigger",
        "scrounge",
        "grab",
        "handcraft",
        "config"
    }

	for i = 1, #commands do
        local cmd = commands[i]
        GUI.CreateButton(i .. ": " .. cmd, 600, 30 + ((i - 1) * 25), 180, 20, _, self)
	end
end

---

function PANEL:Paint(width, height)
    GUI.BlurBackground(self)
end

vgui.Register("stek_inv", PANEL, "DFrame")