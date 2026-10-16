AddCSLuaFile()

---@diagnostic disable: assign-type-mismatch
---@class ent_stek_resource_storage: Entity
---@field Model string? Путь к модели энтити
---@field Material string? Путь к материалу энтити
---@field Color Color? Цвет энтити
---@field Mass number? Масса энтити
---@field Mode 1|2 Тип контейнера (1 - один тип ресурса, 2 - множество типов ресурса)
---@field AfterInit fun(self: ent_stek_resource_storage)? Кастомная функция инициализации
---@field CurrentResource string?
---@field ResourceStorage table<string, number?>
---@field StorageCapacity number
---@field StorageAmount number
---@field AmountMass number
ENT = ENT

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Author = "sekta"

ENT.PhysicsSounds = true

---@return number
function ENT:GetAmount()
    return self.StorageAmount
end

---@param id string
---@return number?
function ENT:GetResource(id)
    return self.ResourceStorage[id]
end

if SERVER then
    util.AddNetworkString("stek.CrateSync")

    function ENT:Initialize()
        self.ResourceStorage = {}
        self.StorageAmount = 0

        if self.Model then
            self:SetModel(self.Model)
        end

        if self.Material then
            self:SetMaterial(self.Material)
        end

        if self.Color then
            self:SetColor(self.Color)
        end

        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetSolid(SOLID_VPHYSICS)

        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            if self.Mass then
                phys:SetMass(self.Mass)
            end

            phys:Wake()
        end

        if self.AfterInit then
            self.AfterInit(self)
        end
    end

    ---@param ent ent_stek_resource
    function ENT:Touch(ent)
        if not (IsValid(ent) and ent.STek_Resource and not ent.MergeLock) then return end
        if (CurTime() - ent.SpawnTime) < 2 then return end

        if self.Mode == 1 then
            if not self.CurrentResource then
                self.CurrentResource = ent.STek_Resource
            end

            if ent.STek_Resource ~= self.CurrentResource then return end
        end

        ent.MergeLock = true

        local success, real_amount = self:AddResource(ent.STek_Resource, ent:GetAmount())
        if success then
            local amount_left = ent:GetAmount() - real_amount
            if amount_left == 0 then
                ent:Remove()
                return
            end

            ent:SetAmount(amount_left)
            ent.MergeLock = false
        end
    end

    ---@param ply Player
    function ENT:Use(ply)
        if self.Mode ~= 1 then return end
        if self.StorageAmount <= 0 then return end

        ---@type number
        local max_amount = stek.Config.get().resources.max_amount

        local success, real_amount = self:SubResource(self.CurrentResource, max_amount, true)
        if success and real_amount then
            ---@type ent_stek_resource
            local resource_entity = ents.Create("ent_stek_res_" .. self.CurrentResource)
            resource_entity:SetAmount(real_amount)
            resource_entity:SetPos(self:GetPos())

            resource_entity:Spawn()
            ply:PickupObject(resource_entity)

            if self.StorageAmount <= 0 then
                self.CurrentResource = nil
            end

            self:Sync()
        end
    end

    function ENT:CalcWeight()
		local Frac = self:GetAmount() / self.StorageCapacity
		self:GetPhysicsObject():SetMass(self.Mass + Frac * self.AmountMass)
		self:GetPhysicsObject():Wake()
	end

    ---@param id string
    ---@param amount number
    ---@param do_not_sync boolean?
    ---@return boolean
    ---@return number?
    function ENT:AddResource(id, amount, do_not_sync)
        local current_amount = self.StorageAmount
        local new_amount = math.Clamp(self.StorageAmount + amount, 0, self.StorageCapacity)
        local real_amount = math.abs(new_amount - current_amount)

        if real_amount >= 1 then
            self.ResourceStorage[id] = (self.ResourceStorage[id] or 0) + real_amount
            self.StorageAmount = new_amount

            self:CalcWeight()
            if not do_not_sync then
                self:Sync()
            end

            return true, real_amount
        end

        return false
    end

    ---@param id string
    ---@param amount number
    ---@param do_not_sync boolean?
    ---@return boolean
    ---@return number?
    function ENT:SubResource(id, amount, do_not_sync)
        amount = math.Clamp(amount, 0, (self.ResourceStorage[id] or 0))

        local current_amount = self.StorageAmount
        local new_amount = math.Clamp(self.StorageAmount - amount, 0, self.StorageCapacity)
        local real_amount = math.abs(new_amount - current_amount)

        if real_amount >= 1 then
            self.ResourceStorage[id] = (self.ResourceStorage[id] or 0) - real_amount
            self.StorageAmount = new_amount

            self:CalcWeight()
            if not do_not_sync then
                self:Sync()
            end

            return true, real_amount
        end

        return false
    end

    function ENT:Sync()
        local bits_uid = stek.Resources.bits_count
        local bits_amount = stek.BitsForUnsignedInt(self.StorageCapacity)

        local entries = {}
        for id, amount in pairs(self.ResourceStorage) do
            if amount and amount > 0 then
                entries[#entries + 1] = { uid = stek.Resources.getByID(id).uid, amount = amount }
            end
        end

        net.Start("stek.CrateSync")
        net.WriteEntity(self)
        net.WriteUInt(#entries, bits_uid)

        for _, e in ipairs(entries) do
            net.WriteUInt(e.uid, bits_uid)
            net.WriteUInt(e.amount, bits_amount)
        end

        net.Broadcast()
    end
else
    function ENT:Initialize()
        self.ResourceStorage = {}
        self.StorageAmount = 0
    end

    function ENT:Draw()
        self:DrawModel()
    end

    net.Receive("stek.CrateSync", function()
        ---@type ent_stek_resource_storage?
        local crate = net.ReadEntity()
        if not (crate and IsValid(crate)) then return end

        local bits_uid = stek.Resources.bits_count
        local bits_amount = stek.BitsForUnsignedInt(crate.StorageCapacity)

        local storage = {}
        local total = 0

        for i = 1, net.ReadUInt(bits_uid) do
            local uid = net.ReadUInt(bits_uid)
            local amount = net.ReadUInt(bits_amount)

            storage[stek.Resources.getByUID(uid).id] = amount
            total = total + amount
        end

        crate.CurrentResource = next(storage)

        crate.ResourceStorage = storage
        crate.StorageAmount = total
    end)
end
