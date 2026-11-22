---@class MapModule
local Map = stek.Map

function Map.checkMapBounds()
    local x_min, x_max, y_min, y_max, z_min, z_max = stek.determineMapBounds(10000)

    Map.min_bounds = Vector(x_min, y_min, z_min)
    Map.max_bounds = Vector(x_max, y_max, z_max)
end

---@class NR_RandomSetting
---@field amount number
---@field resources string[]

local gen_types = {
    ---@param settings NR_RandomSetting
    ["random"] = function(settings)
        print("TODO")
    end
}

function Map.generateNaturalResources(gen_type, gen_settings)
    local fn = gen_types[gen_type]
    if fn then
        return fn(gen_settings)
    end
end
