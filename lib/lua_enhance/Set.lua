local Array = require 'lib.lua_enhance.Array'
local Set = {}

local function add_item(set, number)
    assert(type(set) == "table", "Cannot set-add_item to non-table.")
    
    if not Array.contains(set, number) then 
        Array.insert(set, number) -- sort?
        return set
    end -- otherwise notify error?
end
Set.add_item = add_item

local function add_array(set, array)
    assert(type(set) == "table", "Cannot set-add_array to non-table.")
    
    for index, element in ipairs(array) do -- feels dirty, and slightly inefficient?
        set = add_item(set, element)
    end
    
    return set
end
Set.add_array = add_array

local function add(set, obj)
    if(type(obj) == "table") then return add_array(set, obj) end
    return add_item(set, obj)
end
Set.add = add

local function remove(set, number)
    assert(type(set) == "table", "Cannot set-remove from non-table.")
    
    set = Array.remove_value(set, number)
    return set
end
Set.remove = remove

return Set