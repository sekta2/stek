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
    local output_types = {
        ---@param ent ent_stek_craft_base
        ---@param worldpos Vector
        ---@param output CraftOutputDataResource
        ["resource"] = function(ent, worldpos, output)
            local max_amount = stek.Config.Get().resources.max_amount
            local ent_count = math.ceil(output.amount / max_amount)

            for i = 1, ent_count do
                local pos = worldpos + Vector(0, 0, 30 * (i - 1))
                local amount = (i == ent_count) and (output.amount - max_amount * (ent_count - 1)) or max_amount

                ---@type ent_stek_resource
                local resource_ent = ents.Create("ent_stek_res_" .. output.resource)
                resource_ent:SetPos(pos)
                resource_ent:SetAngles(ent:GetAngles())
                resource_ent:SetAmount(amount)

                resource_ent:Spawn()
            end
        end,

        ---@param ent ent_stek_craft_base
        ---@param worldpos Vector
        ---@param output CraftOutputDataEntity
        ["entity"] = function(ent, worldpos, output)

        end,

        ---@param ent ent_stek_craft_base
        ---@param worldpos Vector
        ---@param output CraftOutputDataProp
        ["prop"] = function(ent, worldpos, output)
            local prop = ents.Create("prop_physics")
            prop:SetModel(output.model)
            prop:SetPos(worldpos)

            prop:Spawn()
        end
    }

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

    ---@param recipe string
    function ENT:Craft(recipe)
        local recipe_obj = stek.Craft.GetByID(recipe)
        local world_pos = self:LocalToWorld(self.CraftPos)

        local output = recipe_obj.output
        if type(output) == "function" then
            output(self, world_pos)
        else
            local fn = output_types[output.type]

            ---@diagnostic disable-next-line param-type-mismatch
            fn(self, world_pos, output.data)
        end
    end
else
    function ENT:Draw()
        self:DrawModel()

        if GetConVar("developer"):GetBool() then
            local pos = self:LocalToWorld(self.CraftPos)

            debugoverlay.Axis(pos, self:GetAngles(), 5, 0)
            debugoverlay.Text(pos, "craft_pos", 0)
        end
    end

    function ENT:ClientUse()
        local craft_panel = stek.GUI.CreateCraftPanel()
        craft_panel:SetCraftTable(self.CraftTable)
        craft_panel:RebuildCategories()

        craft_panel:PopulateResources({})
        craft_panel:PopulateCrafts()
    end
end
