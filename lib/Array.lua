Array = {}
Array.__index = Array

function Array:contains(arr, el)
    if Array:get_index(arr, el) then return true end
    return false
end

function Array:get_index(arr, el)
    assert(arr ~= nil, "Cannot trawl a nil array.")
    for index, element in ipairs(arr) do
        if element == el then
            return index
        end
    end

    return false
end