local Keysequence_Definition_Mapping = require('lib.frontend.keybinds.Keysequence_Definition_Mapping')
local Util = require('lib.frontend.keybinds.Util')
local Direction_Keys = require('lib.frontend.keybinds.Direction_Keys')

local Keybinds = {}

local function get_ordered_action_definitions()
    
    local function get_simple_action_definition(action_name, button)
        return {
        [Util.action_name_field_name] = action_name,
        [Util.locale_text_field_name] = action_name, 
        [Util.key_sequence_field_name] = button, 
        [Util.linked_function_field_name] = Util.to_var_style(action_name)
        }
    end
    
    local ordered_action_definitions = {}
    
    table.insert(ordered_action_definitions,{
        [Util.action_name_field_name] = "Primary Action", -- can create a class to create these, and make it lazy evaluation??
        [Util.locale_text_field_name] = "Edit/Reopen", 
        [Util.key_sequence_field_name] = "N", 
        [Util.linked_function_field_name] = "edit_or_reopen_blueprint"
        })
        
    table.insert(ordered_action_definitions,get_simple_action_definition("Add Component", "SHIFT + N"))
        
    local rotation_action_name = "Rotate"
    
    table.insert(ordered_action_definitions,{
        [Util.action_name_field_name] = rotation_action_name + " Clockwise",
        [Util.locale_text_field_name] = rotation_action_name + " Clockwise", 
        [Util.key_sequence_field_name] = "R", 
        [Util.linked_function_field_name] = Util.to_var_style(rotation_action_name),
        [Util.var_field_name] = 1
        })
        
    table.insert(ordered_action_definitions, {
        [Util.action_name_field_name] = rotation_action_name + " Anticlockwise", 
        [Util.locale_text_field_name] = rotation_action_name + " Anticlockwise", 
        [Util.key_sequence_field_name] = "SHIFT + R",
        [Util.linked_function_field_name] = Util.to_var_style(rotation_action_name),
        [Util.var_field_name] = -1
        })
        
    local selection_movement_action_name = "Move Selection"
    
    local function get_filled_direction_action_definition(direction_name)
        return {
        [Util.action_name_field_name] = direction_name, 
        [Util.locale_text_field_name] = selection_movement_action_name .. " " .. direction_name,
        [Util.key_sequence_field_name] = Direction_Keys.get_keystroke(direction_name),
        [Util.linked_function_field_name] = Util.to_var_style(selection_movement_action_name),
        [Util.var_field_name] = Direction_Keys.get_vector(direction_name):divide(2)
        }
    end
    
    local function get_filled_enhanced_direction_action_definition(direction_name)
        return {
        [Util.action_name_field_name] = direction_name .. " More",
        [Util.locale_text_field_name] = selection_movement_action_name .. " Further " .. direction_name,
        [Util.key_sequence_field_name] = "SHIFT + ".. Direction_Keys.get_keystroke(direction_name),
        [Util.linked_function_field_name] = Util.to_var_style(selection_movement_action_name),
        [Util.var_field_name] = Direction_Keys.get_vector(direction_name):multiply(2)
        }
    end
    
    for _, direction_name in pairs(Direction_Keys.names) do
        table.insert(ordered_action_definitions,get_filled_direction_action_definition(direction_name))
        table.insert(ordered_action_definitions,get_filled_enhanced_direction_action_definition(direction_name))
    end
    
    table.insert(ordered_action_definitions,get_simple_action_definition("Anchor to Selection", "CAPSLOCK"))
    table.insert(ordered_action_definitions,get_simple_action_definition("Switch Selection", "TAB"))
    
    local x_point_part_arr = {"Left", "Centre", "Right"}
    local y_point_part_arr = {"Bottom", "Centre", "Top"}
    local number_of_xy_point_combinations = #x_point_part_arr * #y_point_part_arr
    
    local function get_x_var_part(num)
        local num_x_part = num % #x_point_part_arr
        if(num_x_part == 0)then
            num_x_part = #x_point_part_arr
        end
        return x_point_part_arr[num_x_part]
    end
    
    local function get_y_var_part(num)
        local num_y_part = math.ceil(num/#y_point_part_arr)
        return y_point_part_arr[num_y_part]
    end
    
    local function get_anchor_point_action_definition(num)
        local direction_name = get_x_var_part(num) .. " " .. get_y_var_part(num)
        return {
        [Util.action_name_field_name] = "Anchor blueprint to " .. direction_name,
        [Util.locale_text_field_name] = "Anchor blueprint to " .. direction_name, 
        [Util.key_sequence_field_name] = "PAD " .. tostring(num), 
        [Util.linked_function_field_name] = "anchor_point",
        [Util.var_field_name] = Util.to_var_style(direction_name)
        }
    end
    
    for i=1,number_of_xy_point_combinations do
        table.insert(ordered_action_definitions,get_anchor_point_action_definition(i))
    end

    return ordered_action_definitions
end

Keybinds.get_interface_mapping = function() return Keysequence_Definition_Mapping.get_interface_mapping(get_ordered_action_definitions()) end
Keybinds.get_var_for_event = function(event_name) return Keysequence_Definition_Mapping.get_var_for_event(event_name, get_ordered_action_definitions()) end

Keybinds.get_registered_key_sequences = function() return Keysequence_Definition_Mapping.get_registered_key_sequences(get_ordered_action_definitions()) end

Keybinds.get_locale_text = function() return Keysequence_Definition_Mapping.get_locale_text(get_ordered_action_definitions()) end

return Keybinds