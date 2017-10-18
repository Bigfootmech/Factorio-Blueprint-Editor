local Api = require 'bpedit.keybinds.Api'

local Message_Bus = {}

local function init()
    script.on_event("a-primary-action", Api.edit_or_reopen_blueprint)
    script.on_event("b-secondary-action", Api.add_inner_blueprint)
    script.on_event({"c-up", 
                    "c-up-more", 
                    "d-down", 
                    "d-down-more",
                    "e-left", 
                    "e-left-more",
                    "f-right",  
                    "f-right-more"}, Api.move_inner_blueprint)
    script.on_event(defines.events.on_player_configured_blueprint, Api.stop_editing)
end
Message_Bus.init = init

return Message_Bus