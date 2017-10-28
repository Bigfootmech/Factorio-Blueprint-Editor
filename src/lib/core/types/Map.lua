local Map = {}

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

function Map:size()
    assert(type(self) == "table", "Cannot get size of a non-table.")
    local count = 0
    for _, _ in pairs(self) do
        count = count + 1
    end
    return count
end

function Map:insert_all(other)
    assert(type(self) == "table", "Cannot insert all to a non-table.")
    assert(type(other) == "table", "Cannot insert all a single value.")
    
    for k,v in pairs(other) do self[k] = v end
    return self
end

function Map:deepcopy()
    if type(self) ~= "table" then return self end
    assert(type(self) == "table", "Cannot copy a non-table as a table.")
    local copy = {}
    
    for k, v in next, self, nil do
        copy[Map.deepcopy(k)] = Map.deepcopy(v)
    end
    setmetatable(copy, Map.deepcopy(getmetatable(self)))
    
    return copy
end

function Map:to_string()
    if type(self) ~= "table" then return tostring(self) end
    local stringy = "{"
    for k, v in pairs(self) do
        stringy = stringy .. Map.to_string(k) .. " = " .. Map.to_string(v) .. ","
    end
    stringy = stringy:sub(1,-2) .. "}"
    
    return stringy
end

return Map