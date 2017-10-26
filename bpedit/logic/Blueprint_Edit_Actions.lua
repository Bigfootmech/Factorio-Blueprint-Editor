local Global_Dao = require('bpedit.backend.storage.Global_Dao')
local Blueprint = require('lib.logic.model.blueprint.Blueprint')
local Table = require('lib.core.types.Table')

local Logic = {}

local function get_player_store(player)
    return Global_Dao.get_player_store(player.index)
end

local function get_editing_blueprint(player)
    return get_player_store(player):get_editable_blueprint()
end

local function get_player_selected_lua_blueprint(player)
    return player:get_blueprint_from_hand()
end

local function get_player_selected_blueprint(player)
    return Blueprint.from_lua_blueprint(get_player_selected_lua_blueprint(player))
end

local function push_editing_blueprint_to_ui(player)
    local blueprint_existing = get_editing_blueprint(player)
    
    local hand_bp = get_player_selected_lua_blueprint(player)
    blueprint_existing:dump_to_lua_blueprint(hand_bp)
    
    player:open_menu(hand_bp)
end
Logic.open_blueprint_menu = push_editing_blueprint_to_ui

local function begin_editing_blueprint(player)
    player:sendmessage("Opening BP for editing.")
    
    local local_blueprint = get_player_selected_blueprint(player)
    
    get_player_store(player):set_editable_blueprint(local_blueprint)
    get_player_store(player):clear_selection()
    
    push_editing_blueprint_to_ui(player)
end
Logic.begin_editing_blueprint = begin_editing_blueprint

local function reopen_blueprint_menu(player)
    player:sendmessage("Reopening BP.")
    
    push_editing_blueprint_to_ui(player)
end
Logic.open_blueprint_menu = push_editing_blueprint_to_ui

local function add_blueprint_to_editing(player)
    player:sendmessage("Adding bp.")
    
    local blueprint_existing = get_editing_blueprint(player)
    local blueprint_adding = get_player_selected_blueprint(player)
    
    get_player_store(player):clear_selection()
    
    local entities = blueprint_adding.blueprint_entities
    
    blueprint_existing = blueprint_existing:add_entity(entities[1])
    local new_entity_number = #blueprint_existing.blueprint_entities
    
    get_player_store(player):set_editable_blueprint(blueprint_existing)
    get_player_store(player):add_entity_number_to_selection(new_entity_number)
    
    push_editing_blueprint_to_ui(player)
end
Logic.add_blueprint_to_editing = add_blueprint_to_editing

local function player_move_selection(player, vector)
    player:sendmessage("Moving selection.")
    
    local blueprint_existing = get_editing_blueprint(player)
    local selected_element_nums = get_player_store(player):get_selection_entity_numbers()
    
    local edited_blueprint = blueprint_existing:move_entities_by_vector(selected_element_nums, vector)
    
    get_player_store(player):set_editable_blueprint(edited_blueprint)
    push_editing_blueprint_to_ui(player)
end
Logic.player_move_selection = player_move_selection

local function player_stop_editing(player)
    player:sendmessage("Stopped editing.")

    get_player_store(player):clear_editable_blueprint()
end
Logic.player_stop_editing = player_stop_editing

return Logic