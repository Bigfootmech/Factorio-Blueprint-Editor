--[[
http://lua-api.factorio.com/latest/Concepts.html#Position
Position

Coordinates of a tile in a map. Positions may be specified either as a dictionary with x, y as keys, or simply as an array with two elements.

Example
{10, 20}
Example
{x = 50, y = 20}
{y = 20, x = 50}
]]

local Object = require('lib.lua_enhance.Object')
local Vector = require('lib.spatial.Vector')

local Position = {}
Position.__index = Position

-- epsilon?

local function new(x, y)
    assert(type(x) == "number", "x is not a number")
    assert(type(y) == "number", "y is not a number")
    return setmetatable({x = x, y = y}, Position)
end

Position.new = new

local function origin()
    return Position.new(0,0)
end

Position.origin = origin

local function is_standard_position(obj)
    if obj.x ~= nil and obj.y ~= nil then return true end
    return false
end

local function is_simplified_position(obj)
    if obj[1] ~= nil and obj[2] ~= nil then return true end
    return false
end

local function is_position(obj)
    return is_standard_position(obj) or is_simplified_position(obj)
end

Position.is_position = is_position

local function copy(position)
    Position.is_position(position)
    return Position.new(Position.get_x(position), Position.get_y(position))
end

Position.copy = copy

function Position:is_instatiated()
    return is_position(self)
end

function Position:get_x()
    assert(Position.is_position(self), "tried to get-x of non-position object with position class") -- can standardize these
    if is_standard_position(self) then return self.x end
    if is_simplified_position(self) then return self[1] end
end
function Position:get_y()
    assert(Position.is_position(self), "tried to get-y of non-position object with position class")
    if is_standard_position(self) then return self.y end
    if is_simplified_position(self) then return self[2] end
end
function Position:set_x(x)
    assert(Position.is_position(self), "tried to set-x of non-position object with position class")
    if is_standard_position(self) then self.x = x return end
    if is_simplified_position(self) then self[1] = x return end
end
function Position:set_y(y)
    assert(Position.is_position(self), "tried to set-y of non-position object with position class")
    if is_standard_position(self) then self.y = y return end
    if is_simplified_position(self) then self[2] = y return end
end

local function is_valid_type_for_addition(obj)
    return Vector.is_vector(obj) or Position.is_position(obj)
end

function Position:add(obj)
    assert(Position.is_position(self), "tried to add to non-position object with position class")
    assert(is_valid_type_for_addition(obj), "tried to add invalid object to position")
    Position.set_x(self, Position.get_x(self) + Position.get_x(obj))
    Position.set_y(self, Position.get_y(self) + Position.get_y(obj))
    return self
end

function Position:subtract(obj)
    assert(self:is_position(), "tried to subtract from non-position object with position class")
    assert(is_valid_type_for_addition(obj), "tried to subtract invalid object to position")
    Position.set_x(self, Position.get_x(self) - Position.get_x(obj))
    Position.set_y(self, Position.get_y(self) - Position.get_y(obj))
    return self
end

-- tostring?
-- equals?
-- hashcode???

return Position