---https://semver.org/lang/ru/
stek._VERSION = "1.0.0"

---

local modules_priority = {
    config = {
        pos = -2
    },
    draw = {
        pos = -1,
    },
    ["gas-system"] = {
        pos = -1
    },
    locale = {
        pos = -1,
    },
    resources = {
        pos = 0
    },
    craft = {
        pos = 0,
        after = { resources = true }
    },
    inv = {
        pos = 0,
        after = { resources = true }
    },
    gui = {
        pos = 1,
    }
}

local function LoadModules()
    local _, modules = file.Find("stek/modules/*", "LUA")

    table.sort(modules, function(a, b)
        local ao = modules_priority[a] or { pos = 0 }
        local bo = modules_priority[b] or { pos = 0 }

        if ao.pos ~= bo.pos then
            return ao.pos < bo.pos
        end

        if (ao.after and ao.after[b]) or (bo.before and bo.before[a]) then
            return false
        end

        if (ao.before and ao.before[b]) or (bo.after and bo.after[a]) then
            return true
        end

        return a < b
    end)

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

local sides = { "sh", "sv", "cl" }
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

local function LoadAddons()
    local _, addons = file.Find("stekpacks/*", "LUA")

    for i = 1, #addons do
        local addon_name = addons[i]

        local respath = "stekpacks/" .. addon_name .. "/resources.lua"
        if file.Exists(respath, "LUA") then
            stek.shared(respath)
        end

        local gaspath = "stekpacks/" .. addon_name .. "/gas.lua"
        if file.Exists(gaspath, "LUA") then
            stek.shared(gaspath)
        end

        local configpath = "stekpacks/" .. addon_name .. "/config.lua"
        if file.Exists(configpath, "LUA") then
            stek.shared(configpath)
        end
    end
end

LoadModules()
LoadScripts()
LoadAddons()

---

function stek.InitDirectories()
    if file.Exists("stek", "DATA") then return end

    file.CreateDir("stek")

    file.CreateDir("stek/config")
    file.CreateDir("stek/config/addons")
end

---

if SERVER then
    stek.InitDirectories()
    stek.Config.Load()
    stek.Config.InitCommands()
end

stek.Task.Init()
stek.Locale.Init()
stek.Resources.InitAutoEntities()
stek.Craft.Init()
stek.WindInit()
stek.GasSystem.Init()
