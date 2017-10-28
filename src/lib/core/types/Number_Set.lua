-- could add type checking to array / table -- moreover, could add "strict typing" class, that can be disabled/enabled

local Array = require('lib.core.types.Array')
local Set = require('lib.core.types.Set')
local Numbers_Set = {}

local function contains(set, number)
    assert(type(number) == "number", "Cannot check for non-number in numbers set.")
    return Array.contains(set, number)
end
Numbers_Set.contains = contains

local function add_item(set, number)
    assert(type(number) == "number", "Cannot add non-number to numbers set.")
    Set.add_item(set, number)
end
Numbers_Set.add_item = add_item

local function add_array(set, numbers_array)
    assert(type(numbers_array) == "table", "Tried to use add_array on non-array.")
    
    for index, element in ipairs(numbers_array) do
        assert(type(element) == "number", "Cannot add non-number to numbers set.")
    end
    Set.add_array(set, numbers_array)
    
    return set
end
Numbers_Set.add_array = add_array

local function add(set, obj)
    if(type(obj) == "table") then return add_array(set, obj) end
    return add_item(set, obj)
end
Numbers_Set.add = add

local function remove(set, number)
    assert(type(number) == "number", "Cannot remove non-number from number set.")
    Set.remove(set, number)
end
Numbers_Set.remove = remove

return Numbers_Set