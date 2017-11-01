local Object = {}

function Object:is_lua_object()
    return self ~= nil and type(self) == "table" and type(self.__self) == "userdata"
end

local do_nothing = function() end

function Object.new()
    error("Error: tried to instantiate an abstract or utility class.")
end

function Object.is_instatiated()
    return false
end

function Object.extends(child, parent)
    child.parent = parent
    return setmetatable(child, {__index = parent})
end

function Object.new_class(type)
    local newclass = {}
    newclass.type = type
    return Object.extends(newclass, Object)
end

local function instance_wrapper(classobject)
    local wrapper = {}
    wrapper.is_instatiated = function() return true end
    return Object.extends(wrapper, classobject)
end

function Object.instantiate(obj, classobject)
    return setmetatable(obj, {__index = instance_wrapper(classobject), __call = do_nothing})
end

function Object:assert_instance()
    assert(self ~= nil, "Tried to call a method on nil or class.")
    -- assert table?!?
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

function Object:to_string()
    if type(self) ~= "table" then return tostring(self) end
    local stringy = ""
    if(self.type ~= nil)then
        stringy = stringy .. self.type .. ":"
    end
    stringy = stringy .. "{"
    for k, v in pairs(self) do
        stringy = stringy .. Object.to_string(k) .. ' = \"' .. Object.to_string(v) .. '",'
    end
    stringy = stringy:sub(1,-2) .. "}"
    
    return stringy
end

return Object