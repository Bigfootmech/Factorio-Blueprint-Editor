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
local Math = require('lib.core.Math')
local Map = require('lib.core.types.Map')
local Vector = require('lib.logic.model.spatial.Vector')

local Self = Object.new_class("Position")
local function_metatable = {}

-- epsilon?

local function is_standard_position(obj)
    if(type(obj) ~= "table")then
        return false
    end
    if(obj.x == nil)then
        return false
    end
    if(obj.y == nil)then 
        return false 
    end
    return true
end

local function is_simplified_position(obj)
    if(type(obj) ~= "table")then
        return false
    end
    if(obj[1] == nil)then
        return false
    end
    if(obj[2] == nil)then 
        return false 
    end
    return true
end

function Self.is_position(obj)
    return is_standard_position(obj) or is_simplified_position(obj)
end

function Self:get_x()
    assert(Self.is_position(self), "tried to get-x of non-position object with position class") -- can standardize these
    if is_standard_position(self) then return self.x end
    if is_simplified_position(self) then return self[1] end
end
function Self:get_y()
    assert(Self.is_position(self), "tried to get-y of non-position object with position class")
    if is_standard_position(self) then return self.y end
    if is_simplified_position(self) then return self[2] end
end
function Self:set_x(x)
    assert(Self.is_position(self), "tried to set-x of non-position object with position class")
    x = tonumber(x)
    assert(type(x) == "number", "x is not a number")
    if is_standard_position(self) then self.x = x return end
    if is_simplified_position(self) then self[1] = x return end
end
function Self:set_y(y)
    assert(Self.is_position(self), "tried to set-y of non-position object with position class")
    y = tonumber(y)
    assert(type(y) == "number", "y is not a number")
    if is_standard_position(self) then self.y = y return end
    if is_simplified_position(self) then self[2] = y return end
end

function Self.new(x, y)
    x = tonumber(x)
    y = tonumber(y)
    assert(type(x) == "number", "x is not a number")
    assert(type(y) == "number", "y is not a number")
    
    local newObject = {x = x, y = y}
    
    return Object.instantiate(newObject, Self, function_metatable)
end

function Self.from_vector(vector)
    return Self.new(vector:get_x(), vector:get_y())
end

function Self:as_vector_from_origin()
    return Vector.new(self:get_x(), self:get_y())
end

function Self.origin()
    return Self.new(0,0)
end

function Self:copy()
    assert(self:is_position(), "Tried to Position.copy a non-position object")
    return Self.new(Self.get_x(self), Self.get_y(self))
end

function Self.from_table(obj)
    assert(Self.is_position(obj), "Cannot instantiate " .. Map.to_string(obj) .. " as Position.")
    return Self.new(Self.get_x(obj), Self.get_y(obj))
end

local function is_valid_type_for_addition(obj)
    return Vector.is_vector(obj) or Self.is_position(obj)
end

function Self:add(obj)
    assert(self:is_position(), "tried to add to non-position object with position class")
    assert(is_valid_type_for_addition(obj), "tried to add invalid object to position")
    local new_x = self:get_x() + obj:get_x()
    local new_y = self:get_y() + obj:get_y()
    return Self.new(new_x, new_y)
end

function Self:subtract(obj)
    assert(self:is_position(), "tried to subtract from non-position object with position class")
    assert(is_valid_type_for_addition(obj), "tried to subtract invalid object to position")
    local new_x = self:get_x() - obj:get_x()
    local new_y = self:get_y() - obj:get_y()
    return Self.new(new_x, new_y)
end


function Self:half_floor()
    assert(self:is_position(), "Can't do this operation on non-position")
    
    return Self.new(Math.half_floor(self:get_x()), Math.half_floor(self:get_y()))
end

function Self:half_ceil()
    assert(self:is_position(), "Can't do this operation on non-position")
    
    return Self.new(Math.half_ceil(self:get_x()), Math.half_ceil(self:get_y()))
end

function_metatable.__add = function( ... )
    return Self.add( ... )
end

function_metatable.__sub = function( ... )
    return Self.subtract( ... )
end

-- tostring?
-- equals?
-- hashcode???

return Self