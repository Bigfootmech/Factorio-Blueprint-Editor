Object = {}
Object.__index = Object

function Object:is_instatiated()
    return false
end

function Object:assert_instance(obj)
    assert(obj ~= nil, "Tried to call a method on nil.")
    result = obj:is_instatiated()
    assert(result ~= nil, "method 'is_instantiated' returned a nil result from object")
    if not result then error("Tried to call object method on class") end
end

function Object:assert_class(obj)
    assert(obj ~= nil, "Tried to call a method on nil.")
    result = obj:is_instatiated()
    assert(result ~= nil, "method 'is_instantiated' returned a nil result from object")
    if result then error("Tried to call class method on object") end
end
