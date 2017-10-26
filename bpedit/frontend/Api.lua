local Global_Dao = require('bpedit.backend.storage.Global_Dao')
local Player = require('lib.frontend.player.Player')
local Table = require('lib.core.types.Table')
local Blueprint_Edit_Actions = require('bpedit.logic.Blueprint_Edit_Actions')
local Keybinds = require('bpedit.frontend.keybinds.Keybinds')

local Api = {}

local function get_player_store(player)
    return Global_Dao.get_player_store(player.index)
end

local function is_editing(player)
    return get_player_store(player):is_editing()
end

local function has_blueprint_selection(player)
    return get_player_store(player):has_selection()
end

local function has_mouseover_selection(player)
    return player:get_selected()
end

local function has_item_gui_open(player)
    return player:get_open_gui_type() == defines.gui_type.item
end

local function has_blueprint_in_hand(player)
    if(player:get_blueprint_from_hand()) then return true end
    return false
end

local function edit_or_reopen_blueprint(event)
    local player = Player.from_event(event)
    
    if has_blueprint_in_hand(player) then
        return Blueprint_Edit_Actions.begin_editing_blueprint(player)
    end
    
    if is_editing(player) then
        return Blueprint_Edit_Actions.reopen_blueprint_menu(player)
    end
    
    player:sendmessage("Error: No blueprints found for editing (hand, or store)!")
end
Api.edit_or_reopen_blueprint = edit_or_reopen_blueprint

local function add_inner_blueprint(event)
    local player = Player.from_event(event)
    
    if not is_editing(player) then
        player:sendmessage("Can't add bp, not currently editing.")
        return false
    end
    
    if not has_blueprint_in_hand(player) then
        player:sendmessage("No blueprint in hand to add.")
        return false
    end
    
    Blueprint_Edit_Actions.add_blueprint_to_editing(player)
end
Api.add_inner_blueprint = add_inner_blueprint

local function move_inner_blueprint(event)
    local player = Player.from_event(event)
    
    if not is_editing(player) then
        player:sendmessage("Can't move selection, not currently editing.")
        return false
    end
    
    if not has_blueprint_selection(player) then
        player:sendmessage("Can't move selection, don't currently have anything selected.")
        return false
    end
    
    -- TODO: add conflict check with dollies
    
    Blueprint_Edit_Actions.player_move_selection(player, Keybinds.get_var_for_event(event.input_name))
end
Api.move_inner_blueprint = move_inner_blueprint

local function stop_editing(event)
    local player = Player.from_event(event)
    
    if is_editing(player) then
        Blueprint_Edit_Actions.player_stop_editing(player)
        return true
    end
    
    return false
end
Api.stop_editing = stop_editing

return Api