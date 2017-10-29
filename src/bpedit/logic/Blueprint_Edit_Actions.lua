local Global_Dao = require('bpedit.backend.storage.Global_Dao')

local Logic = {}

local function get_player_store(player)
    return Global_Dao.get_player_store(player.index)
end

local function get_editing_blueprint(player)
    return get_player_store(player):get_editable_blueprint()
end

function Logic.begin_editing_blueprint(player, local_blueprint)
    player:sendmessage("Opening BP for editing.")
    
    get_player_store(player):set_editable_blueprint(local_blueprint)
    get_player_store(player):clear_selection()
    
    return local_blueprint
end

function Logic.reopen_blueprint_menu(player)
    player:sendmessage("Reopening BP.")
    
    local blueprint_existing = get_player_store(player):get_editable_blueprint()
    
    return blueprint_existing
end

function Logic.add_blueprint_to_editing(player, blueprint_adding)
    player:sendmessage("Adding bp.")
    
    local blueprint_existing = get_player_store(player):get_editable_blueprint()
    get_player_store(player):clear_selection()
    
    local entities = blueprint_adding.blueprint_entities
    
    local touple = blueprint_existing:add_entity(entities[1])
    blueprint_existing = touple[1]
    local new_entity_numbers = touple[2] -- needs better encapsulation
    
    get_player_store(player):set_editable_blueprint(blueprint_existing)
    get_player_store(player):set_selection_entity_numbers(new_entity_numbers)
    return blueprint_existing
end

function Logic.player_move_selection(player, vector)
    player:sendmessage("Moving selection.")
    
    local blueprint_existing = get_player_store(player):get_editable_blueprint()
    local selected_element_nums = get_player_store(player):get_selection_entity_numbers()
    
    local edited_blueprint = blueprint_existing:move_entities_by_vector(selected_element_nums, vector)
    
    get_player_store(player):set_editable_blueprint(edited_blueprint)
    
    return edited_blueprint
end

function Logic.anchor_to_selection(player)
    player:sendmessage("Setting blueprint origin to selection.")
    
    local blueprint_existing = get_player_store(player):get_editable_blueprint()
    local selected_element_nums = get_player_store(player):get_selection_entity_numbers()
    
    -- local entity_group = blueprint_existing:get_group(selected_element_nums)
    -- local centre = entity_group:get_centre()
    local selected_el = blueprint_existing[selected_element_nums[1]] -- massive cludge
    local centre = selected_el["position"]
    
    local move_opposite = centre:as_vector_from_origin():get_inverse()
    
    local edited_blueprint = blueprint_existing:move_all_entities_and_tiles_by_vector(selected_element_nums, move_opposite)
    
    get_player_store(player):set_editable_blueprint(edited_blueprint)
    
    return edited_blueprint
end

function Logic.player_stop_editing(player)
    player:sendmessage("Stopped editing.")
    
    local blueprint_existing = get_player_store(player):get_editable_blueprint()

    get_player_store(player):clear_editing()
    
    return blueprint_existing
end

return Logic