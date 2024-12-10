s_util = {}

--[[------------------------]]--

local SERVER = SERVER
local MsgC = MsgC

--[[------------------------]]--

local sv_color = Color(4, 186, 252)
local cl_color = Color(252, 186, 4)

function s_util.print(...)
    local color = SERVER and sv_color or cl_color

    MsgC(color, "[STek] ") MsgC(color_white, ...) MsgC("\n")
end

--[[------------------------]]--

if CLIENT then
    local chatAT = chat.AddText

    function s_util.chat(...)
        chatAT(sv_color, "[STek] ", color_white, ...)
    end
end

--[[------------------------]]--

function s_util.set_function(meta, key, name)
    meta["Set" .. name] = function(self, value)
        self[key] = value
    end
end

function s_util.get_function(meta, key, name)
    meta["Get" .. name] = function(self)
        return self[key]
    end
end

function s_util.set_get_function(meta, key, name)
    s_util.set_function(meta, key, name)
    s_util.get_function(meta, key, name)
end

--[[------------------------]]--

function s_util.cone_trace(ply, cone, dist)
    local aim_vector = ply:GetAimVector()
    local shoot_pos = ply:GetShootPos()

    for i = 1, 150 * cone do
        local vec = (aim_vector + VectorRand() * cone):GetNormalized()

        local tr = util.QuickTrace(shoot_pos, vec * dist, {ply})

        if tr.Hit and not tr.HitSky and tr.Entity then
            return tr.Entity, tr.HitPos, tr.HitNormal
        end
    end

    return nil, nil, nil
end