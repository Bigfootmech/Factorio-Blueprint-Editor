local Blueprint_Edit_Actions = require('bpedit.logic.Blueprint_Edit_Actions')
local Global_Dao = require('bpedit.backend.storage.Global_Dao')
local Player = require('lib.frontend.player.Player')
local Blueprint = require('lib.logic.model.blueprint.Blueprint')
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

local function get_blueprint_from_hand(player)
    local stack = player:get_lua_player().cursor_stack
    if not stack or not stack.valid_for_read or stack.type ~= "blueprint" then
      return false
    end
    return stack
end

local function get_player_selected_lua_blueprint(player)
    return get_blueprint_from_hand(player)
end

local function get_player_selected_blueprint(player)
    return Blueprint.from_lua_blueprint(get_player_selected_lua_blueprint(player))
end

local function has_blueprint_in_hand(player)
    if(get_player_selected_lua_blueprint(player))then 
        return true 
    end
    return false
end

local function push_editing_blueprint_to_ui(player, blueprint_local)
    
    local hand_bp = get_player_selected_lua_blueprint(player)
    blueprint_local:dump_to_lua_blueprint(hand_bp)
    
    player:open_menu(hand_bp)
end

function Api.edit_or_reopen_blueprint(event)
    local player = Player.from_event(event)
    
    local local_blueprint = get_player_selected_blueprint(player)
    
    if has_blueprint_in_hand(player) then
        local blueprint_local = Blueprint_Edit_Actions.begin_editing_blueprint(player, local_blueprint)
        return push_editing_blueprint_to_ui(player, blueprint_local)
    end
    
    if is_editing(player) then
        local blueprint_local = Blueprint_Edit_Actions.reopen_blueprint_menu(player)
        return push_editing_blueprint_to_ui(player, blueprint_local)
    end
    
    player:sendmessage("Error: No blueprints found for editing (hand, or store)!")
end

function Api.add_inner_blueprint(event)
    local player = Player.from_event(event)
    
    if not is_editing(player) then
        player:sendmessage("Can't add bp, not currently editing.")
        return false
    end
    
    local blueprint_adding = get_player_selected_blueprint(player)
    
    if not has_blueprint_in_hand(player) then
        player:sendmessage("No blueprint in hand to add.")
        return false
    end
    
    local blueprint_local = Blueprint_Edit_Actions.add_blueprint_to_editing(player, blueprint_adding)
    return push_editing_blueprint_to_ui(player, blueprint_local)
end

function Api.move_inner_blueprint(event)
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
    
    local blueprint_local = Blueprint_Edit_Actions.player_move_selection(player, Keybinds.get_var_for_event(event.input_name))
    return push_editing_blueprint_to_ui(player, blueprint_local)
end

function Api.stop_editing(event)
    local player = Player.from_event(event)
    
    if is_editing(player) then
        Blueprint_Edit_Actions.player_stop_editing(player)
        return true
    end
    
    return false
end

return Api