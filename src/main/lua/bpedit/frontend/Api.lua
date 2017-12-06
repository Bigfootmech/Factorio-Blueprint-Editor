local Object = require('lib.core.types.Object')
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

local function indoctrinate_blueprint(blueprint)
    return Blueprint.from_lua_blueprint(blueprint)
end

local function get_lua_stack_from_hand(player)
    local stack = player:get_cursor_stack()
    if(not stack)then
        -- print ("not stack") -- log.debug
        return false
    end
    if(not stack.valid_for_read)then
        -- print ("not valid for read") -- log.debug
        return false
    end
    return stack
end

local function get_lua_blueprint_from_hand(player)
    local stack = get_lua_stack_from_hand(player)
    if(stack.type ~= "blueprint")then
        -- print ("not blueprint") -- log.debug
        return false
    end
    return stack
end

local function get_blueprint_from_hand(player)
    return indoctrinate_blueprint(get_lua_blueprint_from_hand(player))
end

local function get_player_selected_lua_blueprint(player)
    return get_lua_blueprint_from_hand(player)
end

local function get_player_selected_blueprint(player)
    return indoctrinate_blueprint(get_player_selected_lua_blueprint(player))
end

local function has_something_in_hand(player)
    if(get_lua_stack_from_hand(player))then 
        return true 
    end
    return false
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

local function stow_stack_in_player_hand(player)
    return player:clean_cursor()
end

