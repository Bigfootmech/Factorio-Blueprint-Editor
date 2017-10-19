local Object = require('lib.lua_enhance.Object')

local Vector = {}
Vector.__index = Vector

-- epsilon?

local function new(x, y)
    assert(type(x) == "number", "x is not a number")
    assert(type(y) == "number", "y is not a number")
    return setmetatable({x, y}, Vector)
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

local function from_direction(direction_name)
    assert(type(direction_name) == "string", "A direction name must be a string.")
    local formatted_direction_name = string.lower(direction_name)
    if(formatted_direction_name == "up") then
        return Vector.up()
    end
    if(formatted_direction_name == "down") then
        return Vector.down()
    end
    if(formatted_direction_name == "left") then
        return Vector.left()
    end
    if(formatted_direction_name == "right") then
        return Vector.right()
    end
    error("Direction ' " .. direction_name .. " ' not found.")
end
Vector.from_direction = from_direction

local function is_vector(obj)
    assert(type(obj) == "table", "A vector must be a table.")
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
    is_vector(self)
    return math.sqrt(self:get_x()^2 + self:get_y()^2)
end

function Vector:multiply(mag)
    is_vector(self)
    assert(type(mag) == "number", "Magnitude multiplication must be a number")
    self:set_x(self:get_x() * mag)
    self:set_y(self:get_y() * mag)
    return self
end
function Vector:divide(mag)
    is_vector(self)
    assert(type(mag) == "number", "Magnitude division must be a number")
    self:set_x(self:get_x() / mag)
    self:set_y(self:get_y() / mag)
    return self
end

function Vector:make_unit_vector()
    is_vector(self)
    self:divide(self:magnitude())
    return self
end

-- dot product?
-- cross product?
-- box product?

-- tostring?
-- equals?
-- hashcode???

return Vector