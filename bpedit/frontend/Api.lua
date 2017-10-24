local Global_Dao = require('bpedit.backend.storage.Global_Dao')
local Player = require('lib.backend.gamedata.player.Player')
local Table = require('lib.core.types.Table')
local Blueprint_Edit_Actions = require('bpedit.logic.Blueprint_Edit_Actions')
local Keybinds = require('bpedit.frontend.keybinds.Keybinds')

local Api = {}

local function get_player_store(player)
    return Global_Dao.get_player_store(player.index)
end

local function edit_or_reopen_blueprint(event)
    local player = Player.from_event(event)
    
    if player:has_blueprint_in_hand() then
        return Blueprint_Edit_Actions.begin_editing_blueprint(player)
    end
    
    if get_player_store(player):is_editing() then
        return Blueprint_Edit_Actions.reopen_blueprint_menu(player)
    end
    
    player:sendmessage("Error: No blueprints found for editing (hand, or store)!")
end
Api.edit_or_reopen_blueprint = edit_or_reopen_blueprint

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
    
    Blueprint_Edit_Actions.add_blueprint_to_editing(player)
end
Api.add_inner_blueprint = add_inner_blueprint

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
    
    Blueprint_Edit_Actions.player_move_selection(player, Keybinds.get_var_for_event(event.input_name))
end
Api.move_inner_blueprint = move_inner_blueprint

local function stop_editing(event)
    local player = Player.from_event(event)
    
    Blueprint_Edit_Actions.player_stop_editing(player)
end
Api.stop_editing = stop_editing

return Api