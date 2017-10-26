local Global_Dao = require('bpedit.backend.storage.Global_Dao')
local Blueprint = require('lib.logic.model.blueprint.Blueprint')
local Table = require('lib.core.types.Table')

local Logic = {}

local function get_player_store(player)
    return Global_Dao.get_player_store(player.index)
end

local function open_blueprint_menu(player)
    local blueprint_existing = get_player_store(player):get_editable_blueprint()
    local hand_bp = player:get_blueprint_from_hand()
    
    blueprint_existing:dump_to_lua_blueprint(hand_bp)
    
    player:open_menu(hand_bp)
end
Logic.open_blueprint_menu = open_blueprint_menu

local function begin_editing_blueprint(player)
    player:sendmessage("Opening BP for editing.")
    
    local local_blueprint = Blueprint.from_lua_blueprint(player:get_blueprint_from_hand())
    
    get_player_store(player):set_editable_blueprint(local_blueprint)
    
    get_player_store(player):clear_selection()
    open_blueprint_menu(player)
end
Logic.begin_editing_blueprint = begin_editing_blueprint

local function reopen_blueprint_menu(player)
    player:sendmessage("Reopening BP.")
    open_blueprint_menu(player)
end
Logic.open_blueprint_menu = open_blueprint_menu

local function add_blueprint_to_editing(player)
    player:sendmessage("Adding bp.")
    
    local blueprint_existing = get_player_store(player):get_editable_blueprint()
    local blueprint_adding = Blueprint.from_lua_blueprint(player:get_blueprint_from_hand())
    
    get_player_store(player):clear_selection()
    
    local entities = blueprint_adding.blueprint_entities
    
    blueprint_existing = blueprint_existing:add_entity(entities[1])
    local new_entity_number = #blueprint_existing.blueprint_entities
    
    get_player_store(player):set_editable_blueprint(blueprint_existing)
    get_player_store(player):add_entity_number_to_selection(new_entity_number)
    
    open_blueprint_menu(player)
end
Logic.add_blueprint_to_editing = add_blueprint_to_editing

local function player_move_selection(player, vector)
    player:sendmessage("Moving selection.")
    
    local blueprint_existing = get_player_store(player):get_editable_blueprint()
    local selected_element_nums = get_player_store(player):get_selection_entity_numbers()
    
    local edited_blueprint = blueprint_existing:move_entities_by_vector(selected_element_nums, vector)
    
    get_player_store(player):set_editable_blueprint(edited_blueprint)
    open_blueprint_menu(player)
end
Logic.player_move_selection = player_move_selection

local function player_stop_editing(player)
    player:sendmessage("Stopped editing.")

    get_player_store(player):clear_editable_blueprint()
end
Logic.player_stop_editing = player_stop_editing

return Logic