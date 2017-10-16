local Object = {}

local function is_instatiated()
    return false
end

Object.is_instatiated = is_instatiated

local function assert_instance(obj)
    assert(obj ~= nil, "Tried to call a method on nil or class.")
    result = obj:is_instatiated()
    assert(result ~= nil, "method 'is_instantiated' returned a nil result from object")
    if not result then error("Tried to call object method on class") end
end

Object.assert_instance = assert_instance

local function assert_class(obj)
    assert(obj ~= nil, "Tried to call a method on nil.")
    result = obj:is_instatiated()
    assert(result ~= nil, "method 'is_instantiated' returned a nil result from object")
    if result then error("Tried to call class method on object") end
end

Object.assert_class = assert_class

return Object