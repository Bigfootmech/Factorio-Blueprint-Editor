local Object = require('lib.core.types.Object')
local List = require('lib.core.types.List')
local Keysequence_Definition_Mapping = require('lib.frontend.keybinds.Keysequence_Definition_Mapping')
local Util = require('lib.frontend.keybinds.Util')
local Direction_Keys = require('lib.frontend.keybinds.Direction_Keys')

local Keybinds = {}

local function get_ordered_action_definitions()
    
    local bounding_box_x_points = {"Left", "Centre", "Right"}
    local bounding_box_y_points = {"Bottom", "Centre", "Top"}
    
    local function concat_point_name(x_point_part, y_point_part)
        return x_point_part .. " " .. y_point_part
    end
    
    local function get_point_var(point_name)
        return Util.to_var_style(point_name)
    end
    
    local function get_keypad_num_from_xy(x, y)
        return ((y-1)*3) + x
    end
    
    local function get_keypad_keystroke(num)
        return "PAD " .. tostring(num)
    end
    
    local function get_simple_action_definition(action_name, key_sequence)
        return {
        [Util.action_name_field_name] = action_name,
        [Util.locale_text_field_name] = action_name, 
        [Util.key_sequence_field_name] = key_sequence, 
        [Util.linked_function_field_name] = Util.to_var_style(action_name)
        }
    end
    
    local function add_var(simple_action_definition, direction, var)
        simple_action_definition[Util.action_name_field_name] = 
            simple_action_definition[Util.action_name_field_name] .. " " .. direction
        simple_action_definition[Util.locale_text_field_name] = 
            simple_action_definition[Util.locale_text_field_name] .. " " .. direction
        simple_action_definition[Util.var_field_name] = var
        return simple_action_definition
    end
    
    local function get_action_definition(action_name, key_sequence, var_def, var)
        local action_definition = get_simple_action_definition(action_name, key_sequence)
        if(var_def == nil and var == nil)then
            return action_definition
        end
        action_definition = add_var(action_definition, var_def, var)
        return action_definition
    end
    
    local ordered_action_definitions = List.new()
    
    ordered_action_definitions:insert({
        [Util.action_name_field_name] = "Primary Action", -- can create a class to create these, and make it lazy evaluation??
        [Util.locale_text_field_name] = "Edit/Reopen", 
        [Util.key_sequence_field_name] = "N", 
        [Util.linked_function_field_name] = "edit_or_reopen_blueprint"
        })
        
    ordered_action_definitions:insert(get_action_definition("Add Component", "SHIFT + N"))
    
    ordered_action_definitions:insert(get_action_definition("Rotate", "R", "Clockwise", 1))
    ordered_action_definitions:insert(get_action_definition("Rotate", "SHIFT + R", "Anticlockwise", -1))
    
    for _, direction_name in pairs(Direction_Keys.names) do
        ordered_action_definitions:insert(get_action_definition(
            "Move", 
            Direction_Keys.get_keystroke(direction_name), 
            direction_name, 
            Direction_Keys.get_vector(direction_name):multiply(0.5)))
        ordered_action_definitions:insert(get_action_definition(
            "Move", 
            "SHIFT + " .. Direction_Keys.get_keystroke(direction_name), 
            "Further " .. direction_name, 
            Direction_Keys.get_vector(direction_name):multiply(2)))
    end
    
    ordered_action_definitions:insert(get_action_definition("Anchor to Selection", "CAPSLOCK"))
    ordered_action_definitions:insert(get_action_definition("Switch Selection", "TAB"))
    ordered_action_definitions:insert(get_action_definition("Finish Editing", "ENTER"))
    
    for j,y_point_part in ipairs(bounding_box_y_points)do
        for i,x_point_part in ipairs(bounding_box_x_points)do
            local point_name = concat_point_name(x_point_part, y_point_part)
            ordered_action_definitions:insert(get_action_definition(
                "Move blueprint anchor to", 
                get_keypad_keystroke(get_keypad_num_from_xy(i,j)), 
                point_name, 
                get_point_var(point_name)))
        end
    end
    
    return ordered_action_definitions
end

Keybinds.get_interface_mapping = function() return Keysequence_Definition_Mapping.get_interface_mapping(get_ordered_action_definitions()) end
Keybinds.get_var_for_event = function(event_name) return Keysequence_Definition_Mapping.get_var_for_event(event_name, get_ordered_action_definitions()) end

Keybinds.get_registered_key_sequences = function() return Keysequence_Definition_Mapping.get_registered_key_sequences(get_ordered_action_definitions()) end

Keybinds.get_locale_text = function() return Keysequence_Definition_Mapping.get_locale_text(get_ordered_action_definitions()) end

return Keybinds