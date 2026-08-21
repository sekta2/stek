---@class Entity
---@field ClientUse fun(self: Entity, ply:Player) Called when an local player uses this entity. (CLIENT)

local USE_DISTANCE = 10000
local USE_BIND = "+use"

hook.Add("PlayerBindPress", "stek.ClientUse", function(ply, bind, pressed)
    if pressed and bind == USE_BIND then
        local tr = ply:GetEyeTrace()

        if IsValid(tr.Entity) then
            local dist = ply:GetPos():DistToSqr(tr.HitPos)
            local fn_client_use = tr.Entity.ClientUse

            local current_wep = ply:GetActiveWeapon()
            local using_physgun = ply:KeyDown(IN_ATTACK) and (IsValid(current_wep) and current_wep:GetClass() == "weapon_physgun")

            if dist < USE_DISTANCE and fn_client_use and not using_physgun then
                fn_client_use(tr.Entity, ply)

                return false
            end
        end
    end
end)
