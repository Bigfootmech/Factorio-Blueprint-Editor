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
    return player:get_selected() ~= nil
end

local function has_item_gui_open(player)
    return player:get_open_gui_type() == defines.gui_type.item
end

local function get_blueprint_from_hand(player)
    local stack = player:get_cursor_stack()
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

local function put_fresh_bp_in_player_hand(player)
    local stack = player:get_cursor_stack()
    stack.set_stack{name="blueprint"}
    return stack
end

local function destroy_stack_in_player_hand(player)
    local stack = player:get_cursor_stack()
    stack.clear() -- kills UI :(
end

local function fast_open_inventory(player)
    destroy_stack_in_player_hand(player)
    player:open_inventory()
end

local function put_plueprint_local_in_player_hand(player, blueprint_local)
    local cursor_is_clean = player:clean_cursor()
    assert(cursor_is_clean, "Failed to clean cursor")
    
    local hand_lua_bp = put_fresh_bp_in_player_hand(player)
    
    blueprint_local:dump_to_lua_blueprint(hand_lua_bp)
    return hand_lua_bp
end

local function push_editing_blueprint_to_ui(player, blueprint_local)
    
    local hand_lua_bp = put_plueprint_local_in_player_hand(player, blueprint_local)
    
    player:open_menu(hand_lua_bp)
    
    -- destroy_stack_in_player_hand(player)
end

function Api.edit_or_reopen_blueprint(event)
    local player = Player.from_event(event)
    
    if is_editing(player) then
        if not has_item_gui_open(player)then
            local blueprint_local = Blueprint_Edit_Actions.reopen_blueprint_menu(player)
            return push_editing_blueprint_to_ui(player, blueprint_local)
        end
        return fast_open_inventory(player)
    end
    
    if has_blueprint_in_hand(player) then
        local local_blueprint = get_player_selected_blueprint(player)
        destroy_stack_in_player_hand(player)
        local blueprint_local = Blueprint_Edit_Actions.begin_editing_blueprint(player, local_blueprint)
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
    
    if not has_item_gui_open(player)then -- TODO: check conflict check with dollies
        return false
    end
    
    if not is_editing(player) then
        player:sendmessage("Can't move selection, not currently editing.")
        return false
    end
    
    if not has_blueprint_selection(player) then
        player:sendmessage("Can't move selection, don't currently have anything selected.")
        return false
    end
    
    destroy_stack_in_player_hand(player)
    
    local blueprint_local = Blueprint_Edit_Actions.player_move_selection(player, Keybinds.get_var_for_event(event.input_name))
    return push_editing_blueprint_to_ui(player, blueprint_local)
end

function Api.stop_editing(event)
    local player = Player.from_event(event)
    
    if is_editing(player) then
        local blueprint_local = Blueprint_Edit_Actions.player_stop_editing(player)
        -- put_plueprint_local_in_player_hand(player, blueprint_local)
        return true
    end
    
    return false
end

return Api