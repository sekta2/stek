-- Shared

stek.sh("sh/net.lua")
stek.sh("sh/config.lua")
stek.sh("sh/util.lua")
stek.sh("sh/sync.lua")

-- Server

stek.sv("sv/util.lua")

-- Client

stek.cl("cl/gui.lua")
stek.cl("cl/helpers.lua")

-- Giants

stek.giant("actions")
stek.giant("resources")
stek.giant("craft", {_, true, true})
stek.giant("inventory")
stek.giant("modules", {_, true, true})

-- Loads

s_res.load() -- Load "resources" giant
s_craft.load() -- Load "craft" giant
stek.load_modules() -- Load "modules" giant