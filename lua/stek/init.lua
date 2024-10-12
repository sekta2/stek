-- Shared

stek_run.shared("sh/config.lua")
stek_run.shared("sh/util.lua")

stek_run.shared("sh/net.lua")
stek_run.shared("sh/actions.lua")
stek_run.shared("sh/resources.lua")
stek_run.shared("sh/recipes.lua")

-- Server

stek_run.server("sv/scrounge.lua")

-- Server-Client

-- Client

stek_run.client("cl/TP_betterroundboxes.lua")
stek_run.shared("cl/gui.lua") -- SHARED SCRIPT BUT THIS IS MOSTLY CLIENT