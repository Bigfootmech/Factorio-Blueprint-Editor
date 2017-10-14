local Object = require 'lib/Object'
local Vector = require 'lib/Vector'

Position = {}
Position.__index = Object

-- epsilon?

function Position:new(x, y)
    assert(type(x) == "number", "x is not a number")
    assert(type(y) == "number", "y is not a number")
    return setmetatable({x = x, y = y}, Position)
end

function Position:is_position(obj)
    if obj.x ~= nil and obj.x ~= nil then return true end
    if obj[1] ~= nil and obj[2] ~= nil then return true end
    return false
end

function Position:is_instatiated()
    return Position:is_position(self)
end

function Position:copy()
    self:assert_instance()
    return Position:new(self.x, self.y)
end

function Position:add(vector)
    self:assert_instance()
    if not Vector:is_vector(vector) error("tried to add invalid object to position") end
    (self.x, self.y)
    return self
end

function Position:subtract(vector)
    self:assert_instance()
    if not Vector:is_vector(vector) error("tried to subrtact invalid object to position") end
    return (self.x, self.y)
end

-- local vec = Vector:new(0, 1) -- Create a vector
-- print(vec:magnitude())          -- Call a method (output: 1)
-- print(vec[1])                    -- Access a member variable (output: 0)