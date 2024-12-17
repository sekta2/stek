function stek.load_modules()
    local _, modules = file.Find("stek-modules/*", "LUA")

    for k, v in pairs(modules) do
        stek.sh("stek-modules/" .. v .. "/init.lua")
    end
end