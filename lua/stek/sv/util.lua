function s_util.take_entity(ply, ent)
    if ent.IsStekResource then
        local success = ent:TakeResource(ply, ent:GetAmount())

        if success then
            sound.Play("snd_jack_clothequip.ogg", ply:GetPos(), 50, math.random(90, 110))
        end
    --[[
    elseif ent.IsDDRagdoll and not ent.DDRagLooted then
        ent.DDRagLooted = true

        local money = ent.dd_rag_money

        if money > 0 then ply:AddMoney(money) end
        ent.dd_rag_money = 0

        ply:SendMessage(Color(123, 240, 55), "Вы подобрали " .. money .. "$")

        local tag = ent.TagInfo
        ply:SendMessage("Жетон игрока:\n - Ник: " .. tag.name)

        --

        local inv = ent.inventory

        if inv then
            for k, v in pairs(inv.resources) do
                local class = ddcore.get_resource_uid(k).ent_class

                local entr = ents.Create(class)
                entr:SetPos(ent:GetPos())
                entr:SetAmount(v)

                entr:Spawn()
            end

            ent.inventory = nil

            inv:Destroy()
        end
    ]]
    end
end

local LiquidResourceTypes = {
    ["water"] = true,
    ["coolant"] = true,
    ["oil"] = true,
    ["chemicals"] = true,
    ["fuel"] = true
}

local SpriteResourceTypes = {
    ["gas"] = true,
    ["sand"] = true,
    ["paper"] = true,
    ["antimatter"] = true,
    ["propellant"] = true,
    ["cloth"] = true,
    ["power"] = true
}

function s_util.res_effect(type, fromPoint, toPoint, amt, spread, scale, upSpeed)
    amt = (amt and math.Clamp(amt, 0, 1)) or 1
    spread = spread or 1
    scale = scale or 1
    upSpeed = upSpeed or 0

    amt = math.Clamp(amt, 0.5, 5)

    local UseSprites = SpriteResourceTypes[type]

    if UseSprites then amt = amt * 2 end

    for i = 0, 2 * amt do
        timer.Simple(i / 20, function()
            for i2 = 1, 1 do
                local whee = EffectData()
                whee:SetOrigin(fromPoint)
                if toPoint then
                    whee:SetStart(toPoint)
                end
                whee:SetFlags(1)
                whee:SetMagnitude(spread)
                whee:SetRadius(upSpeed)
                whee:SetScale(scale)

                if toPoint then
                    whee:SetSurfaceProp(1) -- we have somewhere to go
                else
                    whee:SetSurfaceProp(0) -- just do a directionless explosion of particles
                end

                if LiquidResourceTypes[type] then
                    util.Effect("eff_jack_gmod_resource_liquid", whee, true, true)
                elseif UseSprites then
                    util.Effect("eff_jack_gmod_resource_sprites", whee, true, true)
                else
                    util.Effect("eff_jack_gmod_resource_props", whee, true, true)
                end
            end
        end)
    end
end