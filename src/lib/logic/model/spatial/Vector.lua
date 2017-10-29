local Object = require('lib.core.types.Object')

local Vector = Object.new_class()

-- epsilon?

local function is_vector(obj)
    if(type(obj) ~= "table")then
        --log.debug("Object " .. tostring(obj) .. " was not a table, and therefore not a vector."
        return false
    end
    if(type(obj[1]) ~= "number")then 
        --log.debug("Object field 1 " .. tostring(obj[1]) .. " was not a number, and therefore not a vector."
        return false
    end
    if(type(obj[2]) ~= "number")then 
        --log.debug("Object field 1 " .. tostring(obj[2]) .. " was not a number, and therefore not a vector."
        return false
    end
    return true
end
Vector.is_vector = is_vector

local function get_x(self)
    assert(is_vector(self), "Can only use this method on a vector")
    return self[1]
end
Vector.get_x = get_x

local function get_y(self)
    assert(is_vector(self), "Can only use this method on a vector")
    return self[2]
end
Vector.get_y = get_y

local function set_x(self, x)
    assert(is_vector(self), "Can only use this method on a vector")
    self[1] = x
end
Vector.set_x = set_x

local function set_y(self, y)
    assert(is_vector(self), "Can only use this method on a vector")
    self[2] = y
end
Vector.set_y = set_y

function Vector.new(x, y)
    assert(type(x) == "number", "x is not a number")
    assert(type(y) == "number", "y is not a number")
    local newObject = {x, y}
    -- is_vector_raw ?? (and then in "is vector", do pcall???
    
    return Object.instantiate(newObject, Vector)
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
    local new_x = get_x(self) + get_x(other)
    local new_y = get_y(self) + get_y(other)
    return Vector.new(new_x, new_y)
end

function Vector:subtract(other)
    assert(is_vector(self), "Can only use this method on a vector")
    assert(is_vector(other), "Can only add vectors to vectors")
    local new_x = get_x(self) - get_x(other)
    local new_y = get_y(self) - get_y(other)
    return Vector.new(new_x, new_y)
end

function Vector:get_inverse()
    return Vector.zero:subtract(self)
end

function Vector:multiply(mag)
    assert(is_vector(self), "Can only use this method on a vector")
    assert(type(mag) == "number", "Magnitude multiplication must be a number")
    local new_x = get_x(self) * mag
    local new_y = get_y(self) * mag
    return Vector.new(new_x, new_y)
end

function Vector:divide(mag)
    assert(is_vector(self), "Can only use this method on a vector")
    assert(type(mag) == "number", "Magnitude division must be a number")
    local new_x = get_x(self) / mag
    local new_y = get_y(self) / mag
    return Vector.new(new_x, new_y)
end

function Vector.magnitude(self)
    assert(is_vector(self), "Can only use this method on a vector")
    return math.sqrt(get_x(self)^2 + get_y(self)^2)
end

function Vector.get_unit_vector(self)
    assert(is_vector(self), "Can only use this method on a vector")
    return self:divide(self:magnitude())
end

-- dot product?
-- cross product?
-- box product?

-- tostring?
-- equals?
-- hashcode???

return Vector