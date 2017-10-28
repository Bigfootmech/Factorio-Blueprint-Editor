local Array = {}

local function contains(arr, el)
    if Array.get_index(arr, el) then return true end
    return false
end
Array.contains = contains

local function get_index(arr, el)
    assert(arr ~= nil, "Cannot trawl a nil array.")
    for index, element in ipairs(arr) do
        if element == el then
            return index
        end
    end

    return false
end
Array.get_index = get_index

local function insert_all(this, that)
    assert(type(this) == "table", "Cannot insert all to a non-table.")
    assert(type(other) == "table", "Cannot insert all a single value.")
    
    for _,element in pairs(that) do table.insert(this,element) end

    return this
end
Array.insert_all = insert_all

return Array