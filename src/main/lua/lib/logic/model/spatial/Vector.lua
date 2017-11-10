local Object = require('lib.core.types.Object')

local Vector = Object.new_class()
local function_metatable = {}

-- epsilon?

local function is_vector(obj)
    if(type(obj) ~= "table")then
        --log.debug("Object " .. tostring(obj) .. " was not a table, and therefore not a vector."
        return false
    end
    if(type(tonumber(obj[1])) ~= "number")then 
        --log.debug("Object field 1 " .. tostring(obj[1]) .. " was not a number, and therefore not a vector."
        return false
    end
    if(type(tonumber(obj[2])) ~= "number")then 
        --log.debug("Object field 1 " .. tostring(obj[2]) .. " was not a number, and therefore not a vector."
        return false
    end
    return true
end
Vector.is_vector = is_vector

function Vector:get_x()
    assert(is_vector(self), "Can only use this method on a vector")
    return self[1]
end

function Vector:get_y()
    assert(is_vector(self), "Can only use this method on a vector")
    return self[2]
end

function Vector:set_x(x)
    assert(is_vector(self), "Can only use this method on a vector")
    x = tonumber(x)
    assert(type(x) == "number", "x is not a number")
    self[1] = x
end

function Vector:set_y(y)
    assert(is_vector(self), "Can only use this method on a vector")
    y = tonumber(y)
    assert(type(y) == "number", "y is not a number")
    self[2] = y
end

function Vector.new(x, y)
    x = tonumber(x)
    y = tonumber(y)
    assert(type(x) == "number", "x is not a number")
    assert(type(y) == "number", "y is not a number")
    local newObject = {x, y}
    -- is_vector_raw ?? (and then in "is vector", do pcall???
    
    return Object.instantiate(newObject, Vector, function_metatable)
end

function Vector.from_table(some_table)
    assert(type(some_table) == "table", "cannot instantiate vector from non-table")
    assert(#some_table == 2, "vector must be size 2")
    assert(type(some_table[1]) == "number", "x is not a number")
    assert(type(some_table[2]) == "number", "y is not a number")
    
    return Object.instantiate(some_table, Vector, function_metatable)
end

function Vector.zero()
    return Vector.new(0, 0)
end
function Vector.up()
    return Vector.new(0,-1) -- coordinates are from top left of screen
end
function Vector.down()
    return Vector.new(0,1) -- coordinates are from top left of screen
end
function Vector.left()
    return Vector.new(-1, 0)
end
function Vector.right()
    return Vector.new(1, 0)
end

function Vector:add(other)
    assert(is_vector(self), "Can only use this method on a vector")
    assert(is_vector(other), "Can only add vectors to vectors")
    local new_x = self:get_x() + other:get_x()
    local new_y = self:get_y() + other:get_y()
    return Vector.new(new_x, new_y)
end

function Vector:subtract(other)
    assert(is_vector(self), "Can only use this method on a vector")
    assert(is_vector(other), "Can only add vectors to vectors")
    local new_x = self:get_x() - other:get_x()
    local new_y = self:get_y() - other:get_y()
    return Vector.new(new_x, new_y)
end

function Vector:get_inverse()
    return Vector.zero():subtract(self)
end

function Vector:multiply(mag)
    assert(is_vector(self), "Can only use this method on a vector")
    assert(type(mag) == "number", "Magnitude multiplication must be a number")
    local new_x = self:get_x() * mag
    local new_y = self:get_y() * mag
    return Vector.new(new_x, new_y)
end

function Vector:divide(mag)
    assert(is_vector(self), "Can only use this method on a vector")
    assert(type(mag) == "number", "Magnitude division must be a number")
    local new_x = self:get_x() / mag
    local new_y = self:get_y() / mag
    return Vector.new(new_x, new_y)
end

function Vector:magnitude()
    assert(is_vector(self), "Can only use this method on a vector")
    return math.sqrt(self:get_x()^2 + self:get_y()^2)
end

function Vector:get_unit_vector()
    assert(is_vector(self), "Can only use this method on a vector")
    return self:divide(self:magnitude())
end

function_metatable.__add = function( ... )
    return Vector.add( ... )
end

function_metatable.__sub = function( ... )
    return Vector.subtract( ... )
end

function_metatable.__mul = function( ... )
    return Vector.multiply( ... )
end

function_metatable.__div = function( ... )
    return Vector.divide( ... )
end

function_metatable.__unm = function( vector )
    return Vector.get_inverse( vector )
end

-- dot product?
-- cross product?
-- box product?

-- tostring?
-- equals?
-- hashcode???

return Vector