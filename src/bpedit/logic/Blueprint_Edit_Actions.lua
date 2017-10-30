local Object = require('lib.core.types.Object')
local Global_Dao = require('bpedit.backend.storage.Global_Dao')

local Blueprint_Edit_Actions = Object.new_class()

local function get_player_store(player)
    return Global_Dao.get_player_store(player.index)
end

local function get_editable_blueprint(player)
    return get_player_store(player):get_editable_blueprint()
end

local function get_selection(player)
    return get_player_store(player):get_selection_entity_numbers()
end

local function correct_selection_number_for_entities_total(next_index, entity_total)
    local modded = next_index % entity_total
    if(modded == 0)then
        return entity_total
    end
    return modded
end

local function has_no_selection(selected_entity_nums)
    return selected_entity_nums == nil or #selected_entity_nums == 0
end

local function has_one_element_selection(selected_entity_nums)
    return selected_entity_nums ~= nil and #selected_entity_nums == 1
end

local function has_multiple_element_selection(selected_entity_nums)
    return selected_entity_nums ~= nil and #selected_entity_nums > 1
end

function Blueprint_Edit_Actions.begin_editing_blueprint(player, local_blueprint)
    player:sendmessage("Opening BP for editing.")
    
    get_player_store(player):set_editable_blueprint(local_blueprint)
    get_player_store(player):clear_selection()
    
    return local_blueprint
end

function Blueprint_Edit_Actions.reopen_blueprint_menu(player)
    player:sendmessage("Reopening BP.")
    
    local blueprint_existing = get_editable_blueprint(player)
    
    return blueprint_existing
end

function Blueprint_Edit_Actions.switch_selection(player)
    player:sendmessage("Setting blueprint origin to selection.")
    
    local editable_blueprint = get_editable_blueprint(player)
    
    if(not editable_blueprint:has_entities())then
        return false
    end
    
    local selected_entity_nums = get_selection(player)
    
    local new_selection
    
    if(not has_one_element_selection(selected_entity_nums))then
        new_selection = 1
    else 
        local current_selection = selected_entity_nums[1]
        local next_index = current_selection + 1
        next_index = correct_selection_number_for_entities_total(next_index, editable_blueprint:get_number_of_entities())
        new_selection = next_index
    end
    
    get_player_store(player):set_selection_entity_numbers({new_selection})
    
    player:sendmessage("New selection: " .. Object.to_string(editable_blueprint:get_entity(new_selection)))
end

function Blueprint_Edit_Actions.player_move_selection(player, vector)
    player:sendmessage("Moving selection.")
    
    local blueprint_existing = get_editable_blueprint(player)
    local selected_entity_nums = get_selection(player)
    
    local edited_blueprint = blueprint_existing:move_entities_by_vector(selected_entity_nums, vector)
    
    get_player_store(player):set_editable_blueprint(edited_blueprint)
    
    return edited_blueprint
end

function Blueprint_Edit_Actions.player_rotate_selection(player, amount)
    player:sendmessage("Rotating selection.")
    
    local blueprint_existing = get_editable_blueprint(player)
    local selected_entity_nums = get_selection(player)
    
    local edited_blueprint = blueprint_existing:rotate_entities_by_amount(selected_entity_nums, amount)
    
    get_player_store(player):set_editable_blueprint(edited_blueprint)
    
    return edited_blueprint
end

function Blueprint_Edit_Actions.add_blueprint_to_editing(player, blueprint_adding)
    player:sendmessage("Adding bp.")
    
    local blueprint_existing = get_editable_blueprint(player)
    get_player_store(player):clear_selection()
    
    local entities = blueprint_adding.blueprint_entities
    
    local touple = blueprint_existing:add_entity(entities[1])
    blueprint_existing = touple[1]
    local new_entity_numbers = touple[2] -- needs better encapsulation
    
    get_player_store(player):set_editable_blueprint(blueprint_existing)
    get_player_store(player):set_selection_entity_numbers(new_entity_numbers)
    return blueprint_existing
end

function Blueprint_Edit_Actions.anchor_to_selection(player)
    player:sendmessage("Setting blueprint origin to selection.")
    
    local blueprint_existing = get_editable_blueprint(player)
    local selected_entity_nums = get_selection(player)
    
    -- local entity_group = blueprint_existing:get_group(selected_entity_nums)
    -- local centre = entity_group:get_centre()
    local selected_el = blueprint_existing.blueprint_entities[selected_entity_nums[1]] -- massive cludge
    local centre = selected_el["position"]
    
    local move_opposite = centre:as_vector_from_origin():get_inverse()
    
    local edited_blueprint = blueprint_existing:move_all_entities_and_tiles_by_vector(move_opposite)
    
    get_player_store(player):set_editable_blueprint(edited_blueprint)
    
    return edited_blueprint
end

function Blueprint_Edit_Actions.anchor_blueprint_to_point(blueprint, loc_var)
    local bounding_box = blueprint:get_bounding_box()
    
    local point = bounding_box:get_point(loc_var)
    local move_opposite = point:as_vector_from_origin():get_inverse()
    
    local edited_blueprint = blueprint:move_all_entities_and_tiles_by_vector(move_opposite)
    
    return edited_blueprint
end

function Blueprint_Edit_Actions.anchor_editing_to_point(player, loc_var)
    local blueprint_existing = get_editable_blueprint(player)

    local edited_blueprint = Blueprint_Edit_Actions.anchor_blueprint_to_point(blueprint_existing, loc_var)
    
    get_player_store(player):set_editable_blueprint(edited_blueprint)
    
    return edited_blueprint
end

function Blueprint_Edit_Actions.player_stop_editing(player)
    player:sendmessage("Stopped editing.")
    
    local blueprint_existing = get_editable_blueprint(player)

    get_player_store(player):clear_editing()
    
    return blueprint_existing
end

return Blueprint_Edit_Actions