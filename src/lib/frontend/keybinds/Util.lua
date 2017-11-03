local Util = {}

Util.action_name_field_name = "action_name"
Util.locale_text_field_name = "locale_text"
Util.key_sequence_field_name = "key_sequence"
Util.linked_function_field_name = "linked_function"
Util.var_field_name = "var"

local alphabet = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
local event_separator = "-"
local var_separator = "_"

local function to_event_style(name)
    return string.gsub(string.lower(name), "%s+", event_separator)
end

function Util.to_var_style(name)
    return string.gsub(string.lower(name), "%s+", var_separator)
end

function Util.to_keystroke_style(key)
    return string.upper(key)
end

local function event_style_concat(str1, str2)
    return str1..event_separator..str2
end

local function reindex_for_new_char(list_of_ordered_elements)
    local reindexed = {}
    for _, ord_el in pairs(list_of_ordered_elements)do
        table.insert(reindexed,alphabet[1] .. ord_el)
    end
    return reindexed
end

local function get_function_limit(characters_used) --  floor(log25(total)+1)??? = number of characters required??? (haven't checked)
    return ((#alphabet-1) ^ characters_used) + 1
end

local function ordering_element(index, characters_used)
    if(characters_used == nil)then
        characters_used = 1
    end
    
    if(index > get_function_limit(characters_used))then
        error("Exceeded number of supported actions") --  add a in front of all the previously registered actions, and increase characters used
    end
    
    if(characters_used == 0)then
        return ""
    end
    
    if(index <= #alphabet)then
        return alphabet[index]
    end
    
    local lowest_part_index = (index-1) % #alphabet + 1
    
    local shifted_index = math.floor((index - 1) / #alphabet) + 1
    
    return ordering_element(shifted_index, characters_used - 1) .. alphabet[lowest_part_index]
end

function Util.get_event_name(action_name, index)
    return event_style_concat(ordering_element(index, 2), to_event_style(action_name))
end

function Util.get_prototype_table(event_name, key_sequence)
    return {["type"] = "custom-input", ["name"] = event_name, ["key_sequence"] = key_sequence}
end

return Util