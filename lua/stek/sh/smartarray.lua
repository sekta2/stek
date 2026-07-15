--[[
    Name: smartarray.lua
    Author(s): sekta
    Repository: https://github.com/VanguardGM/utils

    SmartArray is a doubly-linked list implementation with cell reuse optimization.
    It maintains a pool of cells and a free list to efficiently manage memory
    by reusing freed cells instead of creating new ones.

    (inspired from foo52ru video)
    (https://youtu.be/g-Ow9eNm63k?t=74) [RU]
    (https://youtu.be/tfWsS299oLc?t=74) [EN]
]]

---@class SmartArray_Cell
---@field uid number Unique identifier for the cell.
---@field free boolean Indicates whether the cell is currently free (not in use).
---@field prev_cell number UID of the previous cell in the linked list.
---@field next_cell number UID of the next cell in the linked list.
---@field virtual boolean Marks if the cell is a virtual anchor cell (used for list boundaries).
---@field data any? The data stored in this cell (can be any type).
local Cell = {}
Cell.__index = Cell

---Creates a new cell with the specified unique identifier.
---@param uid integer The unique identifier to assign to this cell.
---@return SmartArray_Cell The newly created cell instance.
function Cell:new(uid)
    local Object = {
        uid = uid,
        free = false,

        prev_cell = 0,
        next_cell = 0,

        virtual = false,
        data = nil
    }

    return setmetatable(Object, self)
end

---

---@class SmartArray
---@field pull SmartArray_Cell[] Pool of all cells indexed by their UID.
---@field free SmartArray_Cell[] Array of cells that are currently free and can be reused.
---@field uid number Counter for generating unique cell identifiers.
---@field virtual_cell SmartArray_Cell Virtual anchor cell used as the starting point of the linked list.
local Manager = {}
Manager.__index = Manager

---Creates a new SmartArray instance.
---Initializes the cell pool, free list, and creates a virtual anchor cell.
---@return SmartArray The newly created SmartArray instance.
function Manager:new()
    local Object = {
        pull = {},
        free = {},
        uid = -1,
    }

    setmetatable(Object, self)

    local virtual_cell = Object:_new_cell()
    virtual_cell.virtual = true

    Object.virtual_cell = virtual_cell

    return Object
end

---Internal method to create a new cell and add it to the pool.
---Automatically increments the UID counter.
---@param data any? Optional data to store in the cell.
---@return SmartArray_Cell The newly created cell.
function Manager:_new_cell(data)
    self.uid = self.uid + 1
    local uid = self.uid

    local cell = Cell:new(uid)
    if data then cell.data = data end

    self.pull[uid] = cell

    return cell
end

---

---Marks a cell as free and removes it from the linked list.
---The cell is added to the free list for potential reuse.
---Does nothing if the cell doesn't exist or is virtual.
---@param id integer The UID of the cell to free.
function Manager:FreeCell(id)
    local cell = self.pull[id]
    if not cell or cell.virtual then return end

    cell.free = true
    cell.data = nil

    local prev_cell = self.pull[cell.prev_cell]
    local next_cell = self.pull[cell.next_cell]

    if prev_cell then prev_cell.next_cell = next_cell.uid end
    if next_cell then next_cell.prev_cell = prev_cell.uid end

    cell.prev_cell = 0
    cell.next_cell = 0

    table.insert(self.free, cell)
end

---Marks a cell as taken (in use) and removes it from the free list.
---Does nothing if the cell doesn't exist or is virtual.
---@param id integer The UID of the cell to take.
function Manager:TakeCell(id)
    local cell = self.pull[id]
    if not cell or cell.virtual then return end

    cell.free = false

    for i = #self.free, 1, -1 do
        if self.free[i] == cell then
            table.remove(self.free, i)
            return
        end
    end
end

---Returns the last free cell from the free list without removing it.
---@return SmartArray_Cell? The last free cell, or nil if no free cells are available.
function Manager:GetFreeCell()
    local free = self.free[#self.free]
    if not free then return end

    return free
end

---Gets a free cell from the free list or creates a new one if none are available.
---If a free cell is used, it is marked as taken and its data is updated.
---@param data any? Optional data to store in the cell.
---@return SmartArray_Cell The retrieved or newly created cell.
function Manager:GetFreeOrCreate(data)
    local cell = self:GetFreeCell() or self:_new_cell(data)
    if cell.free then
        cell.data = data
        self:TakeCell(cell.uid)
    end

    return cell
end

---

---Inserts a new cell after the specified cell in the linked list.
---@param id integer The UID of the cell after which to insert.
---@param data any? Optional data to store in the new cell.
---@return SmartArray_Cell? The newly inserted cell, or nil if the specified cell doesn't exist.
function Manager:PlaceAfter(id, data)
    local current = self.pull[id]
    if not current then return end

    local cell = self:GetFreeOrCreate(data)

    local prev_cell = id
    local next_cell = current.next_cell

    cell.prev_cell = prev_cell
    cell.next_cell = next_cell

    local current_next = self:GetCell(next_cell)
    if current_next then current_next.prev_cell = cell.uid end
    current.next_cell = cell.uid

    return cell
end

---Inserts a new cell before the specified cell in the linked list.
---@param id integer The UID of the cell before which to insert.
---@param data any? Optional data to store in the new cell.
---@return SmartArray_Cell? The newly inserted cell, or nil if the specified cell doesn't exist.
function Manager:PlaceBefore(id, data)
    local current = self.pull[id]
    if not current then return end

    local cell = self:GetFreeOrCreate(data)

    local prev_cell = current.prev_cell
    local next_cell = id

    cell.prev_cell = prev_cell
    cell.next_cell = next_cell

    local current_prev = self:GetCell(prev_cell)
    if current_prev then current_prev.next_cell = cell.uid end
    current.prev_cell = cell.uid

    return cell
end

---Retrieves a cell by its unique identifier.
---@param id integer The UID of the cell to retrieve.
---@return SmartArray_Cell The cell with the specified UID.
function Manager:GetCell(id)
    return self.pull[id]
end

---

---Iterates through all non-virtual cells in the linked list.
---Executes the provided function for each cell.
---@param fn fun(cell: SmartArray_Cell) The function to execute for each cell.
function Manager:Foreach(fn)
    local pull = self.pull
    local virtual = pull[0]

    if not virtual then return end

    local current_uid = virtual.next_cell
    if current_uid == 0 then return end

    while current_uid ~= 0 do
        local current_cell = pull[current_uid]
        if not current_cell then break end

        local next_uid = current_cell.next_cell

        if not current_cell.virtual then
            fn(current_cell)
        end

        current_uid = next_uid
    end
end

---Counts the total number of non-virtual cells in the linked list.
---@return integer amount The number of cells currently in use.
function Manager:Count()
    local count = 0

    self:Foreach(function()
        count = count + 1
    end)

    return count
end

stek.SmartArray = Manager
