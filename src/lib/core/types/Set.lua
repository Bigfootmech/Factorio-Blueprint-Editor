local Object = require('lib.core.types.Object')
local Sort = require('lib.core.Sort')

local type_name = "Set"
local Set = Object.new_class(type_name)
Set:allow_generics()

function Set.new()
    return Object.instantiate({}, Set)
end

local function insert_no_check_is_table(self, obj)
    if(self.generic_type_name ~= nil)then
        assert(type(obj) == self.generic_type_name, "Cannot insert non-"..self.generic_type_name.." to "..self.type_name..".")
    end
    
    self[obj] = true
    
    return self
end

function Set:verify_generic(some_table)
    if(self.generic_type_name ~= nil)then
        for element, set_true in pairs(some_table)do
            assert(type(element) == self.generic_type_name, "Cannot instantiate non-"..self.generic_type_name.." table to "..self.type_name..".")
        end
    end
end

function Set.from_table(some_table)
    for element, set_true in pairs(some_table)do
        assert(set_true == true, "Attempted to instantiate a set from a non-set table.")
    end
    
    return Object.instantiate(some_table, Set)
end

function Set:copy()
    assert(self:is_instantiataed(), "Can't copy a non-instance")
    
    local copy = Object.copy(self)
    
    return Object.instantiate(copy, self.parent)
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

function Set:to_array()
    assert(type(self) == "table", "Cannot set-to_descending_array on non-table.")
    local array = {}
    
    for blueprint_entity_num,_ in pairs(self)do 
        table.insert(array, blueprint_entity_num) 
    end
    
    return array
end

function Set:to_descending_array()
    local array = self:to_array()
    
    table.sort(array, Sort.descending)
    
    return array
end

return Set