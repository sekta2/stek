_G.stek = {}

--- Shared load functions

if SERVER then
    stek.server = include
    stek.client = AddCSLuaFile
    stek.shared = function(path)
        AddCSLuaFile(path)
        return include(path)
    end
else
    stek.server = function() end
    stek.client = include
    stek.shared = include
end

--- load stek/init.lua

stek.shared("stek/init.lua")