local function destroy_stack_in_player_hand(player)
    local stack = player:get_cursor_stack()
    stack.clear() -- kills UI :(
end

local function fast_open_inventory(player)
    destroy_stack_in_player_hand(player)
    player:open_inventory()
end

local function put_blueprint_local_in_player_hand(player, blueprint_local)
    local cursor_is_clean = stow_stack_in_player_hand(player)
    assert(cursor_is_clean, "Failed to clean cursor")
    
    local hand_lua_bp = put_fresh_bp_in_player_hand(player)
    
    blueprint_local:dump_to_lua_blueprint(hand_lua_bp)
    return hand_lua_bp
end

local function push_editing_blueprint_to_ui(player, blueprint_local)
    
    local hand_lua_bp = put_blueprint_local_in_player_hand(player, blueprint_local)
    
    player:open_menu(hand_lua_bp)
    
    -- destroy_stack_in_player_hand(player)
end

local function get_var(event)
    return Keybinds:get_var_for_event(event.input_name)
end

function Api.edit_or_reopen_blueprint(event)
    local player = Player.from_event(event)
    
    if(is_editing(player))then
        if not has_item_gui_open(player)then
            local blueprint_local = Blueprint_Edit_Actions.reopen_blueprint_menu(player)
            return push_editing_blueprint_to_ui(player, blueprint_local)
        end
        return fast_open_inventory(player)
    end
    
    if(has_blueprint_in_hand(player))then
        local local_blueprint = get_player_selected_blueprint(player)
        destroy_stack_in_player_hand(player)
        local blueprint_local = Blueprint_Edit_Actions.begin_editing_blueprint(player, local_blueprint)
        return push_editing_blueprint_to_ui(player, blueprint_local)
    end
    
    player:sendmessage("Error: No blueprints found for editing (hand, or store)!")
end

function Api.cancel(event)
    local player = Player.from_event(event)
    
    if(not is_editing(player))then
        return false
    end
    
    local blueprint_local = Blueprint_Edit_Actions.cancel(player)

    return push_editing_blueprint_to_ui(player, blueprint_local)
end

function Api.switch_selection(event)
    local player = Player.from_event(event)
    
    if(not has_item_gui_open(player))then
        return false
    end
    
    if not is_editing(player) then
        return false
    end
    
    Blueprint_Edit_Actions.switch_selection(player)
end

function Api.delete_selection(event)
    local player = Player.from_event(event)
    
    if(not has_item_gui_open(player))then
        return false
    end
    
    if(not is_editing(player))then
        return false
    end
    
    if(not has_blueprint_selection(player))then
        player:sendmessage("Can't delete selection, has no selection.")
        return false
    end
    
    local blueprint_local = Blueprint_Edit_Actions.delete_selection(player)

    return push_editing_blueprint_to_ui(player, blueprint_local)
end

function Api.move(event)
    local player = Player.from_event(event)
    
    if not has_item_gui_open(player)then
        return false
    end
    
    if not is_editing(player) then
        player:sendmessage("Can't move selection, not currently editing.")
        return false
    end
    
    if(has_mouseover_selection(player))then -- conflict resolution with dollies
        return false
    end
    
    destroy_stack_in_player_hand(player)
    
    local blueprint_local = Blueprint_Edit_Actions.player_move(player, get_var(event))

    return push_editing_blueprint_to_ui(player, blueprint_local)
end

local function error_handler(msg)
    log(msg .. "\n" .. debug.traceback())
end

function Api.rotate(event)
    local player = Player.from_event(event)
    
    if not has_item_gui_open(player)then
        return false
    end
    
    if has_mouseover_selection(player)then
        return false
    end
    
    if not is_editing(player) then
        return false
    end
    
    --[[
    if not is_editing_blueprint_in_player_hand(player) then
        return false
    end
    ]]
    
    destroy_stack_in_player_hand(player)
    
    local status, err_or_blueprint_local = xpcall(Blueprint_Edit_Actions.player_rotate, error_handler, player, get_var(event))
    --local blueprint_local = Blueprint_Edit_Actions.player_rotate(player, get_var(event))
    
    return push_editing_blueprint_to_ui(player, err_or_blueprint_local)
end

function Api.mirror(event)
    local player = Player.from_event(event)
    
    if not has_item_gui_open(player)then
        return false
    end
    
    if has_mouseover_selection(player)then
        return false
    end
    
    --[[
    if not is_editing_blueprint_in_player_hand(player) then
        return false
    end
    ]]
    
    if not is_editing(player) then
        return false
    end
    
    destroy_stack_in_player_hand(player)
    
    local blueprint_local = Blueprint_Edit_Actions.player_mirror(player, get_var(event))
    
    return push_editing_blueprint_to_ui(player, blueprint_local)
end

function Api.add_component(event)
    local player = Player.from_event(event)
    
    if not is_editing(player) then
        player:sendmessage("Can't add bp, not currently editing.")
        return false
    end
    
    if has_blueprint_in_hand(player) then
        local blueprint_adding = get_player_selected_blueprint(player)
        local blueprint_local = Blueprint_Edit_Actions.add_blueprint_to_editing(player, blueprint_adding)
        return push_editing_blueprint_to_ui(player, blueprint_local)
    end
    
    if has_something_in_hand(player) then
        local item_stack = get_lua_stack_from_hand(player)
        local blueprint_local = Blueprint_Edit_Actions.add_entity_from_item_stack_to_editing(player, item_stack)
        return push_editing_blueprint_to_ui(player, blueprint_local)
    end
    
    player:sendmessage("Nothing in hand to add.")
    return false
end

function Api.copy(event)
    
    local player = Player.from_event(event)
    
    if(is_editing(player))then
        if(not has_blueprint_selection(player))then
            player:sendmessage("Cannot copy. No selection.")
            return false
        end
        
        destroy_stack_in_player_hand(player)
        
        local blueprint_modified = Blueprint_Edit_Actions.copy(player)
    
        return push_editing_blueprint_to_ui(player, blueprint_modified)
    end
    
    if(not has_blueprint_in_hand(player))then
        return false
    end
    
    local blueprint = get_blueprint_from_hand(player)
    local stowed = stow_stack_in_player_hand(player)
    if(not stowed)then
        player:sendmessage("No space to copy hand.")
        return false
    end
    player:sendmessage("Copying hand.")
    put_blueprint_local_in_player_hand(player, blueprint)
    return true
end

function Api.anchor_to_selection(event)
    local player = Player.from_event(event)
    
    if(not has_item_gui_open(player))then
        return false
    end
    
    if(not is_editing(player))then
        player:sendmessage("Cannot set anchor. Not editing blueprint.")
        return false
    end
    
    if(not has_blueprint_selection(player))then
        player:sendmessage("Cannot set anchor. No selection.")
        return false
    end
    
    local blueprint_local = Blueprint_Edit_Actions.anchor_to_selection(player)
    return push_editing_blueprint_to_ui(player, blueprint_local)
end

function Api.move_blueprint_anchor_to(event)
    local player = Player.from_event(event)
    
    if is_editing(player) then
        destroy_stack_in_player_hand(player)
        local blueprint_local = Blueprint_Edit_Actions.anchor_editing_to_point(player, get_var(event))
        return push_editing_blueprint_to_ui(player, blueprint_local)
    end
    
    if(not has_blueprint_in_hand(player))then
        return false
    end
    
    local blueprint = get_blueprint_from_hand(player)
    
    destroy_stack_in_player_hand(player)
    
    local blueprint_modified = Blueprint_Edit_Actions.anchor_blueprint_to_point(blueprint, get_var(event))

    put_blueprint_local_in_player_hand(player, blueprint_modified)
end

function Api.finish_editing(event)
    local player = Player.from_event(event)
    
    if(not is_editing(player))then
        return false
    end
    
    if has_item_gui_open(player)then
        player:close_ui() -- close ui would be better
    end
    
    local blueprint_local = Blueprint_Edit_Actions.player_finish_editing(player)
    -- put_plueprint_local_in_player_hand(player, blueprint_local)
    return true
end

return Api