AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_pipe: Entity
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Category = "STek: Pipes"
ENT.Author = "sekta"
ENT.Spawnable = true

ENT.PhysicsSounds = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_c17/FurnitureWashingmachine001a.mdl")
        self:SetMaterial("phoenix_storms/dome")

        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetSolid(SOLID_VPHYSICS)

        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:PhysWake()
    end

    ---@param activator Player
    function ENT:Use(activator)
    end

    function ENT:OnRemove()
    end
else
    function ENT:Draw()
        self:DrawModel()

        cam.Start2D()
            local Dot = LocalPlayer():GetAimVector():Dot(self:GetRight())

            local mat = Dot > 0 and Material("icon16/door_out.png", "smooth") or Material("icon16/door_in.png", "smooth")

            local pos1 = self:LocalToWorld(Vector(14, 0, 0))
            local screen_pos1 = pos1:ToScreen()
            screen_pos1.x = math.floor(screen_pos1.x)
            screen_pos1.y = math.floor(screen_pos1.y)

            local pos2 = self:LocalToWorld(Vector(-14, 0, 0))
            local screen_pos2 = pos2:ToScreen()
            screen_pos2.x = math.floor(screen_pos2.x)
            screen_pos2.y = math.floor(screen_pos2.y)

            local pos3 = self:GetPos()
            local screen_pos3 = pos3:ToScreen()
            screen_pos3.x = math.floor(screen_pos3.x)
            screen_pos3.y = math.floor(screen_pos3.y)

            local real_dist = pos1:Distance(pos2) * 5
            local screen_dist = Vector(screen_pos1.x, screen_pos1.y):Distance(Vector(screen_pos2.x, screen_pos2.y))

            local dist = math.max(real_dist, screen_dist)
            local center_to_ent_dist = Vector(ScrW() / 2, ScrH() / 2):Distance(Vector(screen_pos3.x, screen_pos3.y))

            local selected = -1

            if center_to_ent_dist <= dist then
                surface.DrawCircle(screen_pos3.x, screen_pos3.y, dist, 255, 255, 255)

                local cursor_to_one = Vector(ScrW() / 2, ScrH() / 2):Distance(Vector(screen_pos1.x, screen_pos1.y))
                local cursor_to_two = Vector(ScrW() / 2, ScrH() / 2):Distance(Vector(screen_pos2.x, screen_pos2.y))

                if cursor_to_one < cursor_to_two then
                    selected = 1
                else
                    selected = 2
                end
            end

            draw.RoundedBox(4, screen_pos1.x - 15, screen_pos1.y - 15, 30, 30, Color(255, 255, 255, 100))
            
            surface.SetMaterial(mat)
            surface.SetDrawColor(selected == 1 and Color(255, 0, 0) or color_white)
            surface.DrawTexturedRect(screen_pos1.x - 10, screen_pos1.y - 10, 20, 20)

            draw.RoundedBox(4, screen_pos2.x - 15, screen_pos2.y - 15, 30, 30, Color(255, 255, 255, 100))

            surface.SetMaterial(mat)
            surface.SetDrawColor(selected == 2 and Color(255, 0, 0) or color_white)
            surface.DrawTexturedRect(screen_pos2.x - 10, screen_pos2.y - 10, 20, 20)
        cam.End2D()
    end
end