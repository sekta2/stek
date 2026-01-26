---Записывает в пакет uid крафта, если крафт не найден, возвращает ошибку
---@param res_resolvable Resource|string|number
function net.WriteSTEKCraft(res_resolvable)
    local craft = type(res_resolvable) == "table" and res_resolvable or
        (stek.Craft.index[res_resolvable] or stek.Craft.list[res_resolvable])
    if not craft then
        error(("Unknown craft '%s'"):format(res_resolvable))
    end

    net.WriteUInt(craft.uid, stek.Craft.bits_count)
end

---Читает и возвращает крафт из пакета
function net.ReadSTEKCraft()
    local uid = net.ReadUInt(stek.Craft.bits_count)
    return stek.Craft.list[uid]
end
