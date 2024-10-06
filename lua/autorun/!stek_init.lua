stek = {}
stek_run = {}

if SERVER then
    AddCSLuaFile("stek/init.lua")

    function stek_run.server(path)
        return include(path)
    end

    function stek_run.shared(path)
        AddCSLuaFile(path)

        return include(path)
    end

    function stek_run.client(path)
        AddCSLuaFile(path)
    end
else
    function stek_run.server()
    end

    function stek_run.shared(path)
        return include(path)
    end

    function stek_run.client(path)
        return include(path)
    end
end

include("stek/init.lua")