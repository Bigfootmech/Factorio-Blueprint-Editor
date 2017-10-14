local Object = require 'lib/Object'

Vector = Object:new()

-- epsilon?

function Vector:new(x, y)
    return setmetatable({x, y}, Vector)
end

function Vector:is_vector(obj)
    if obj[1] ~= nil and obj[2] ~= nil then return true end
    return false
end

function Vector:is_instatiated()
    return Vector:is_vector(self)
end

function Vector:magnitude()
    return math.sqrt(self[1]^2 + self[2]^2)
end

-- tostring?
-- equals?
-- hashcode???

-- test bed?
local vec = Vector:new(0, 1) -- Create a vector
print(vec:magnitude())          -- Call a method (output: 1)
print(vec[1])                    -- Access a member variable (output: 0)
print(vec[2])                    -- Access a member variable (output: 1)
print(Vector:is_vector(vec))
print(Vector:is_vector({1,2}))
print(Vector:is_vector({1}))
print(Vector:is_vector({1,2,3}))