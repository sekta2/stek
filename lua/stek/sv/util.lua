function s_util.take_entity(ply, ent)
    if ent.IsStekResource then
        ent:TakeResource(ply, ent:GetAmount())
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