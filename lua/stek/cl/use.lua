---@class Entity
---@field ClientUse fun(ply:Player) Called when an local player uses this entity. (CLIENT)

local USE_DISTANCE = 10000
local USE_BIND = "+use"

hook.Add("PlayerBindPress", "stek.ClientUse", function(ply, bind, pressed)
    if pressed and bind == USE_BIND then
        local tr = ply:GetEyeTrace()

        if IsValid(tr.Entity) then
            local dist = ply:GetPos():DistToSqr(tr.HitPos)
            local fn_client_use = tr.Entity.ClientUse

            if dist < USE_DISTANCE and fn_client_use then
                fn_client_use(ply)

                return false
            end
        end
    end
end)
