local Actions = require 'bpedit.keybinds.Actions'

local Message_Bus = {}

local function init()
    for inetface_function, event_name_table in pairs(Actions.get_interface_mapping()) do
        script.on_event(event_name_table, inetface_function)
    end
    script.on_event(defines.events.on_player_configured_blueprint, Api.stop_editing)
end
Message_Bus.init = init

return Message_Bus