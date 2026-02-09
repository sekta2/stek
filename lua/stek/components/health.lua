---@class ComponentHealth: ComponentBase
local COMPONENT = stek.Components.Create("Health")

function COMPONENT:Initialize()
    self.Value = self.Value or 100
    print("Current health of prefab: " .. self.Value)
end

function COMPONENT:Think()
    if not CLIENT then return end

    print("think test")
end
