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
local Object = require('lib.core.types.Object')
local Map = require('lib.core.types.Map')
local Vector = require('lib.logic.model.spatial.Vector')

local Position = Object.new_class()

-- epsilon?

local function is_standard_position(obj)
    if obj.x ~= nil and obj.y ~= nil then return true end
    return false
end

local function is_simplified_position(obj)
    if obj[1] ~= nil and obj[2] ~= nil then return true end
    return false
end

function Position.is_position(obj)
    return is_standard_position(obj) or is_simplified_position(obj)
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
    x = tonumber(x)
    assert(type(x) == "number", "x is not a number")
    if is_standard_position(self) then self.x = x return end
    if is_simplified_position(self) then self[1] = x return end
end
function Position:set_y(y)
    assert(Position.is_position(self), "tried to set-y of non-position object with position class")
    y = tonumber(y)
    assert(type(y) == "number", "y is not a number")
    if is_standard_position(self) then self.y = y return end
    if is_simplified_position(self) then self[2] = y return end
end

function Position.new(x, y)
    x = tonumber(x)
    y = tonumber(y)
    assert(type(x) == "number", "x is not a number")
    assert(type(y) == "number", "y is not a number")
    
    local newObject = {x = x, y = y}
    
    return Object.instantiate(newObject, Position)
end

function Position:as_vector_from_origin()
    return Vector.new(self:get_x(), self:get_y())
end

function Position.origin()
    return Position.new(0,0)
end

function Position:copy()
    assert(self:is_position(), "Tried to Position.copy a non-position object")
    return Position.new(Position.get_x(self), Position.get_y(self))
end

function Position.from_table(obj)
    assert(Position.is_position(obj), "Cannot instantiate " .. Map.to_string(obj) .. " as Position.")
    return Position.new(Position.get_x(obj), Position.get_y(obj))
end

local function is_valid_type_for_addition(obj)
    return Vector.is_vector(obj) or Position.is_position(obj)
end

function Position:add(obj)
    assert(self:is_position(), "tried to add to non-position object with position class")
    assert(is_valid_type_for_addition(obj), "tried to add invalid object to position")
    local new_x = self:get_x() + obj:get_x()
    local new_y = self:get_y() + obj:get_y()
    return Position.new(new_x, new_y)
end

function Position:subtract(obj)
    assert(self:is_position(), "tried to subtract from non-position object with position class")
    assert(is_valid_type_for_addition(obj), "tried to subtract invalid object to position")
    local new_x = self:get_x() - obj:get_x()
    local new_y = self:get_y() - obj:get_y()
    return Position.new(new_x, new_y)
end

-- tostring?
-- equals?
-- hashcode???

return Position