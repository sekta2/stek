local scrounge_props = {
    ["tut_modelka"] = {
        chance = 1,
        resource = tut_resource,
        min = 2, max = 15
    }
}

local function select_random_prop() -- code from chatgpt
    local totalWeight = 0
    
    for _, prop in pairs(scrounge_props) do
        totalWeight = totalWeight + prop.chance
    end
    
    local randomWeight = math.random(0, totalWeight - 1)
    local currentWeight = 0
    
    for id, prop in pairs(scrounge_props) do
        currentWeight = currentWeight + prop.chance
        if randomWeight < currentWeight then
            return id, prop
        end
    end
end

function stech.make_scrounge(spawn_pos)
    local count = math.random(3, 5)

    for i = 1, count do
        local id_junk, junk = select_random_prop()
        local pos = spawn_pos + Vector(math.random(-50, 50), math.random(-50, 50), 15)

        if util.IsInWorld(pos) then
            local prop = ents.Create("prop_physics")
            prop:SetModel(id_junk)
            prop:SetPos(pos)

            prop.StechResource = junk.resource
            prop.StechResourceCount = math.random(junk.min, junk.max)

            prop:Spawn()
        end
    end
end

--[[--------------------]]--

util.AddNetworkString("stech.scrounge")

net.Receive("stech.scrounge", function(_, ply)
    local pos = ply:GetPos()

    stech.make_scrounge(pos)
end)