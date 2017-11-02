local Object = require('lib.core.types.Object')

local type_name = "Set"
local Set = Object.new_class(type_name)
Set:allow_generics()

function Set.new()
    return Object.instantiate({}, Set)
end

function Set:size()
    assert(type(self) == "table", "Cannot get size of a non-table.")
    local count = 0
    for _, _ in pairs(self) do
        count = count + 1
    end
    return count
end

function Set:contains(obj)
    assert(type(self) == "table", "Cannot use set-contains on a non-table.")
    
    if(self.generic_type_name ~= nil)then
        assert(type(obj) == self.generic_type_name, "Cannot check for non-"..self.generic_type_name .." in "..self.type_name..".")
    end
    
    return self[obj] ~= nil
end

local function insert_no_check_is_table(self, obj)
    if(self.generic_type_name ~= nil)then
        assert(type(obj) == self.generic_type_name, "Cannot insert non-"..self.generic_type_name.." to "..self.type_name..".")
    end
    
    self[obj] = true
    
    return self
end

function Set:insert(obj)
    assert(type(self) == "table", "Cannot set-insert to non-table.")
    
    return insert_no_check_is_table(self,obj)
end

function Set:insert_all(array)
    assert(type(self) == "table", "Cannot set-insert_all to non-table.")
    assert(type(array) == "table", "Cannot set-insert_all a non-table.")
    
    for index, element in ipairs(array) do
        insert_no_check_is_table(self, element)
    end
    
    return self
end

function Set:remove(obj)
    assert(type(self) == "table", "Cannot set-remove from non-table.")
    
    if(self.generic_type_name ~= nil)then
        assert(type(obj) == self.generic_type_name, "Cannot remove non-"..self.generic_type_name.." from "..self.type_name..".")
    end
    
    self[obj] = nil -- error if not there in the first place?
    
    return self
end

return Set