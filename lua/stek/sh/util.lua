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