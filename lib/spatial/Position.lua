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

local Object = require 'lib.lua_enhance.Object'
local Vector = require 'lib.spatial.Vector'

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

function copy(obj)
    Position.is_position(obj)
    return Position.new(obj.get_x(), obj.get_y())
end

Position.copy = copy

function Position:is_instatiated()
    return is_position(self)
end

function Position:get_x()
    Object.assert_instance(self)
    if is_standard_position(self) then return self.x end
    if is_simplified_position(self) then return self[1] end
end
function Position:get_y()
    Object.assert_instance(self)
    if is_standard_position(self) then return self.y end
    if is_simplified_position(self) then return self[2] end
end
function Position:set_x(x)
    Object.assert_instance(self)
    if is_standard_position(self) then self.x = x return end
    if is_simplified_position(self) then self[1] = x return end
end
function Position:set_y(y)
    Object.assert_instance(self)
    if is_standard_position(self) then self.y = y return end
    if is_simplified_position(self) then self[2] = y return end
end

local function is_valid_type_for_addition(obj)
    return Vector.is_vector(obj) | Position.is_position(obj)
end

function Position:add(obj)
    Object.assert_instance(self)
    assert(is_valid_type_for_addition(obj), "tried to add invalid object to position")
    self:set_x(self:get_x() + obj:get_x())
    self:set_y(self:get_y() + obj:get_y())
    return self
end

function Position:subtract(vector)
    Object.assert_instance(self)
    assert(is_valid_type_for_addition(obj), "tried to subtract invalid object to position")
    self:set_x(self:get_x() - obj:get_x())
    self:set_y(self:get_y() - obj:get_y())
    return self
end

-- tostring?
-- equals?
-- hashcode???

return Position