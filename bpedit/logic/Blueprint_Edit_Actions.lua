local Global_Dao = require('bpedit.backend.storage.Global_Dao')

local Logic = {}

local function get_player_store(player)
    return Global_Dao.get_player_store(player.index)
end

local function get_editing_blueprint(player)
    return get_player_store(player):get_editable_blueprint()
end

local function begin_editing_blueprint(player, local_blueprint)
    player:sendmessage("Opening BP for editing.")
    
    get_player_store(player):set_editable_blueprint(local_blueprint)
    get_player_store(player):clear_selection()
    
    return local_blueprint
end
Logic.begin_editing_blueprint = begin_editing_blueprint

local function reopen_blueprint_menu(player)
    player:sendmessage("Reopening BP.")
    
    local blueprint_existing = get_player_store(player):get_editable_blueprint()
    
    return blueprint_existing
end
Logic.reopen_blueprint_menu = reopen_blueprint_menu

local function add_blueprint_to_editing(player, blueprint_adding)
    player:sendmessage("Adding bp.")
    
    local blueprint_existing = get_player_store(player):get_editable_blueprint()
    get_player_store(player):clear_selection()
    
    local entities = blueprint_adding.blueprint_entities
    
    local new_entity_number = #entities + 1
    blueprint_existing = blueprint_existing:add_entity(entities[1])
    
    get_player_store(player):set_editable_blueprint(blueprint_existing)
    get_player_store(player):add_entity_number_to_selection(new_entity_number)
    return blueprint_existing
end
Logic.add_blueprint_to_editing = add_blueprint_to_editing

local function player_move_selection(player, vector)
    player:sendmessage("Moving selection.")
    
    local blueprint_existing = get_player_store(player):get_editable_blueprint()
    local selected_element_nums = get_player_store(player):get_selection_entity_numbers()
    
    local edited_blueprint = blueprint_existing:move_entities_by_vector(selected_element_nums, vector)
    
    get_player_store(player):set_editable_blueprint(edited_blueprint)
    
    return edited_blueprint
end
Logic.player_move_selection = player_move_selection

local function player_stop_editing(player)
    player:sendmessage("Stopped editing.")
    
    local blueprint_existing = get_player_store(player):get_editable_blueprint()

    get_player_store(player):clear_editing()
    
    return blueprint_existing
end
Logic.player_stop_editing = player_stop_editing

return Logic