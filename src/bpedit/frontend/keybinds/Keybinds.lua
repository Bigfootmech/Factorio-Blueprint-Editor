local Keysequence_Definition_Mapping = require('lib.frontend.keybinds.Keysequence_Definition_Mapping')
local Util = require('lib.frontend.keybinds.Util')
local Direction_Keys = require('lib.frontend.keybinds.Direction_Keys')

local Keybinds = {}

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
        [Util.action_name_field_name] = direction_name .. " More",
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
    
    table.insert(ordered_action_definitions,{
        [Util.action_name_field_name] = "Anchor to Selection",
        [Util.locale_text_field_name] = "Anchor to Selection", 
        [Util.key_sequence_field_name] = "CAPSLOCK", 
        [Util.linked_function_field_name] = "anchor_to_selection"
        })
    
    table.insert(ordered_action_definitions,{
        [Util.action_name_field_name] = "Switch Selection",
        [Util.locale_text_field_name] = "Switch Selection", 
        [Util.key_sequence_field_name] = "TAB", 
        [Util.linked_function_field_name] = "switch_selection"
        })
    
    local function get_anchor_point_action_definition(direction_name, num)
        return {
        [Util.action_name_field_name] = "Anchor blueprint to " .. direction_name,
        [Util.locale_text_field_name] = "Anchor blueprint to " .. direction_name, 
        [Util.key_sequence_field_name] = "NUM " .. tostring(num), 
        [Util.linked_function_field_name] = "anchor_point",
        [Util.var_field_name] = num
        }
    end
    
    table.insert(get_anchor_point_action_definition("Northwest", 7))
    table.insert(get_anchor_point_action_definition("North", 8))
    table.insert(get_anchor_point_action_definition("Northeast", 9))
    table.insert(get_anchor_point_action_definition("West", 4))
    table.insert(get_anchor_point_action_definition("Centre", 5))
    table.insert(get_anchor_point_action_definition("East", 6))
    table.insert(get_anchor_point_action_definition("Southwest", 1))
    table.insert(get_anchor_point_action_definition("South", 2))
    table.insert(get_anchor_point_action_definition("Southeast", 3))

    return ordered_action_definitions
end

Keybinds.get_interface_mapping = function() return Keysequence_Definition_Mapping.get_interface_mapping(get_ordered_action_definitions()) end
Keybinds.get_var_for_event = function(event_name) return Keysequence_Definition_Mapping.get_var_for_event(event_name, get_ordered_action_definitions()) end

Keybinds.get_registered_key_sequences = function() return Keysequence_Definition_Mapping.get_registered_key_sequences(get_ordered_action_definitions()) end

Keybinds.get_locale_text = function() return Keysequence_Definition_Mapping.get_locale_text(get_ordered_action_definitions()) end

return Keybinds