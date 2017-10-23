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

local function is_instatiated(self)
    return is_vector(self)
end
Vector.is_instatiated = is_instatiated

local function new(x, y)
    assert(type(x) == "number", "x is not a number")
    assert(type(y) == "number", "y is not a number")
    local newObject = {x, y}
    -- is_vector_raw ?? (and then in "is vector", do pcall???
    return setmetatable(newObject, Vector)
end
Vector.new = new

local function zero()
    return Vector.new(0, 0)
end
local function up()
    return Vector.new(0,-1)
end
local function down()
    return Vector.new(0,1) -- coordinates are from top left of screen
end
local function left()
    return Vector.new(-1, 0)
end
local function right()
    return Vector.new(1, 0)
end

Vector.zero = zero
Vector.up = up
Vector.down = down
Vector.left = left
Vector.right = right

local function get_x(self)
    is_vector(self)
    return self[1]
end
Vector.get_x = get_x

local function get_y(self)
    is_vector(self)
    return self[2]
end
Vector.get_y = get_y

local function set_x(self, x)
    is_vector(self)
    self[1] = x
end
Vector.set_x = set_x

local function set_y(self, y)
    is_vector(self)
    self[2] = y
end
Vector.set_y = set_y

-- addition?

local function magnitude(self)
    is_vector(self)
    return math.sqrt(get_x(self)^2 + get_y(self)^2)
end
Vector.magnitude = magnitude

local function multiply(self, mag)
    is_vector(self)
    assert(type(mag) == "number", "Magnitude multiplication must be a number")
    set_x(self, get_x(self) * mag)
    set_y(self, get_y(self) * mag)
    return self
end
Vector.multiply = multiply

local function divide(self, mag)
    is_vector(self)
    assert(type(mag) == "number", "Magnitude division must be a number")
    set_x(self, get_x(self) / mag)
    set_y(self, get_y(self) / mag)
    return self
end
Vector.divide = divide

local function make_unit_vector(self)
    is_vector(self)
    Vector.divide(self, magnitude(self))
    return self
end
Vector.make_unit_vector = make_unit_vector

-- dot product?
-- cross product?
-- box product?

-- tostring?
-- equals?
-- hashcode???

return Vector