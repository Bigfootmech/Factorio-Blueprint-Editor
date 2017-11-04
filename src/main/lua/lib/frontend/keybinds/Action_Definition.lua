local Object = require('lib.core.types.Object')
local Util = require('lib.frontend.keybinds.Util')

local Action_Definition = Object.new_class("Action_Definition")

    
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
    
    function Action_Definition.new(action_name, key_sequence, var_def, var)
        local action_definition = get_simple_action_definition(action_name, key_sequence)
        if(var_def == nil and var == nil)then
            return action_definition
        end
        action_definition = add_var(action_definition, var_def, var)
        return action_definition
    end
    
return Action_Definition