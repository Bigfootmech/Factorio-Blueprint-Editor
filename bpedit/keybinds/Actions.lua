local Vector = require 'lib.spatial.Vector'
local Util = require 'lib.events.Util'
local Event_Registration = require 'lib.events.Event_Registration'

local Actions = {}

local directions = {["Up"] = Vector.up(), ["Down"] = Vector.down(), ["Left"] = Vector.left(), ["Right"] = Vector.right()}

local function get_pretty(direction, bool_enhance)
    local pretty = direction
    if bool_enhance then
        return pretty .. " More"
    end
    return pretty
end

local function get_locale_text(direction, bool_enhance)
    local prepend = "Selected Move "
    if bool_enhance then
        prepend = prepend .. "Further "
    end
    return prepend .. direction
end

local function get_keys(direction, bool_enhance)
    local keystrokes = Util.to_keystroke_style(direction)
    if bool_enhance then
        return "SHIFT + " .. keystrokes
    end
    return keystrokes
end

local function get_var(direction_name, bool_enhance)
    local basic_vector = directions[direction_name]
    if bool_enhance then 
        return basic_vector:multiply(2)
    end
    return basic_vector:divide(2) -- because I don't handle object base size yet. And it influences where origin falls on the object. (odd nums = -0.5, evens = 0)
end


---------------- end of direction behaviour -> start of registerring ------------------------

Event_Registration.register_command_from_action_definition({
    [Util.action_name_field_name] = "Primary Action", 
    [Util.locale_text_field_name] = "Edit/Reopen", 
    [Util.key_sequence_field_name] = "N", 
    [Util.linked_function_field_name] = "edit_or_reopen_blueprint"})
    
Event_Registration.register_command_from_action_definition({
    [Util.action_name_field_name] = "Secondary Action", 
    [Util.locale_text_field_name] = "Add Component", 
    [Util.key_sequence_field_name] = "SHIFT + N", 
    [Util.linked_function_field_name] = "add_inner_blueprint"})


local function generate_line_for_direction_combination(direction_name, bool_enhance)
    local direction_action_definition = {
    [Util.action_name_field_name] = get_pretty(direction_name, bool_enhance), 
    [Util.locale_text_field_name] = get_locale_text(direction_name, bool_enhance), 
    [Util.key_sequence_field_name] = get_keys(direction_name, bool_enhance),
    [Util.linked_function_field_name] = "move_inner_blueprint",
    [Util.var_field_name] = get_var(direction_name, bool_enhance)}
    
    return direction_action_definition
end

for direction_name, _ in pairs(directions) do
    for _,bool_enhance in pairs {false, true} do
        Event_Registration.register_command_from_action_definition(generate_line_for_direction_combination(direction_name, bool_enhance))
    end
end

Actions.get_interface_mapping = Event_Registration.get_interface_mapping
Actions.get_registered_key_sequences = Event_Registration.get_registered_key_sequences
Actions.get_var_for_event = Event_Registration.get_var_for_event

return Actions