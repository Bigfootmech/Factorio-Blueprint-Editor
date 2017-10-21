local Table = {}

local function insert_all(this, other)
    assert(type(this) == "table", "Cannot insert all to a non-table.")
    assert(type(other) == "table", "Cannot insert all a single value.")
    
    for k,v in pairs(other) do this[k] = v end
    return this
end
Table.insert_all = insert_all

local function deepcopy(source)
    if type(source) ~= "table" then return source end
    assert(type(source) == "table", "Cannot copy a non-table as a table.")
    local copy = {}
    
    for k, v in next, source, nil do
        copy[Table.deepcopy(k)] = Table.deepcopy(v)
    end
    setmetatable(copy, Table.deepcopy(getmetatable(source)))
    
    return copy
end
Table.deepcopy = deepcopy

local function keys(source)
    assert(type(source) == "table", "Cannot get keys of a non-table.")
    local keys = {}
    for k, _ in pairs(source) do
        table.insert(keys,k)
    end
    return keys
end
Table.keys = keys

local function values(source)
    assert(type(source) == "table", "Cannot get keys of a non-table.")
    local values = {}
    for _, v in pairs(source) do
        table.insert(values,v)
    end
    return values
end
Table.values = values

local function to_string(source)
    if type(source) ~= "table" then return tostring(source) end
    local stringy = "{"
    for k, v in pairs(source) do
        stringy = stringy .. to_string(k) .. " = " .. to_string(v) .. ","
    end
    stringy = stringy:sub(1,-2) .. "}"
    
    return stringy
end
Table.to_string = to_string

return Table