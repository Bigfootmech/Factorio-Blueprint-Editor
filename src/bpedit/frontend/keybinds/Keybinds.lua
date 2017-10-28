local Keysequence_Definition_Mapping = require('lib.frontend.keybinds.Keysequence_Definition_Mapping')
local Util = require('lib.frontend.keybinds.Util')
local Direction_Keys = require('lib.frontend.keybinds.Direction_Keys')

local Actions = {}

local function get_ordered_action_definitions()
    
    local ordered_action_definitions = {}
    
    table.insert(ordered_action_definitions,{
        [Util.action_name_field_name] = "Primary Action", -- can create a class to create these, and make it lazy evaluation??
        [Util.locale_text_field_name] = "Edit/Reopen", 
        [Util.key_sequence_field_name] = "N", 
        [Util.linked_function_field_name] = "edit_or_reopen_blueprint"
        })
        
    table.insert(ordered_action_definitions, {
        [Util.action_name_field_name] = "Secondary Action", 
        [Util.locale_text_field_name] = "Add Component", 
        [Util.key_sequence_field_name] = "SHIFT + N",
        [Util.linked_function_field_name] = "add_inner_blueprint"
        })
    
    local function get_filled_direction_action_definition(direction_name)
        return {
        [Util.action_name_field_name] = direction_name, 
        [Util.locale_text_field_name] = "Selected Move " .. direction_name,
        [Util.key_sequence_field_name] = Direction_Keys.get_keystroke(direction_name),
        [Util.linked_function_field_name] = "move_inner_blueprint",
        [Util.var_field_name] = Direction_Keys.get_vector(direction_name):divide(2)
        }
    end
    
    local function get_filled_enhanced_direction_action_definition(direction_name)
        return {
        [Util.action_name_field_name] = direction_name .. "More",
        [Util.locale_text_field_name] = "Selected Move Further " .. direction_name,
        [Util.key_sequence_field_name] = "SHIFT + ".. Direction_Keys.get_keystroke(direction_name),
        [Util.linked_function_field_name] = "move_inner_blueprint",
        [Util.var_field_name] = Direction_Keys.get_vector(direction_name):multiply(2)
        }
    end
    
    for _, direction_name in pairs(Direction_Keys.names) do
        table.insert(ordered_action_definitions,get_filled_direction_action_definition(direction_name))
        table.insert(ordered_action_definitions,get_filled_enhanced_direction_action_definition(direction_name))
    end

    return ordered_action_definitions
end

Actions.get_interface_mapping = function() return Keysequence_Definition_Mapping.get_interface_mapping(get_ordered_action_definitions()) end
Actions.get_var_for_event = function(event_name) return Keysequence_Definition_Mapping.get_var_for_event(event_name, get_ordered_action_definitions()) end

Actions.get_registered_key_sequences = function() return Keysequence_Definition_Mapping.get_registered_key_sequences(get_ordered_action_definitions()) end

Actions.get_locale_text = function() return Keysequence_Definition_Mapping.get_locale_text(get_ordered_action_definitions()) end

return Actions