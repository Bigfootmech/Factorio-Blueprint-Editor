local Array = require('lib.core.types.Array')
local Set = {}

local function add_item_to_confirmed_set(set, element)
    if not Array.contains(set, element) then 
        table.insert(set, element) -- sort?
        return set
    end -- otherwise notify error?
end

local function add_item(set, element)
    assert(type(set) == "table", "Cannot set-add_item to non-table.")
    
    return add_item_to_confirmed_set(set, element)
end
Set.add_item = add_item

local function add_array(set, array)
    assert(type(set) == "table", "Cannot set-add_array to non-table.")
    
    for index, element in ipairs(array) do
        add_item_to_confirmed_set(set, element)
    end
    
    return set
end
Set.add_array = add_array

local function add(set, obj)
    if(type(obj) == "table") then return add_array(set, obj) end
    return add_item(set, obj)
end
Set.add = add

local function remove(set, element)
    assert(type(set) == "table", "Cannot set-remove from non-table.")
    
    set = table.remove(set, Array.get_index(set, element))
    return set
end
Set.remove = remove

return Set