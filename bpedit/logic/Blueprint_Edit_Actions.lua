local Global_Dao = require('bpedit.backend.storage.Global_Dao')
local Blueprint = require('lib.logic.model.blueprint.Blueprint')

local Logic = {}

local function get_player_store(player)
    return Global_Dao.get_player_store(player.index)
end

local function open_blueprint_menu(player)
    player:open_menu(get_player_store(player):get_editable_blueprint())
end
Logic.open_blueprint_menu = open_blueprint_menu

local function begin_editing_blueprint(player)
    player:sendmessage("Opening BP for editing.")
    
    local blueprint = player:get_blueprint_from_hand()
    
    get_player_store(player):set_editable_blueprint(blueprint)
    
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
    local blueprint_adding = player:get_blueprint_from_hand()
    
    get_player_store(player):clear_selection()
    
    local entities = blueprint_adding.get_blueprint_entities()
    
    blueprint_existing = Blueprint.add_entity(blueprint_existing, entities[1])
    local new_entity_number = #blueprint_existing.get_blueprint_entities()
    
    get_player_store(player):set_editable_blueprint(blueprint_existing)
    get_player_store(player):add_entity_number_to_selection(new_entity_number)
    open_blueprint_menu(player)
end
Logic.add_blueprint_to_editing = add_blueprint_to_editing

local function player_move_selection(player, vector)
    player:sendmessage("Moving selection.")
    
    local blueprint_existing = get_player_store(player):get_editable_blueprint()
    local selected_element_nums = get_player_store(player):get_selection_entity_numbers()
    
    local edited_blueprint = Blueprint.move_multiple_entitities_by_vector(blueprint_existing, selected_element_nums, vector)
    
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