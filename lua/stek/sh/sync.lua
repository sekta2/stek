s_sync = {
    list = {}
}

local net_types = {
    ["number"] = net.WriteSmartInt,
    ["boolean"] = net.WriteBool,
    ["string"] = net.WriteString,
    ["table"] = net.WriteTable,
    ["Entity"] = net.WriteEntity
}

local net_types2 = {
    ["number"] = net.ReadSmartInt,
    ["boolean"] = net.ReadBool,
    ["string"] = net.ReadString,
    ["table"] = net.ReadTable,
    ["Entity"] = net.ReadEntity
}

function s_sync.AddSync(name)
    local id = name .. ".sync"

    s_sync.list[name] = {}

    if SERVER then
        util.AddNetworkString(id)
    else
        net.Receive(id, function()
            local opcode = net.ReadUInt(5)

            local act = s_sync.list[name][opcode]
            if act then
                local fn = act[1]
                local args = act[2]

                local m_args = {}

                for i = 1, #args do
                    local arg = args[i]
                    local typfn = net_types2[arg[2]]

                    m_args[arg[1]] = typfn()
                end

                fn(m_args)
            end
        end)
    end
end

if SERVER then
    local types = {
        ["number"] = tonumber,
        ["boolean"] = tobool,
        ["string"] = tostring
    }

    function s_sync.Sync(name, opcode, ...)
        local id = name .. ".sync"
        local args = {...}

        net.Start(id)
        net.WriteUInt(opcode, 5)

        for i = 1, #args do
            local val = args[i]
            local typ = type(val)

            local fn = types[typ]
            if fn then val = fn(val) end

            local netfn = net_types[typ]
            netfn(val)
        end
    end

    function s_sync.AddSyncFunc() -- shared cool
    end
else
    function s_sync.AddSyncFunc(name, opcode, args, fn)
        s_sync.list[name][opcode] = {fn, args}
    end
end