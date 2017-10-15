require 'lib.lua_enhance.Object'

Vector = {}
Vector.__index = Vector

-- epsilon?

function Vector:new(x, y)
    assert(type(x) == "number", "x is not a number")
    assert(type(y) == "number", "y is not a number")
    return setmetatable({x, y}, Vector)
end

function Vector:up_vector()
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

function Vector:is_vector(obj)
    if obj[1] ~= nil and obj[2] ~= nil then return true end
    return false
end

function Vector:is_instatiated()
    return Vector:is_vector(self)
end

function Vector:get_x()
    Object:assert_instance(self)
    return self[1]
end

function Vector:get_y()
    Object:assert_instance(self)
    return self[2]
end

function Vector:set_x(x)
    Object:assert_instance(self)
    self[1] = x
end

function Vector:set_y(y)
    Object:assert_instance(self)
    self[2] = y
end

-- addition?

function Vector:get_magnitude()
    Object:assert_instance(self)
    return math.sqrt(self:get_x^2 + self:get_y^2)
end

function Vector:multiply_magnitude(mag)
    Object:assert_instance(self)
    assert(type(mag) == "number", "Magnitude multiplication must be a number")
    self:set_x(self:get_x * mag)
    self:set_y(self:get_y * mag)
    return self
end

function Vector:divide_magnitude(mag)
    Object:assert_instance(self)
    assert(type(mag) == "number", "Magnitude division must be a number")
    self:set_x(self:get_x / mag)
    self:set_y(self:get_y / mag)
    return self
end

function Vector:make_unit_vector()
    self:divide_magnitude(self:get_magnitude())
    return self
end

-- dot product?
-- cross product?
-- box product?

-- tostring?
-- equals?
-- hashcode???

-- test bed?
-- vec = Vector:new(0, 1) -- Create a vector
-- print(vec:is_instatiated())     -- Is vector instantiated? (output: true)
-- print(vec:get_magnitude())          -- Call a method (output: 1)
-- print(vec[1])                    -- Access a member variable (output: 0)
-- print(vec[2])                    -- Access a member variable (output: 1)
-- print(Vector:is_vector(vec)) -- true
-- print(Vector:is_vector({1,2})) -- true
-- print(Vector:is_vector({1})) -- false
-- print(Vector:is_vector({1,2,3})) -- true