---@class MapModule
local Map = stek.Map

function Map.checkMapBounds()
    local x_min, x_max, y_min, y_max, z_min, z_max = stek.determineMapBounds(10000)

    Map.min_bounds = Vector(x_min, y_min, z_min)
    Map.max_bounds = Vector(x_max, y_max, z_max)
end
