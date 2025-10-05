---Записывает в пакет uid ресурса, если ресурс не найден, возвращает ошибку
---@param res_resolvable Resource|string|number
function net.WriteSTEKResource(res_resolvable)
    local res = type(res_resolvable) == "table" and res_resolvable or (stek.Resources.index[res_resolvable] or stek.Resources.list[res_resolvable])
    if not res then
        error(("Unknown resource '%s'"):format(res_resolvable))
    end

    net.WriteUInt(res.uid, stek.Resources.bits_count)
end

---Читает и возвращает ресурс из пакета
function net.ReadSTEKResource()
    local uid = net.ReadUInt(stek.Resources.bits_count)
    return stek.Resources.list[uid]
end