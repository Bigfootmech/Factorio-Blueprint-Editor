local Util = require 'lib.events.Util'
local Table = require 'lib.lua_enhance.Table'

local Event_Registration = {}

local registered_events_list ={}
local function add_event_to_registered(event_name)
    table.insert(registered_events_list, event_name)
end
local function get_registered_events_list()
    return Table.deepcopy(registered_events_list)
end
Event_Registration.get_registered_events_list = get_registered_events_list

local registered_locale_text ={}
local function register_locale_text(event_name, locale_text)
    registered_locale_text[event_name] = locale_text
end
local function get_locale_text_for_event(event_name)
    return registered_locale_text[event_name]
end
Event_Registration.get_locale_text_for_event = get_locale_text_for_event -- USE TO GENERATE locale/en/controls.cfg

local registered_key_sequences ={}
local function register_key_sequence(event_name, key_sequence)
    table.insert(registered_key_sequences, Util.get_prototype_table(event_name, key_sequence))
end
local function get_registered_key_sequences(event_name)
    return Table.deepcopy(registered_key_sequences)
end
Event_Registration.get_registered_key_sequences = get_registered_key_sequences

local registered_var ={}
local function register_var(event_name, var)
    registered_var[event_name] = var
end
local function get_var_for_event(event_name)
    return registered_var[event_name]
end
Event_Registration.get_var_for_event = get_var_for_event

local registered_api_for_event = {}
local registered_events_for_api = {}
local function register_event_to_api(event_name, api)
    if type(registered_events_for_api[api]) ~= "table" then registered_events_for_api[api] = {} end
    return table.insert(registered_events_for_api[api], event_name)
end
local function register_api(event_name, api)
    registered_api_for_event[event_name] = api
    register_event_to_api(event_name, api)
end
local function get_api_for_event(event_name)
    return registered_var[event_name]
end
Event_Registration.get_api_for_event = get_api_for_event
local function get_api_register_list()
    return Table.deepcopy(registered_events_for_api)
end
Event_Registration.get_interface_mapping = get_api_register_list

----------------------------------------------------------------

local function register_command(action_name, locale_text, key_sequence , linked_function, var)
    local new_event_number = #registered_events_list + 1
    local event_name = Util.get_event_name(action_name, new_event_number)
    register_locale_text(event_name, locale_text)
    register_key_sequence(event_name, key_sequence)
    register_api(event_name, linked_function)
    if var ~= nil then
        register_var(event_name, var)
    end
    add_event_to_registered(event_name) -- do I need to preserve action_name here??
    return true
end
Event_Registration.register_command = register_command

local function register_command_from_action_definition(action_definition)
    return register_command(
    action_definition[Util.action_name_field_name], 
    action_definition[Util.locale_text_field_name], 
    action_definition[Util.key_sequence_field_name], 
    action_definition[Util.linked_function_field_name], 
    action_definition[Util.var_field_name])
end
Event_Registration.register_command_from_action_definition = register_command_from_action_definition

return Event_Registration