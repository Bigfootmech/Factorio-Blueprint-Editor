local Table = {}

function insert_all(this, other)
    assert(type(this) == "table", "Cannot insert all to a non-table.")
    assert(type(other) == "table", "Cannot insert all a single value.")
    
    for k,v in pairs(other) do this[k] = v end
    return this
end

Table.insert_all = insert_all

function Table.deepcopy(source)
    if type(source) ~= "table" then return source end
    assert(type(source) == "table", "Cannot copy a non-table as a table.")
    local copy = {}
    
    for k, v in next, source, nil do
        copy[Table:deepcopy(k)] = Table:deepcopy(v)
    end
    setmetatable(copy, Table:deepcopy(getmetatable(source)))
    
    return copy
end

Table.deepcopy = deepcopy

return Table