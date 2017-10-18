--control.lua
local Global_Dao = require 'bpedit.dal.Global_Dao'
local Api = require 'bpedit.keybinds.Api'

----------------------- end of imports, start of message bus -------------------

local function register_keybindings()
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

----------------------- end of message bus, start of init -------------------

script.on_init(function()
    Global_Dao.init() 
    register_keybindings() 
end)
