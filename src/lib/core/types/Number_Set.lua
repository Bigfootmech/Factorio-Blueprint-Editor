local Object = require('lib.core.types.Object')
local Set = require('lib.core.types.Set')
-- could add type checking to array / table -- moreover, could add "strict typing" class, that can be disabled/enabled


local Number_Set = Object.extends(Set,"Numbers_Set")
Number_Set.generic_type = "number"

function Number_Set.new()
    return Object.instantiate({}, Number_Set)
end

function Number_Set:contains(number)
    assert(type(number) == Number_Set.generic_type, "Cannot check for non-"..Number_Set.generic_type .." in "..Number_Set.generic_type.." set.")
    return Set.contains(self, number)
end

function Number_Set:insert(number)
    assert(type(number) == Number_Set.generic_type, "Cannot insert non-"..Number_Set.generic_type.." to "..Number_Set.generic_type.." set.")
    Set.insert(self, number)
end

function Number_Set:insert_all(numbers_array)
    assert(type(numbers_array) == "table", "Tried to set-insert_all a non-array.")
    
    for index, element in ipairs(numbers_array) do
        self:insert(element)
    end
    
    return self
end

function Number_Set:remove(number)
    assert(type(number) == Number_Set.generic_type, "Cannot remove non-"..Number_Set.generic_type.." from "..Number_Set.generic_type.." set.")
    Set.remove(self, number)
end

return Number_Set