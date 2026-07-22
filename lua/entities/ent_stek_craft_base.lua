AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_craft_base: Entity
---@field Model string
---@field CraftTable string
---@field CraftPos Vector
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Author = "sekta"

ENT.PhysicsSounds = true

-- ENT.CraftTable = "workbench"
-- ENT.CraftPos = Vector(5, 0, 10)
-- ENT.Model = "models/hunter/blocks/cube1x2x1.mdl"

if SERVER then
    function ENT:Initialize()
        if self.Model then
            self:SetModel(self.Model)
        end

        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetSolid(SOLID_VPHYSICS)

        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:PhysWake()
    end
else
    function ENT:Draw()
        self:DrawModel()
    end

    function ENT:ClientUse()
        local craft_panel = stek.GUI.CreateCraftPanel()
        craft_panel:SetCraftTable(self.CraftTable)
        craft_panel:RebuildCategories()

        craft_panel:PopulateResources({})
        craft_panel:PopulateCrafts()
    end
end
