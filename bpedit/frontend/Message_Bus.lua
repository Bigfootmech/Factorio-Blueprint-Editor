local Api = require('bpedit.frontend.Api')
local Keybinds = require('bpedit.frontend.keybinds.Keybinds')

local Message_Bus = {}

local function init()
    for interface_function_name, event_name_table in pairs(Keybinds.get_interface_mapping()) do
        script.on_event(event_name_table, Api[interface_function_name])
    end
    script.on_event(defines.events.on_player_configured_blueprint, Api.stop_editing)
end
Message_Bus.init = init

return Message_Bus