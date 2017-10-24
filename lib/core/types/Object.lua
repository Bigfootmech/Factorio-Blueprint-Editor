local Object = {}

function Object.new_class()
    local newclass = {}
    newclass.__index = newclass
    return newclass
end

function Object.extends(child, parent)
    child.parent = parent
    return setmetatable(child, {__index = parent})
end

function Object.instantiate(obj, classname)
    return setmetatable(obj, {__index = classname}) -- search for any actual metafunctions, and move them?
end

function Object:is_lua_object()
    return self ~= nil and type(self) == "table" and type(self.__self) == "userdata"
end

local function is_instatiated()
    return false
end
Object.is_instatiated = is_instatiated

function Object:assert_instance()
    assert(self ~= nil, "Tried to call a method on nil or class.")
    local is_instantiated = self:is_instatiated()
    assert(is_instantiated ~= nil, "method 'is_instantiated' returned a nil result from object")
    if not is_instantiated then error("Tried to call object method on class") end
end

function Object:assert_class()
    assert(self ~= nil, "Tried to call a method on nil.")
    local is_instantiated = self:is_instatiated()
    assert(is_instantiated ~= nil, "method 'is_instantiated' returned a nil result from object")
    if is_instantiated then error("Tried to call class method on object") end
end

return Object