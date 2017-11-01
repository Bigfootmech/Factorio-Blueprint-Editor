local Object = require('lib.core.types.Object')
local Set = require('lib.core.types.Set')
-- could add type checking to array / table -- moreover, could add "strict typing" class, that can be disabled/enabled


local Number_Set = Object.extends(Set,"Set<number>")
Number_Set.generic_type = "number"

function Number_Set.new()
    return Object.instantiate({}, Number_Set)
end

function Number_Set:contains(number)
    assert(type(number) == self.generic_type, "Cannot check for non-"..self.generic_type .." in "..self.type.." .")
    return Set.contains(self, number)
end

function Number_Set:insert(number)
    assert(type(number) == self.generic_type, "Cannot insert non-"..self.generic_type.." to "..self.type..".")
    return Set.insert(self, number)
end

function Number_Set:insert_all(numbers_array)
    assert(type(numbers_array) == "table", "Tried to insert_all a non-array.")
    
    for index, element in ipairs(numbers_array) do
        self = self:insert(element)
    end
    
    return self
end

function Number_Set:remove(number)
    assert(type(number) == self.generic_type, "Cannot remove non-"..self.generic_type.." from "..self.type..".")
    return Set.remove(self, number)
end

return Number_Set