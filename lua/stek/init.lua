local function LoadModules()
    local _, modules = file.Find("stek/modules/*", "LUA")

    for i = 1, #modules do
        local name = modules[i]

        if file.Exists("stek/modules/" .. name .. "/sh.lua", "LUA") then
            stek.shared("modules/" .. name .. "/sh.lua")
        end

        if SERVER and file.Exists("stek/modules/" .. name .. "/sv.lua", "LUA") then
            stek.server("modules/" .. name .. "/sv.lua")
        end

        if file.Exists("stek/modules/" .. name .. "/cl.lua", "LUA") then
            stek.client("modules/" .. name .. "/cl.lua")
        end
    end
end

local sides = {"sh", "sv", "cl"}
local sides_fn = {
    sh = stek.shared,
    sv = stek.server,
    cl = stek.client
}

local function LoadScripts()
    for i = 1, #sides do
        local side = sides[i]
        local side_fn = sides_fn[side]

        local scripts, _ = file.Find("stek/" .. side .. "/*.lua", "LUA")

        for ii = 1, #scripts do
            local name = scripts[ii]
            side_fn("stek/" .. side .. "/" .. name)
        end
    end
end

LoadModules()
LoadScripts()

---

function stek.InitDirectories()
    if file.Exists("stek", "DATA") then return end

    file.CreateDir("stek")

    file.CreateDir("stek/config")
    file.CreateDir("stek/config/addons")
end

---

stek.InitDirectories()
stek.Locale.Init()
stek.Config.Load()
stek.Resources.Init()

if SERVER then
    stek.Config.InitCommands()
end