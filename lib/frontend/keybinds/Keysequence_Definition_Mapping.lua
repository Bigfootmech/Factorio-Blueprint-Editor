local Util = require('lib.frontend.keybinds.Util')
local Table = require('lib.core.types.Table')

local Keysequence_Definition_Mapping = {}

local function get_locale_text(ordered_action_definitions)
    local locale_text ={}
    
    for i,action_definition in ipairs(ordered_action_definitions) do
        local event_name = Util.get_event_name(action_definition[Util.action_name_field_name], i)
        locale_text[event_name] = action_definition[Util.locale_text_field_name]
        return true
    end
    
    return locale_text
end
Keysequence_Definition_Mapping.get_locale_text = get_locale_text -- USE TO GENERATE locale/en/controls.cfg

local function get_registered_key_sequences(ordered_action_definitions)
    local registered_key_sequences ={}
    
    for i,action_definition in ipairs(ordered_action_definitions) do
        local event_name = Util.get_event_name(action_definition[Util.action_name_field_name], i)
        table.insert(registered_key_sequences, Util.get_prototype_table(event_name, action_definition[Util.key_sequence_field_name]))
    end
    
    return registered_key_sequences
end
Keysequence_Definition_Mapping.get_registered_key_sequences = get_registered_key_sequences

local function get_var_for_event(event_name_to_match, ordered_action_definitions)
    for i,action_definition in ipairs(ordered_action_definitions) do
        local event_name = Util.get_event_name(action_definition[Util.action_name_field_name], i)
        if(event_name_to_match == event_name) then
            return action_definition[Util.var_field_name]
        end
    end
    return nil -- error?
end
Keysequence_Definition_Mapping.get_var_for_event = get_var_for_event

local function get_api_register_list(ordered_action_definitions)
    local registered_events_for_api = {}
    
    for i,action_definition in ipairs(ordered_action_definitions) do
        local event_name = Util.get_event_name(action_definition[Util.action_name_field_name], i)
        local api_name = action_definition[Util.linked_function_field_name]
        
        registered_events_for_api[api_name] = registered_events_for_api[api_name] or {}
        -- if type(registered_events_for_api[api_name]) ~= "table" then registered_events_for_api[api_name] = {} end
        table.insert(registered_events_for_api[api_name], event_name)
    end
    
    return registered_events_for_api
end
Keysequence_Definition_Mapping.get_interface_mapping = get_api_register_list

return Keysequence_Definition_Mapping