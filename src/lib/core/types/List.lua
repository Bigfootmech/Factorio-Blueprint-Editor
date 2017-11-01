local Object = require('lib.core.types.Object')

local List = Object.new_class()
List.type = "List"

function List.new()
    return Object.instantiate({},List)
end

function List.contains(self, el)
    if List.get_index(self, el) then return true end
    return false
end

function List:get_index(el)
    assert(self ~= nil, "Cannot trawl a nil list.")
    for index, element in ipairs(self) do
        if element == el then
            return index
        end
    end

    return false
end

function List:insert(element)
    assert(type(self) == "table", "Cannot insert all to a non-table.")
    
    table.insert(self,element)

    return self
end

function List:insert_all(other)
    assert(type(self) == "table", "Cannot insert all to a non-table.")
    assert(type(other) == "table", "Cannot insert all a single value.")
    
    for _,element in pairs(other) do table.insert(self,element) end

    return self
end

return List