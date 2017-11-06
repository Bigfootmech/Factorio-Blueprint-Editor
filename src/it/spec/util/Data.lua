local Data = {}

function Data.new()
    return setmetatable({}, {__index = Data})
end

function Data:extend(new_data)
    for _,new_el in ipairs(new_data)do
        table.insert(self, new_el)
    end
end

function Data:get_data_for_keysequence(keysequence)
    for _, el in ipairs(self)do
        if(type(el) == "table" and el["key_sequence"] == keysequence)then
            return el
        end
    end
    return nil
end

return Data