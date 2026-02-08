---@diagnostic disable: assign-type-mismatch

---@class PrefabDataSandbox
---@field print_name string? Название энтити
---@field category string? Категория энтити в спавнменю
---@field spawnable boolean? Можно ли заспавнить этот энтити? (это влияет на то будет ли он показан в спавнменю)
---@field admin_only boolean? Это админский энтити?
---@field icon_override string? Путь к значку этого энтити (по дефолту если этот параметр не указан - "entities/<ClassName>.png")

---@class PrefabData
---@field id string Идентификатор префаба и его энтити (например ent_stek_awesome_workbench)
---@field author string? Автор префаба
---@field physics_sounds boolean? Нужны ли звуки столкновений для этого энтити? (влияет от модели)
---@field sandbox PrefabDataSandbox? Настройки песочницы

---@class Prefab: PrefabData
---@field uid number Уникальный идентификатор префаба

---@param Components ComponentsModule
return function(Components)
    ---@class ComponentsPrefabModule
    ---@field list [Prefab]
    ---@field index { [string]: Prefab }
    local Prefab = {
        list = {},
        index = {},

        bits_count = 1
    }

    ---
    ---@param prefab_data PrefabData
    ---@return Prefab
    function Prefab.Create(prefab_data)
        ---@type Prefab
        prefab_data = prefab_data

        local uid = #Prefab.list + 1

        Prefab.list[uid] = prefab_data
        Prefab.index[prefab_data.id] = prefab_data

        prefab_data.uid = uid

        Prefab.bits_count = stek.BitsForUnsignedInt(uid)

        ---

        local ent = {
            Base = "ent_stek_entity",
            Type = "anim",

            Prefab = prefab_data
        }

        ent.Author = prefab_data.author
        ent.PhysicsSounds = prefab_data.physics_sounds

        local sandbox = prefab_data.sandbox
        if sandbox then
            ent.PrintName = sandbox.print_name
            ent.Category = sandbox.category
            ent.Spawnanble = sandbox.spawnable
            ent.AdminOnly = sandbox.admin_only
            ent.IconOverride = sandbox.icon_override
        end

        scripted_ents.Register(ent, prefab_data.id)

        return prefab_data
    end

    ---
    ---@param id string Идентификатор префаба
    ---@return ent_stek_entity
    function Prefab.Spawn(id)
        if not Prefab.index[id] then error(("Tried to spawn unknown prefab '%s'"):format(id)) end

        ---@type ent_stek_entity
        local ent = ents.Create(id)
        return ent
    end

    function Prefab.Init()
        local files, _ = file.Find("stek/prefabs/*.lua", "LUA")

        for i = 1, #files do
            local filename = files[i]

            ---@type PrefabData
            local prefab_data = stek.shared("stek/prefabs/" .. filename)
            Prefab.Create(prefab_data)
        end
    end

    return Prefab
end
