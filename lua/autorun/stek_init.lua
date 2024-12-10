stek = {
    _VERSION = "1.0.0"
}

if SERVER then
    stek.sh = function(path)
        AddCSLuaFile(path)

        return include(path)
    end

    stek.sv = include
    stek.cl = AddCSLuaFile
else
    stek.sv = function() end
    stek.sh = include
    stek.cl = include
end

local sides = {
    "sh",
    "sv",
    "cl"
}

function stek.giant(name, exclude)
    exclude = exclude or {}

    for i = 1, #sides do
        if exclude[i] then continue end

        local side = sides[i]
        local fn = stek[side]

        fn("giant/" .. name .. "/" .. side .. ".lua")
    end
end

stek.sh("stek/init.lua")