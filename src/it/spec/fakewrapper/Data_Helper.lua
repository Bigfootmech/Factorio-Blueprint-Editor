local Data_Helper = {}

function Data_Helper.get_data_for_keysequence(keysequence)
    for _, el in ipairs(data)do
        if(type(el) == "table" and el["key_sequence"] == keysequence)then
            return el
        end
    end
    return nil
end

return Data_Helper