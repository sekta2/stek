---@class ComponentsModule
local Components = stek.Components

function Components.SpawnEntity()
    ---@class ent_stek_entity
    local ent = ents.Create("ent_stek_entity")
    ent._components = {}

    return ent
end
