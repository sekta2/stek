AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_pipe: Entity
---@field ConnectorPlug ent_stek_plug
---@field PipeIN ent_stek_pipe|nil Входная труба
---@field PipeOUT ent_stek_pipe[] Выходные трубы
---@field ResourceQueue Resource[] Очередь ресурсов
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Category = "STek: Pipes"
ENT.Author = "sekta"
ENT.Spawnable = true

ENT.PhysicsSounds = true

if SERVER then
    function ENT:Initialize()
        self.PipeIN = nil
        self.PipeOUT = {}
        self.ResourceQueue = {}
        self.IsProcessingQueue = false

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
        if not activator:KeyDown(IN_WALK) then return end

        local connector = self.ConnectorPlug
        if connector and IsValid(connector) then
            connector:SetPos(activator:GetEyeTraceNoCursor().HitPos)
            activator:PickupObject(connector)

            return
        end

        local plug = stek.MakeConnector(self, activator:GetEyeTraceNoCursor().HitPos)
        plug.TouchCallback = function(_, TouchEntity, Plug)
            if not (TouchEntity:GetClass() == "ent_stek_pipe" and IsValid(TouchEntity) and TouchEntity ~= self) then return end

            ---@type ent_stek_pipe
            local targetPipe = TouchEntity

            if self:IsAncestor(targetPipe) or targetPipe:IsAncestor(self) then
                Plug:Remove()
                return
            end

            if table.Count(self.PipeOUT) >= 2 then
                Plug:Remove()
                return
            end

            if targetPipe.PipeIN ~= nil and IsValid(targetPipe.PipeIN) then
                Plug:Remove()
                return
            end

            Plug:Remove()

            timer.Simple(0, function()
                local constr, rope = constraint.Rope(
                    self, -- Entity 1
                    targetPipe, -- Entity 2
                    0, -- Bone 1
                    0, -- Bone 2
                    vector_origin, -- LocalPos 1
                    vector_origin, -- LocalPos 2
                    500, -- Length
                    0, -- Add length
                    2500, -- Force Limit
                    15, -- Width
                    "cable/cable2" -- Material
                )
                self.PipeOUT[#self.PipeOUT + 1] = targetPipe
                targetPipe.PipeIN = self
            end)
        end

        activator:DropObject()
        activator:PickupObject(plug)

        self.ConnectorPlug = plug
    end

    function ENT:StartTouch(entity)
        if not IsValid(entity) or not entity.STek_Resource then return end
        if self.PipeIN ~= nil and IsValid(self.PipeIN) then return end

        local resource_data = stek.Resources.GetByID(entity.STek_Resource)
        if resource_data then
            self:GiveResource(resource_data)
            entity:Remove()
        end
    end

    function ENT:IsAncestor(potentialAncestor, visited)
        visited = visited or {}
        if visited[self:EntIndex()] then return false end
        visited[self:EntIndex()] = true

        if self == potentialAncestor then return true end

        if self.PipeIN and IsValid(self.PipeIN) then
            return self.PipeIN:IsAncestor(potentialAncestor, visited)
        end

        return false
    end

    function ENT:OnRemove()
        if IsValid(self.PipeIN) then
            local indexToRemove = -1
            for i, pipe in pairs(self.PipeIN.PipeOUT) do
                if pipe == self then
                    indexToRemove = i
                    break
                end
            end
            if indexToRemove ~= -1 then
                table.remove(self.PipeIN.PipeOUT, indexToRemove)
            end
        end

        for _, pipe in pairs(self.PipeOUT) do
            if IsValid(pipe) then
                pipe.PipeIN = nil
            end
        end
    end

    function ENT:GiveResource(resource)
        if not resource then return end

        table.insert(self.ResourceQueue, resource)
        if not self.IsProcessingQueue then
            self:ProcessResourceQueue()
        end
    end

    function ENT:ProcessResourceQueue()
        if self.IsProcessingQueue then return end

        if #self.ResourceQueue == 0 then
            self.IsProcessingQueue = false
            return
        end

        self.IsProcessingQueue = true
        local resource = table.remove(self.ResourceQueue, 1)

        timer.Simple(2, function()
            if not IsValid(self) then return end

            if #self.PipeOUT == 0 then
                local resource_ent = ents.Create("ent_stek_res_" .. resource.id)
                resource_ent:SetPos(self:GetPos() + self:GetForward() * 50)
                resource_ent:Spawn()
                resource_ent:Activate()
                self:EmitSound("snds_jack_gmod/hiss.ogg", 65, math.random(80, 120))
                self:EmitSound("Metal_Box.ImpactSoft")
            else
                self:EmitSound("snds_jack_gmod/hiss.ogg", 65, math.random(80, 120))
                self:EmitSound("Metal_Box.ImpactSoft")
                for _, pipe in pairs(self.PipeOUT) do
                    if IsValid(pipe) then
                        pipe:GiveResource(resource)
                    end
                end
            end

            self.IsProcessingQueue = false
            if #self.ResourceQueue > 0 then
                self:ProcessResourceQueue()
            end
        end)
    end
else
    function ENT:Draw()
        self:DrawModel()
    end
end