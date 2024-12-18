net.Receive("s_actions.err", function()
    local err = net.ReadString()
    s_util.print("[SERVER] Action execution error:\n", err)
end)