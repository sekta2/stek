---Spatial Hash Grid
---@class SHG
---@field grid table<number, table<number, table<number, table<number, any>? >? >? >
local SHG = {}
SHG.__index = SHG

---@return SHG
function SHG:new()
    local object = {
        grid = {}
    }

    return setmetatable(object, self)
end

---@param x number
---@param y number
---@param z number
---@return table<number, any>?
function SHG:GetCell(x, y, z)
    local xpool = self.grid[x]
    if not xpool then return end

    local ypool = xpool[y]
    if not ypool then return end

    return ypool[z]
end

---@param x number
---@param y number
---@param z number
---@param obj any
function SHG:AddObject(x, y, z, obj)
    local cell = self:GetCell(x, y, z)
    if not cell then
        local xpool = self.grid[x]
        if not xpool then
            xpool = {}
            self.grid[x] = xpool
        end

        local ypool = xpool[y]
        if not ypool then
            ypool = {}
            xpool[y] = ypool
        end

        cell = {}
        ypool[z] = cell
    end

    table.insert(cell, obj)
end

---@param x number
---@param y number
---@param z number
---@param obj any
function SHG:RemoveObject(x, y, z, obj)
    local cell = self:GetCell(x, y, z)
    if not cell then return end

    for i = #cell, 1, -1 do
        local other = cell[i]
        if other == obj then
            table.remove(cell, i)
            break
        end
    end
end

stek.SHG = SHG
