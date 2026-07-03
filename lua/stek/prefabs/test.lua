---@type PrefabData
local PREFAB = {}

PREFAB.id = "prefab_test"
PREFAB.components = {
    Health = {
        Value = 50
    }
}

PREFAB.sandbox = {
    spawnable = true,
    print_name = "Nigga test",
    category = "for niggas"
}

return PREFAB
