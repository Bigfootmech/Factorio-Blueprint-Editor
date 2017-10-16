local Object = require 'lib.lua_enhance.Object'

local Vector = {}

Vector.__index = Vector

-- epsilon?

local function new(x, y)
    assert(type(x) == "number", "x is not a number")
    assert(type(y) == "number", "y is not a number")
    return setmetatable({x, y}, Vector)
end

Vector.new = new

local function up()
    return Vector.new(0,1)
end
local function down()
    return Vector.new(0,-1)
end
local function left()
    return Vector.new(-1, 0)
end
local function right()
    return Vector.new(1, 0)
end

Vector.up = up
Vector.down = down
Vector.left = left
Vector.right = right

local function is_vector(obj)
    if obj[1] ~= nil and obj[2] ~= nil then return true end
    return false
end

Vector.is_vector = is_vector

function Vector:is_instatiated()
    return Vector.is_vector(self)
end

function Vector:get_x()
    Object.assert_instance(self)
    return self[1]
end
function Vector:get_y()
    Object.assert_instance(self)
    return self[2]
end
function Vector:set_x(x)
    Object.assert_instance(self)
    self[1] = x
end
function Vector:set_y(y)
    Object.assert_instance(self)
    self[2] = y
end

-- addition?

function Vector:magnitude()
    Object.assert_instance(self)
    return math.sqrt(self:get_x()^2 + self:get_y()^2)
end

function multiply_magnitude(mag)
    Object.assert_instance(self)
    assert(type(mag) == "number", "Magnitude multiplication must be a number")
    self:set_x(self:get_x() * mag)
    self:set_y(self:get_y() * mag)
    return self
end
function divide_magnitude(mag)
    Object.assert_instance(self)
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