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

local function to_var_style(name)
    return string.gsub(string.lower(name), "%s+", var_separator)
end

local function to_keystroke_style(key) -- enum containing all "keystroke" characters?
    return string.upper(key)
end
Util.to_keystroke_style = to_keystroke_style

local function event_style_concat(str1, str2)
    return str1..event_separator..str2
end

local function ordering_element(index) -- will break at 26, can be improved. floor(log25(total)+1)??? = number of characters required???. re-index every table? / force static calling?
    return alphabet[index]
end

local function get_event_name(action_name, index)
    return event_style_concat(ordering_element(index), to_event_style(action_name))
end
Util.get_event_name = get_event_name

local function get_prototype_table(event_name, key_sequence)
    return {["type"] = "custom-input", ["name"] = event_name, ["key_sequence"] = key_sequence}
end
Util.get_prototype_table = get_prototype_table

return Util