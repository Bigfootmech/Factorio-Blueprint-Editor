local Data = {}

function Data.new()
    return setmetatable({}, {__index = Data})
end

function Data:extend(new_data_array)
    for _,new_el in ipairs(new_data_array)do
        table.insert(self, new_el)
    end
end

return Data