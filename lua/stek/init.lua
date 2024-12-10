-- Shared

stek.sh("sh/net.lua")
stek.sh("sh/config.lua")
stek.sh("sh/util.lua")

-- Server

stek.sv("sv/util.lua")

-- Client

stek.cl("cl/gui.lua")
stek.cl("cl/helpers.lua")

-- Giants

stek.giant("resources")
stek.giant("craft", {_, true, true})
stek.giant("inventory")

-- Loads

s_res.load() -- Load "resources" giant
s_craft.load() -- Load "craft" giant