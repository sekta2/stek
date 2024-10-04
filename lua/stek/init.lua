-- Shared

stek_run.shared("sh/net.lua")
stek_run.shared("sh/resources.lua")

-- Server

-- Server-Client

stek_run.server("sv/scrounge.lua")
stek_run.client("cl/scrounge.lua")

-- Client