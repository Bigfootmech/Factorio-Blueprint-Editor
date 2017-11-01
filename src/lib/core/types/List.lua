local Object = require('lib.core.types.Object')

local List = Object.new_class("List")

function List.new()
    return Object.instantiate({},List)
end

function List:len()
    return #self
end

function List:contains(el)
    if(List.get_index(self, el))then 
        return true 
    end
    return false
end

function List:get_index(el)
    assert(type(self) == "table", "Cannot trawl a non-table.")
    for index, element in ipairs(self) do
        if(element == el)then
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

function List:remove(index)
    assert(type(self) == "table", "Cannot insert all to a non-table.")
    
    table.remove(self,index)

    return self
end

function List:as_json()
    if type(self) ~= "table" then return tostring(self) end
    local stringy = "["
    for _, el in ipairs(self) do
        stringy = stringy ..'"' .. Object.as_json(el) .. '",'
    end
    stringy = stringy:sub(1,-2) .. "]"
    
    return stringy
end

return List