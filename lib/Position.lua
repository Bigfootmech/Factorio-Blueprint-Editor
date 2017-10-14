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

require 'lib/Object'
require 'lib/Vector'

Position = {}
Position.__index = Position

-- epsilon?

function Position:new(x, y)
    assert(type(x) == "number", "x is not a number")
    assert(type(y) == "number", "y is not a number")
    return setmetatable({x = x, y = y}, Position)
end

function Position:is_standard_position(obj)
    if obj.x ~= nil and obj.x ~= nil then return true end
    return false
end

function Position:is_simplified_position(obj)
    if obj[1] ~= nil and obj[2] ~= nil then return true end
    return false
end


function Position:is_position(obj)
    return Position:is_standard_position(obj) or Position:is_simplified_position(obj)
end

function Position:is_instatiated()
    return Position:is_position(self)
end

function Position:get_x()
    Object:assert_instance(self)
    if Position:is_standard_position(self) then return self.x end
    if Position:is_simplified_position(self) then return self[1] end
end

function Position:get_y()
    Object:assert_instance(self)
    if Position:is_standard_position(self) then return self.y end
    if Position:is_simplified_position(self) then return self[2] end
end

function Position:set_x(x)
    Object:assert_instance(self)
    if Position:is_standard_position(self) then self.x = x return end
    if Position:is_simplified_position(self) then self[1] = x return end
end

function Position:set_y(y)
    Object:assert_instance(self)
    if Position:is_standard_position(self) then self.y = y return end
    if Position:is_simplified_position(self) then self[2] = y return end
end

function Position:copy()
    Object:assert_instance(self)
    return Position:new(self:get_x, self:get_y)
end

function Position:is_valid_type_for_addition(obj)
    return Vector:is_vector(obj) | Position:is_position(obj)
end

function Position:add(obj)
    Object:assert_instance(self)
    assert(Position:is_valid_type_for_addition(obj), "tried to add invalid object to position")
    self:set_x(self:get_x + obj:get_x)
    self:set_y(self:get_y + obj:get_y)
    return self
end

function Position:subtract(vector)
    Object:assert_instance(self)
    assert(Position:is_valid_type_for_addition(obj), "tried to subtract invalid object to position")
    self:set_x(self:get_x - obj:get_x)
    self:set_y(self:get_y - obj:get_y)
    return self
end

-- tostring?
-- equals?
-- hashcode???

-- local vec = Vector:new(0, 1) -- Create a vector
-- print(vec:magnitude())          -- Call a method (output: 1)
-- print(vec[1])                    -- Access a member variable (output: 0)