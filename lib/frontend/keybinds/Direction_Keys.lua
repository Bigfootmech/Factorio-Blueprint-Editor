local Util = require('lib.frontend.keybinds.Util')
local Vector = require('lib.logic.model.spatial.Vector')

local Direction_Keys = {}

local names = {"Up", "Down", "Left", "Right"}
Direction_Keys.names = names

local function is_direction_key_name(obj)
    assert(type(obj) == "string", "A direction name must be a string.")
    local string_lower = string.lower(obj)
    for _,direction_name in ipairs(names) do
        local direction_name_lower = string.lower(direction_name)
        if(string_lower == direction_name_lower) then
            return true
        end
    end
    return false

end

local function get_vector(direction_name)
    assert(is_direction_key_name(direction_name), "Can't vector for direction " .. tostring(direction_name))
    local formatted_direction_name = string.lower(direction_name)
    return Vector[formatted_direction_name]()
end
Direction_Keys.get_vector = get_vector

local function get_keystroke(direction_name)
    return Util.to_keystroke_style(direction_name)
end
Direction_Keys.get_keystroke = get_keystroke

local function get_action_definition(direction_name)
    return {[Util.action_name_field_name] = direction_name, 
        [Util.locale_text_field_name] = direction_name, 
        [Util.key_sequence_field_name] = get_keystroke(direction_name), 
        [Util.var_field_name] = get_vector(direction_name)}
end
Direction_Keys.get_action_definition = get_action_definition

return Direction_Keys