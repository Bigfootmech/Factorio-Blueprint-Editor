local Vector = require('lib.spatial.Vector')
local Util = require('lib.events.Util')
local Direction_Keys = require('lib.events.Direction_Keys')
local Event_Registration = require('lib.events.Event_Registration')

local Actions = {}

local function get_ordered_action_definitions()
    
    local ordered_action_definitions = {}
    
    table.insert(ordered_action_definitions,{
        [Util.action_name_field_name] = "Primary Action", 
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
        local uncooked_definition = Direction_Keys.get_action_definition(direction_name)
        uncooked_definition[Util.linked_function_field_name] = "move_inner_blueprint"
        uncooked_definition[Util.locale_text_field_name] = "Selected Move " .. uncooked_definition[Util.locale_text_field_name]
        uncooked_definition[Util.var_field_name] = uncooked_definition[Util.var_field_name]:divide(2)
    end
    
    local function get_filled_enhanced_direction_action_definition(direction_name)
        local uncooked_definition = Direction_Keys.get_action_definition(direction_name)
        uncooked_definition[Util.action_name_field_name] = uncooked_definition[Util.action_name_field_name] .. "More"
        uncooked_definition[Util.locale_text_field_name] = "Selected Move Further " .. uncooked_definition[Util.locale_text_field_name]
        uncooked_definition[Util.key_sequence_field_name] = "SHIFT + ".. uncooked_definition[Util.key_sequence_field_name]
        uncooked_definition[Util.linked_function_field_name] = "move_inner_blueprint"
        uncooked_definition[Util.var_field_name] = uncooked_definition[Util.var_field_name]:multiply(2)
    end
    
    for direction_name, _ in pairs(Direction_Keys.names) do
        table.insert(ordered_action_definitions,get_filled_direction_action_definition(direction_name))
        table.insert(ordered_action_definitions,get_filled_enhanced_direction_action_definition(direction_name))
    end

    return ordered_action_definitions
end

Actions.get_interface_mapping = function() return Event_Registration.get_interface_mapping(get_ordered_action_definitions()) end
Actions.get_var_for_event = function(event_name) return Event_Registration.get_var_for_event(event_name, get_ordered_action_definitions()) end

Actions.get_registered_key_sequences = function() return Event_Registration.get_registered_key_sequences(get_ordered_action_definitions()) end

return Actions