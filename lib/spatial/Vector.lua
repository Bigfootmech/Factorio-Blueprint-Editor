local Object = require 'lib.lua_enhance.Object'

local Vector = {}

-- epsilon?

function new(x, y)
    assert(type(x) == "number", "x is not a number")
    assert(type(y) == "number", "y is not a number")
    return setmetatable({x, y}, Vector)
end

Vector.new = new

function up_vector()
    return Vector:new(0,1)
end
function Vector:down_vector()
    return Vector:new(0,-1)
end
function Vector:left_vector()
    return Vector:new(-1, 0)
end
function Vector:right_vector()
    return Vector:new(1, 0)
end

Vector.up_vector = up_vector
Vector.down_vector = down_vector
Vector.left_vector = left_vector
Vector.right_vector = right_vector

function is_vector(obj)
    if obj[1] ~= nil and obj[2] ~= nil then return true end
    return false
end

Vector.is_vector = is_vector

function is_instatiated()
    return Vector:is_vector(self)
end

function get_x()
    Object:assert_instance(self)
    return self[1]
end
function get_y()
    Object:assert_instance(self)
    return self[2]
end
function set_x(x)
    Object:assert_instance(self)
    self[1] = x
end
function set_y(y)
    Object:assert_instance(self)
    self[2] = y
end

Vector.get_x = get_x
Vector.get_y = get_y
Vector.set_x = set_x
Vector.set_y = set_y

-- addition?

function get_magnitude()
    Object:assert_instance(self)
    return math.sqrt(self:get_x()^2 + self:get_y()^2)
end

function multiply_magnitude(mag)
    Object:assert_instance(self)
    assert(type(mag) == "number", "Magnitude multiplication must be a number")
    self:set_x(self:get_x() * mag)
    self:set_y(self:get_y() * mag)
    return self
end
function divide_magnitude(mag)
    Object:assert_instance(self)
    assert(type(mag) == "number", "Magnitude division must be a number")
    self:set_x(self:get_x() / mag)
    self:set_y(self:get_y() / mag)
    return self
end

Vector.multiply = multiply_magnitude
Vector.divide = divide_magnitude

function make_unit_vector()
    self:divide_magnitude(self:get_magnitude())
    return self
end

-- dot product?
-- cross product?
-- box product?

-- tostring?
-- equals?
-- hashcode???

return Vector