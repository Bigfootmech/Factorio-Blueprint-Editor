local Object = require('lib.core.types.Object')

local Set = Object.new_class("Set")

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

    return self[obj] ~= nil
end

function Set:insert(obj)
    assert(type(self) == "table", "Cannot set-insert to non-table.")
    
    self[obj] = true
    
    return self
end

function Set:insert_all(array)
    assert(type(self) == "table", "Cannot set-insert_all to non-table.")
    assert(type(array) == "table", "Cannot set-insert_all a non-table.")
    
    for index, element in ipairs(array) do
        self:insert(element)
    end
    
    return set
end

function Set:remove(element)
    assert(type(self) == "table", "Cannot set-remove from non-table.")
    
    self[element] = nil -- error if not there in the first place?
    
    return self
end

return Set