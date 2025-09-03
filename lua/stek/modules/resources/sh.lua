local ResourceClass = {}
ResourceClass.__index = ResourceClass

function ResourceClass:new(id, data)
    data = data or {}

    local Object = {
        id = id,
        uid = nil,

        name = data.name,
        icon = data.icon,
        volume = data.volume or 10,

        auto_entity = data.auto_entity ~= nil and data.auto_entity or false,
        entity = data.entity
    }

    return setmetatable(Object, self)
end

function ResourceClass:GetName()
    local phrase_name = "resource_" .. self.id
    if not stek.Locale.Exists(phrase_name) then return self.name or self.id end

    return stek.Locale.Get("resource_" .. self.id)
end

function ResourceClass:GetIconPath()
    return self.icon or ("materials/stek/resources/" .. self.id .. ".png")
end

function ResourceClass:GetIcon()
    if self.icon_mat then
        return self.icon_mat
    end

    local path = self:GetIconPath()
    local mat = Material(path)

    if mat then
        self.icon_mat = mat
        return mat
    end
end

---

local Resources = {
    list = {},
    index = {},

    bits_count = 1
}

function Resources.Add(id, data)
    if not id or (id and type(id) ~= "string") then error(("invalid resource id '%s'"):format("id")) end

    local Object = ResourceClass:new(id, data)
    local uid = #Resources.list + 1

    Resources.list[uid] = Object
    Resources.index[id] = Object

    Object.uid = uid

    Resources.bits_count = stek.CheckBits(uid)

    return Object
end

Resources.Add("test", {

})

function Resources.GetByUID(uid)
    return Resources.list[uid]
end

function Resources.GetByID(id)
    return Resources.index[id]
end

stek.shared("net.lua")

stek.Resources = Resources