--control.lua
local Global_Dao = require 'bpedit.dal.Global_Dao'
local Logic = require 'bpedit.logic.Logic'
local Transformations = require 'bpedit.keybinds.Transformations'
local Player = require 'lib.player.Player'

----------------------- end of imports, start of api -------------------
local function get_player_store(player)
    return Global_Dao.get_player_store(player.index)
end

local function edit_or_reopen_blueprint(event)
    local player = Player.from_event(event)
    
    if player:has_blueprint_in_hand() then
        return Logic.begin_editing_blueprint(player)
    end
    
    if get_player_store(player):is_editing() then
        return Logic.reopen_blueprint_menu(player)
    end
    
    player:sendmessage("Error: No blueprints found for editing (hand, or store)!")
end

local function add_inner_blueprint(event)
    local player = Player.from_event(event)
    
    if not get_player_store(player):is_editing() then
        player:sendmessage("Can't add bp, not currently editing.")
        return false
    end
    
    if not player:has_blueprint_in_hand() then
        player:sendmessage("No blueprint in hand to add.")
        return false
    end
    
    Logic.add_blueprint_to_editing(player)
end

local function move_inner_blueprint(event)
    local player = Player.from_event(event)
    
    if not get_player_store(player):is_editing() then
        player:sendmessage("Can't move selection, not currently editing.")
        return false
    end
    
    if not get_player_store(player):has_selection() then
        player:sendmessage("Can't move selection, don't currently have anything selected.")
        return false
    end
    
    -- TODO: add conflict check with dollies
    
    local vector = Transformations.get_vector_from_direction_command(event.input_name) -- TODO: wanna move the event interpreting in to transformations I think
    
    Logic.player_move_selection(player, vector)
end

local function stop_editing(event)
    local player = Player.from_event(event)
    
    Logic.player_stop_editing(player)
end

----------------------- end of api, start of message bus -------------------

local function register_keybindings()
    script.on_event("a-primary-action", edit_or_reopen_blueprint)
    script.on_event("b-secondary-action", add_inner_blueprint)
    script.on_event({"c-up", 
                    "c-up-more", 
                    "d-down", 
                    "d-down-more",
                    "e-left", 
                    "e-left-more",
                    "f-right",  
                    "f-right-more"}, move_inner_blueprint)
    script.on_event(defines.events.on_player_configured_blueprint, stop_editing)
end

----------------------- end of message bus, start of init -------------------

script.on_init(function()
    Global_Dao.init() 
    register_keybindings() 
end)
