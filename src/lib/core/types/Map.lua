local Object = require('lib.core.types.Object')

local Map = Object.new_class("Map")

function Map.new()
    return Object.instantiate({},Map)
end

function Map:size()
    assert(type(self) == "table", "Cannot get size of a non-table.")
    local count = 0
    for _, _ in pairs(self) do
        count = count + 1
    end
    return count
end

function Map:keys()
    assert(type(self) == "table", "Cannot get keys of a non-table.")
    local keys = {}
    for k, _ in pairs(self) do
        table.insert(keys,k)
    end
    return keys
end

function Map:has_key(key)
    assert(type(self) == "table", "Cannot get keys of a non-table.")
    return self.key ~= nil
end

function Map:values()
    assert(type(self) == "table", "Cannot get values of a non-table.")
    local values = {}
    for _, v in pairs(self) do
        table.insert(values,v)
    end
    return values
end

function Map:has_value(value)
    assert(type(self) == "table", "Cannot get values of a non-table.")
    for _, v in pairs(self) do
        if(v == value)then
            return true
        end
    end
    return false
end

function Map:insert(key, value)
    assert(type(self) == "table", "Cannot insert to a non-table.")
    assert(key ~= nil, "Cannot insert nil key.")
    assert(value ~= nil, "Cannot insert nil value (use remove instead).")
    
    self[key] = value
    
    return self
end

function Map:insert_all(table)
    assert(type(self) == "table", "Cannot insert all to a non-table.")
    assert(type(table) == "table", "Cannot insert all of a non-table.")
    
    for k,v in pairs(table) do self[k] = v end
    return self
end

function Map:remove(key)
    assert(type(self) == "table", "Cannot remove from a non-table.")
    assert(key ~= nil, "Cannot remove nil key.")
    
    self[key] = nil
    
    return self
end

function Map:as_json()
    if type(self) ~= "table" then return tostring(self) end
    local stringy = "{"
    for k, v in pairs(self) do
        stringy = stringy ..'"' .. Object.as_json(k) .. '": "' .. Object.as_json(v) .. '",'
    end
    stringy = stringy:sub(1,-2) .. "}"
    
    return stringy
end

return Map