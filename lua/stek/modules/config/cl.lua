---@class ConfigModule
local Config = stek.Config

net.Receive("stek.ConfigSync", function(len)
    local length = net.ReadUInt(16)

    local uncompressed = util.Decompress(net.ReadData(length))
    if not uncompressed then print("Config sync failed: Decompress step") return end

    local tbl = util.JSONToTable(uncompressed)
    if not tbl then print("Config sync failed: Un-Json step") return end

    Config.raw = tbl.raw
    Config.addons = tbl.raw

    print("Config synced! " .. len .. " bits")
end)