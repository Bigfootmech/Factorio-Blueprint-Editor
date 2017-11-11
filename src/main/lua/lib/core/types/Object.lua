local Object = {}

local TYPE_NAME_FIELD = "type_name"

local DO_NOTHING = function() end

function Object:is_lua_object()
    return self ~= nil and type(self) == "table" and type(self.__self) == "userdata"
end

function Object:is_type(type_name)
    if(type(self) ~= "table")then
        return false
    end
    return self[TYPE_NAME_FIELD] == type_name or Object.is_type(self.parent, type_name)
end

function Object:parent()
    if(type(self) ~= "table")then
        error("Cannot get parent of non-object.")
    end -- special case for reaching Object?
    return getmetatable(self).__index
end

function Object.new()
    error("Error: tried to instantiate an abstract or utility class.")
end

function Object:is_instatiated()
    return getmetatable(self).__instantiated
end

function Object:add_metamethod(method_name, function_call)
    -- check is valid metamethod name?
    local mt = getmetatable(self)
    mt[method_name] = function_call
end

local function fetch_or_create_generic(parent_class, handling_type_name, ...)
    if(parent_class.generic_classes == nil)then
        parent_class.generic_classes = {}
    end
    local generic_class = parent_class.generic_classes[handling_type_name]
    if(generic_class ~= nil)then
        return generic_class
    end
    
    local generic_type = parent_class.type_name .."<" .. handling_type_name .. ">"
    local generic_class = Object.extends(parent_class, generic_type)
    generic_class.generic_type_name = handling_type_name
    generic_class.new = function(...) 
        return Object.instantiate(parent_class.new(...), generic_class)
    end
    generic_class.from_table = function(some_table) 
        generic_class:verify_generic(some_table) 
        return Object.instantiate(parent_class.from_table(some_table), generic_class)
    end
    
    parent_class.generic_classes[handling_type_name] = generic_class
    
    return generic_class
end

function Object:allow_generics()
    self:add_metamethod("__call", fetch_or_create_generic)
end

function Object.extends(parent, type_name)
    local newclass = {}
    newclass[TYPE_NAME_FIELD] = type_name
    return setmetatable(newclass, {__index = parent})
end

function Object.new_class(type_name)
    local newclass = Object.extends(Object)
    newclass[TYPE_NAME_FIELD] = type_name
    return newclass
end

function Object.instantiate(obj, classobject, function_metatable)
    function_metatable = function_metatable or {}
    function_metatable.__index = classobject
    function_metatable.__call = DO_NOTHING
    function_metatable.__instantiated = true
    return setmetatable(obj, function_metatable)
end

function Object:shallowcopy()
    if type(self) ~= "table" then return self end
    local copy = {}
    
    for k, v in next, self, nil do
        copy[k] = v
    end
    
    return copy
end

function Object:copy()
    if type(self) ~= "table" then return self end
    local copy = {}
    
    for k, v in next, self, nil do
        copy[Object.copy(k)] = Object.copy(v)
    end
    
    return copy
end

function Object:deepcopy()
    if type(self) ~= "table" then return self end
    local copy = {}
    
    for k, v in next, self, nil do
        copy[Object.deepcopy(k)] = Object.deepcopy(v)
    end
    setmetatable(copy, Object.deepcopy(getmetatable(self)))
    
    return copy
end

function Object:to_string()
    if type(self) ~= "table" then return tostring(self) end
    local stringy = ""
    if(self.type ~= nil)then
        stringy = stringy .. self.type .. ":"
    end
    stringy = stringy .. "{"
    for k, v in pairs(self) do
        stringy = stringy .. Object.to_string(k) .. ' = "' .. Object.to_string(v) .. '",'
    end
    stringy = stringy:sub(1,-2) .. "}"
    
    return stringy
end

function Object:as_json()
    if(type(self) ~= "table")then 
        return tostring(self) 
    end
    if(self.type ~= "Map" or self.type ~= "List")then 
        return tostring(self) 
    end
    
    return self:as_json()
end

return Object