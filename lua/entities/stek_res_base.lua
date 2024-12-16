--[[
    База для ресурсов

    Если в ресурсе(resources/sh.lua) прописано auto_entity = false, тогда
    вам нужно создать энтити для ресурса с класснеймом stek_res_(айди ресурса):

    AddCSLuaFile()

    ENT.Type = "anim"
    ENT.Base = "stek_res_base"

    ENT.PrintName = "название ресурса"
    ENT.Category = "STek - Resources"

    -- Моделька
    ENT.Model = "тут_моделька_энтити"

    -- Материал модельки
    ENT.Material = ""

    -- Масса энтити
    ENT.Mass = 50

    -- Цвет модельки
    ENT.Color = Color(255, 255, 255)

    -- Скин модельки
    ENT.Skin = 0

    -- Иконка энтити ресурса в спавнменю
    ENT.IconOverride = "stek_resources/название_ресурса.png"

    
    !!! Этот способ создания энтити для ресурса еще не тестировался! Прошу контрибьютеров протестить !!!
]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.IsStekResource = true

ENT.Spawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Amount")

    if SERVER then
        self:SetAmount(STEK_RESOURCES_DEFAULT or 100)
    end
end

if SERVER then
    function ENT:Initialize()
        if SERVER then self.act_cd = CurTime() + 1 end

        self:SetModel(self.Model)

        if self.Material then
            self:SetMaterial(self.Material)
        end

        if self.Color then
            self:SetColor(self.Color)
        end

        if self.Skin then
            self:SetSkin(self.Skin)
        end

        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

        if SERVER then
            self:PhysicsInit(SOLID_VPHYSICS)
            self:SetUseType(SIMPLE_USE)

            local phys = self:GetPhysicsObject()

            if IsValid(phys) then
                phys:Wake()

                if self.Mass then
                    phys:SetMass(self.Mass)
                end
            end
        end
    end

    function ENT:PhysicsCollide(col_data, collider)
        if (col_data.Speed > 80) and self and self.ImpactSounds then
            local snd = self.ImpactSounds[math.random(1, #self.ImpactSounds)]
            self:EmitSound(snd)
        end

        local ent = col_data.HitEntity

        if IsValid(ent) and ent.IsStekResource and self.StekResUID == ent.StekResUID and
        not self.Transfering and not ent.Transfering and CurTime() >= self.act_cd and CurTime() >= ent.act_cd then

            local self_am, ent_am = self:GetAmount(), ent:GetAmount()
            local amount = self_am + ent_am

            if amount <= (STEK_RESOURCES_DEFAULT or 100) then
                self.Transfering = true
                ent.Transfering = true

                local winner = self_am > ent_am and self or ent
                local looser = self_am > ent_am and ent or self

                winner:SetAmount(amount)
                looser:Remove()

                winner.Transfering = false
            end
        end
    end

    function ENT:Use(ply)
        if self.Transfering then return end

        if ply:KeyDown(IN_WALK) and ply:KeyDown(IN_SPEED) then
            local self_amount = self:GetAmount()
            if self_amount <= 1 then return end

            local amount = math.floor(self_amount * 0.5)

            self.Transfering = true

            local ent = ents.Create(self.StekResLink.classname)
            ent:SetPos(self:GetPos())
            ent:SetAngles(self:GetAngles())

            ent.Transfering = true

            ent:Spawn()

            ent:SetAmount(amount)
            self:SetAmount(self_amount - amount)

            ply:PickupObject(ent)

            self.Transfering = false
            ent.Transfering = false
        elseif ply:KeyDown(IN_WALK) then
            self:TakeResource(ply, self:GetAmount())
        else
            ply:PickupObject(self)
        end
    end

    function ENT:TakeResource(ply, amount)
        local inv = ply:GetInventory()
        if not inv then return end

        local allowed = inv:AddResource(self.StekResID, amount, self)

        if not allowed or allowed <= 0 then return end

        self:SetAmount(self:GetAmount() - allowed)

        if self:GetAmount() <= 0 then
            self:Remove()
        end

        return true
    end
else
    function ENT:Draw()
        self:DrawModel()

        s_res.holo(self, self.HoloVec, self.HoloAng, self.HoloSize, 300, function()
            s_res.resource_display(self.StekResID, self:GetAmount(), _, 0, 0, 200, self.HoloVertical)
        end)
    end
end