local Util = require 'lib.events.Util'
local Vector = require 'lib.spatial.Vector'

local Direction_Keys = {}

local names = {"Up", "Down", "Left", "Right"}
Direction_Keys.names = names

local vectors = {[names[1]] = Vector.up, [names[2]] = Vector.down, [names[3]] = Vector.left, [names[4]] = Vector.right}
Direction_Keys.vectors = vectors

local function get_vector(direction)
    return vectors[direction]()
end
Direction_Keys.get_vector = get_vector

local function get_keystroke(direction)
    return Util.to_keystroke_style(direction)
end
Direction_Keys.get_keystroke = get_keystroke

local function get_action_definition(direction)
    return {[Util.action_name_field_name] = direction, 
        [Util.locale_text_field_name] = direction, 
        [Util.key_sequence_field_name] = get_keystroke(direction), 
        [Util.var_field_name] = get_vector(direction)}
end
Direction_Keys.get_action_definition = get_action_definition

return Direction_Keys