---@class CraftOutputDataResource
---@field resource string Идентификатор ресурса
---@field amount integer Количество ресурса

---@class CraftOutputDataEntity
---@field class string Имя класса энтити
---@field amount integer Количество энтити

---@class CraftOutputDataProp
---@field model string Путь к модели пропа
---@field amount integer Количество пропов

---@class CraftOutput
---@field type "resource"|"entity"|"prop" Вариант результата крафта
---@field data CraftOutputDataResource|CraftOutputDataEntity|CraftOutputDataProp Данные результата крафта

---@class CraftData
---@field name string? Название крафта, используется когда не найдено переведённое название
---@field description string? Описание крафта
---@field icon string? Путь до значка крафта
---@field category string? Категория крафта
---@field resources { [string]: number } Ресуры нужные для крафта
---@field tags string[]? Теги крафта (специальные метки для столов для крафта)
---@field output fun()|CraftOutput Функция для спавна при успешном крафте, или структура CraftOutput

---

---@class Craft: CraftData
---@field uid integer Уникальный Идентификатор крафта
---@field id string Идентификатор крафта
---@field tags string[] Теги крафта (специальные метки для столов для крафта)
---@field category string Категория крафта
local CraftClass = {}
CraftClass.__index = CraftClass

---Создаёт и возвращает объект крафта
---@param id string
---@param data CraftData
---@return Craft
function CraftClass:new(id, data)
    data = data or {}

    local tags = data.tags or {}
    if not table.HasValue(tags, "*") then
        tags[#tags+1] = "*"
    end

    local Object = {
        id = id,
        uid = nil,

        name = data.name,
        description = data.description,
        icon = data.icon,
        category = data.category or "Other",
        resources = data.resources,
        tags = tags,
        output = data.output
    }

    return setmetatable(Object, self)
end

---Возвращает название крафта
---@return string
function CraftClass:GetName()
    local phrase_name = "craft_" .. self.id
    if not stek.Locale.Exists(phrase_name) then return self.name or self.id end

    return stek.Locale.Get("craft_" .. self.id)
end

---Возвращает описание крафта
---@return string
function CraftClass:GetDescription()
    local phrase_name = "craft_desc_" .. self.id
    if not stek.Locale.Exists(phrase_name) then return self.description end

    return stek.Locale.Get("craft_desc_" .. self.id)
end

---Возвращает путь к значку крафта
---@return string
function CraftClass:GetIconPath()
    return self.icon or ("materials/stek/crafts/" .. self.id .. ".png")
end

---Возвращает материал значка крафта, если путь не валидный, возвращает nil
---@return IMaterial?
function CraftClass:GetIcon()
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

---@class CraftTableData
---@field tags string[]? Крафты с этими тегами будут разрешены для крафта
---@field allow string[]? Крафты в этом списке будут разрешены для крафта
---@field deny string[]? Крафты в этом списке будут запрещены для крафта (работает поверх allow и tags, т.е может запрещать крафты в allow и tags)

---@class CraftTable: CraftTableData
---@field id string Идентификатор стола для крафта
---@field cached_list Craft[]?
---@field cached_index table<string, true|nil>?
local CraftTableClass = {}
CraftTableClass.__index = CraftTableClass

---Создаёт и возвращает объект стола для крафта
---@param id string
---@param data CraftTableData
---@return CraftTable
function CraftTableClass:new(id, data)
    data = data or {}

    local Object = {
        id = id,

        tags = data.tags or { "*" },
        allow = data.allow or {},
        deny = data.deny or {}
    }

    return setmetatable(Object, self)
end

---Компилирует и возвращает список и HashSet разрешенных крафтов
---@return Craft[]
---@return table<string, true|nil>
function CraftTableClass:Compile()
    local list = stek.Craft.GetByTags(self.tags)
    local index = {}

    for i = 1, #list do
        local item = list[i]
        index[item.id] = true
    end

    for i = 1, #self.allow do
        local item = self.allow[i]
        if not index[item] then
            index[item] = true
            list[#list + 1] = stek.Craft.GetByID(item)
        end
    end

    for i = 1, #self.deny do
        local item = self.deny[i]
        if index[item] then
            index[item] = nil

            for j = #list, 1, -1 do
                local other_item = list[j]
                if other_item == item then
                    table.remove(list, j)
                    break
                end
            end
        end
    end

    return list, index
end

---Возвращает список разрешенных крафтов
---@return Craft[]
function CraftTableClass:GetCraftsList()
    if not self.cached_index then
        local list, index = self:Compile()
        self.cached_list = list
        self.cached_index = index
    end

    return self.cached_list
end

---Возвращает HashSet разрешенных крафтов
---@return table<string, true|nil>
function CraftTableClass:GetCraftsIndex()
    if not self.cached_index then
        local list, index = self:Compile()
        self.cached_list = list
        self.cached_index = index
    end

    return self.cached_index
end

---

---# Модуль для крафтов
---@class CraftModule
---@field list Craft[]
---@field index table<string, Craft>
---@field table_index table<string, CraftTable>
---@field tags table<string, Craft[]>
---@field bits_count number
local Craft = {
    list = {},

    index = {},
    table_index = {},

    tags = {},

    bits_count = 1
}

---Создаёт новый крафт и возвращает его
---@param id string
---@param data CraftData
---@return Craft
function Craft.Create(id, data)
    if not id or (id and type(id) ~= "string") then error(("invalid craft id '%s'"):format(id)) end

    local Object = CraftClass:new(id, data)
    local uid = #Craft.list + 1

    Craft.list[uid] = Object
    Craft.index[id] = Object

    Object.uid = uid

    Craft.bits_count = stek.BitsForUnsignedInt(uid)

    if type(Object.tags) == "table" then
        for i = 1, #Object.tags do
            local tag = Object.tags[i]

            local tags_list = Craft.tags[tag]
            if not tags_list then
                tags_list = {}
                Craft.tags[tag] = tags_list
            end

            table.insert(tags_list, Object)
        end
    end

    return Object
end

---Возвращает крафт по указанному UID
---@param uid integer Уникальный Идентификатор крафта
---@return Craft
function Craft.GetByUID(uid)
    return Craft.list[uid]
end

---Возвращает крафт по указанному идентификатору
---@param id string Идентификатор крафта
---@return Craft
function Craft.GetByID(id)
    return Craft.index[id]
end

---Возвращает список крафтов по тегам
---@param t string[]
---@return Craft[]
function Craft.GetByTags(t)
    local result = {}
    local index = {}

    for i = 1, #t do
        local tag = t[i]

        local tag_list = Craft.tags[tag]
        if tag_list then
            for j = 1, #tag_list do
                local craft = tag_list[j]
                if not index[craft] then
                    index[craft] = true
                    result[#result + 1] = craft
                end
            end
        end
    end

    return result
end

---

---Создаёт новый стол для крафта и возвращает его
---@param id string
---@param data CraftTableData
---@return CraftTable
function Craft.CreateTable(id, data)
    if not id or (id and type(id) ~= "string") then error(("invalid craft-table id '%s'"):format(id)) end

    local Object = CraftTableClass:new(id, data)
    Craft.table_index[id] = Object

    return Object
end

---Возвращает стол для крафта по указанному идентификатору
---@param id string Идентификатор стола для крафта
---@return CraftTable?
function Craft.GetTableByID(id)
    return Craft.table_index[id]
end

stek.shared("net.lua")

stek.Craft = Craft
