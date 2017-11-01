local Array = {}

function Array.contains(self, el)
    if Array.get_index(self, el) then return true end
    return false
end

function Array:get_index(el)
    assert(self ~= nil, "Cannot trawl a nil array.")
    for index, element in ipairs(self) do
        if element == el then
            return index
        end
    end

    return false
end

function Array:insert(element)
    assert(type(self) == "table", "Cannot insert all to a non-table.")
    
    table.insert(self,element)

    return self
end

function Array:insert_all(other)
    assert(type(self) == "table", "Cannot insert all to a non-table.")
    assert(type(other) == "table", "Cannot insert all a single value.")
    
    for _,element in pairs(other) do table.insert(self,element) end

    return self
end

return Array