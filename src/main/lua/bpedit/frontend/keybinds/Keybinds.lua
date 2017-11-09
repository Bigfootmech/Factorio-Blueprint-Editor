local Object = require('lib.core.types.Object')
local Keysequence_Definition_Mapping = require('lib.frontend.keybinds.Keysequence_Definition_Mapping')
local Action_Definition = require('lib.frontend.keybinds.Action_Definition')
local List = require('lib.core.types.List')
local Util = require('lib.frontend.keybinds.Util')
local Direction_Keys = require('lib.frontend.keybinds.Direction_Keys')

local Keybinds = Object.extends(Keysequence_Definition_Mapping,"Keybinds")

function Keybinds.get_ordered_action_definitions()
    
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
    
    local ordered_action_definitions = List.new()
    
    ordered_action_definitions:insert({
        [Util.action_name_field_name] = "Primary Action", -- can create a class to create these, and make it lazy evaluation??
        [Util.locale_text_field_name] = "Edit/Reopen", 
        [Util.key_sequence_field_name] = "N", 
        [Util.linked_function_field_name] = "edit_or_reopen_blueprint"
        })
        
    ordered_action_definitions:insert(Action_Definition.new("Add Component", "SHIFT + N"))
    ordered_action_definitions:insert(Action_Definition.new("Copy", "CONTROL + C"))
    
    ordered_action_definitions:insert(Action_Definition.new("Rotate", "R", "Clockwise", 1))
    ordered_action_definitions:insert(Action_Definition.new("Rotate", "SHIFT + R", "Anticlockwise", -1))
    ordered_action_definitions:insert(Action_Definition.new("Mirror", "SHIFT + M", "Horisontally", defines ~=nil and defines.direction.north))
    ordered_action_definitions:insert(Action_Definition.new("Mirror", "CONTROL + M", "Vertically", defines ~=nil and defines.direction.east))
    
    for _, direction_name in pairs(Direction_Keys.names) do
        ordered_action_definitions:insert(Action_Definition.new(
            "Move", 
            Direction_Keys.get_keystroke(direction_name), 
            direction_name, 
            Direction_Keys.get_vector(direction_name):multiply(0.5)))
        ordered_action_definitions:insert(Action_Definition.new(
            "Move", 
            "SHIFT + " .. Direction_Keys.get_keystroke(direction_name), 
            "Further " .. direction_name, 
            Direction_Keys.get_vector(direction_name):multiply(2)))
    end
    
    ordered_action_definitions:insert(Action_Definition.new("Anchor to Selection", "CAPSLOCK"))
    ordered_action_definitions:insert(Action_Definition.new("Switch Selection", "TAB"))
    ordered_action_definitions:insert(Action_Definition.new("Delete Selection", "DELETE"))
    ordered_action_definitions:insert(Action_Definition.new("Finish Editing", "ENTER"))
    
    for j,y_point_part in ipairs(bounding_box_y_points)do
        for i,x_point_part in ipairs(bounding_box_x_points)do
            local point_name = concat_point_name(x_point_part, y_point_part)
            ordered_action_definitions:insert(Action_Definition.new(
                "Move blueprint anchor to", 
                get_keypad_keystroke(get_keypad_num_from_xy(i,j)), 
                point_name, 
                get_point_var(point_name)))
        end
    end
    
    return ordered_action_definitions
end

return Keybinds