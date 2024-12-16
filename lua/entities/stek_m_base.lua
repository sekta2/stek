--[[
    База для машин(not vehicle)
]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

if SERVER then
    function ENT:Initialize()

    end
else
    function ENT:Draw()
        self:DrawModel()
    end
end