local Util = require('lib.events.Util')
local Vector = require('lib.spatial.Vector')

local Direction_Keys = {}

local names = {"Up", "Down", "Left", "Right"}
Direction_Keys.names = names

local vectors = {[names[1]] = Vector.up, [names[2]] = Vector.down, [names[3]] = Vector.left, [names[4]] = Vector.right}
Direction_Keys.vectors = vectors

local function get_vector(direction_name)
    return vectors[direction_name]()
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