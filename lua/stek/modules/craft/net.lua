---Записывает в пакет uid крафта, если крафт не найден, возвращает ошибку
---@param craft_resolvable Craft|string|number
function net.WriteSTEKCraft(craft_resolvable)
    local craft = type(craft_resolvable) == "table" and craft_resolvable or
        (stek.Craft.index[craft_resolvable] or stek.Craft.list[craft_resolvable])

    if not craft then
        error(("Unknown craft '%s'"):format(craft_resolvable))
    end

    net.WriteUInt(craft.uid, stek.Craft.bits_count)
end

---Читает и возвращает крафт из пакета
---@return Craft
function net.ReadSTEKCraft()
    local uid = net.ReadUInt(stek.Craft.bits_count)
    return stek.Craft.list[uid]
end
