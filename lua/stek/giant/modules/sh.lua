function stek.load_modules()
    local _, modules = file.Find("stek-modules/*", "LUA")

    for k, v in pairs(modules) do
        stek.sh("stek-modules/" .. v .. "/init.lua")
        if GetConVar("developer"):GetBool() then s_util.print("[MODULE] Loaded module: " .. v) end
    end
end