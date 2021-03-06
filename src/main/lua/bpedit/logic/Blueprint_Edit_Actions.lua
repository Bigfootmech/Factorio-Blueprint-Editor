local Object = require('lib.core.types.Object')
local Global_Dao = require('bpedit.backend.storage.Global_Dao')
local Blueprint_Entity = require('lib.logic.model.blueprint.Blueprint_Entity')

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

local function has_no_selection(player)
    return not get_player_store(player):has_selection()
end

local function has_one_element_selection(selected_entity_nums)
    return selected_entity_nums ~= nil and selected_entity_nums:size() == 1
end

local function has_multiple_element_selection(selected_entity_nums)
    return selected_entity_nums ~= nil and selected_entity_nums:size() > 1
end

function Blueprint_Edit_Actions.begin_editing_new_blueprint(player)
    player:sendmessage("Starting new blueprint.")
    
    return get_player_store(player):start_new_blueprint()
end

function Blueprint_Edit_Actions.begin_editing_blueprint(player, local_blueprint)
    player:sendmessage("Opening BP for editing.")
    
    get_player_store(player):set_editable_blueprint(local_blueprint)
    get_player_store(player):clear_selection()
    
    return local_blueprint
end

function Blueprint_Edit_Actions.cancel(player)
    
    local blueprint_existing = get_editable_blueprint(player)
    
    if(get_player_store(player):has_selection())then
        player:sendmessage("Clearing selection.")
        get_player_store(player):clear_selection()
        
        return blueprint_existing
    end
    
    return blueprint_existing
end

function Blueprint_Edit_Actions.reopen_blueprint_menu(player)
    player:sendmessage("Reopening BP.")
    
    local blueprint_existing = get_editable_blueprint(player)
    
    return blueprint_existing
end

function Blueprint_Edit_Actions.switch_selection(player)
    
    local editable_blueprint = get_editable_blueprint(player)
    
    if(not editable_blueprint:has_entities())then
        player:sendmessage("Cannot select element of empty blueprint.")
        return false
    end
    
    local selected_entity_nums = get_selection(player)
    
    local new_selection
    
    if(not has_one_element_selection(selected_entity_nums))then
        new_selection = 1
    else 
        local current_selection = selected_entity_nums:to_array()[1]
        local next_index = current_selection + 1
        next_index = correct_selection_number_for_entities_total(next_index, editable_blueprint:get_number_of_entities())
        new_selection = next_index
    end
    
    get_player_store(player):set_selection_entity_numbers({new_selection})
    
    player:sendmessage("New selection: " .. editable_blueprint:get_entity(new_selection):to_string())
end

function Blueprint_Edit_Actions.delete_selection(player)
    player:sendmessage("Deleting selection.")
    
    local blueprint_existing = get_editable_blueprint(player)
    local selected_entity_nums = get_selection(player)
    
    blueprint_existing:remove_entities(selected_entity_nums)
    
    get_player_store(player):clear_selection()
    get_player_store(player):set_editable_blueprint(blueprint_existing)
    
    return blueprint_existing
end

function Blueprint_Edit_Actions.player_move(player, vector)
    
    local blueprint_existing = get_editable_blueprint(player)
    
    if(has_no_selection(player))then
        player:sendmessage("Moving full blueprint.")
        blueprint_existing = blueprint_existing:move_all_entities_and_tiles_by_vector(vector)
    else
        player:sendmessage("Moving selection.")
        local selected_entity_nums = get_selection(player)
        blueprint_existing = blueprint_existing:move_entities_by_vector(selected_entity_nums, vector)
    end
    
    get_player_store(player):set_editable_blueprint(blueprint_existing)
    
    return blueprint_existing
end

function Blueprint_Edit_Actions.player_rotate(player, amount)
    player:sendmessage("Rotating selection.")
    
    local blueprint_existing = get_editable_blueprint(player)
    local selected_entity_nums = get_selection(player)
    
    local edited_blueprint = blueprint_existing:rotate_entities_by_amount(selected_entity_nums, amount)
    
    get_player_store(player):set_editable_blueprint(edited_blueprint)
    
    return edited_blueprint
end

function Blueprint_Edit_Actions.player_mirror(player, direction_mirror_line)
    player:sendmessage("Mirroring selection.")
    
    local blueprint_existing = get_editable_blueprint(player)
    local selected_entity_nums = get_selection(player)
    
    local edited_blueprint = blueprint_existing:mirror_entities_through_direction(selected_entity_nums, direction_mirror_line)
    
    get_player_store(player):set_editable_blueprint(edited_blueprint)
    
    return edited_blueprint
end

local function add_single_entity_to_editing(player, entity)
    local blueprint_existing = get_editable_blueprint(player)
    get_player_store(player):clear_selection()
    
    local touple = blueprint_existing:add_entity(entity)
    blueprint_existing = touple[1]
    local new_entity_numbers = touple[2] -- needs better encapsulation
    
    get_player_store(player):set_editable_blueprint(blueprint_existing)
    get_player_store(player):set_selection_entity_numbers(new_entity_numbers)
    return blueprint_existing
end

function Blueprint_Edit_Actions.add_blueprint_to_editing(player, blueprint_adding)
    player:sendmessage("Adding bp.")
    
    local entities = blueprint_adding.blueprint_entities
    
    local single_entity = entities[1]
    
    return add_single_entity_to_editing(player, single_entity)
end

local function add_entity_by_name_to_editing(player, object_with_name_field)
    player:sendmessage("Adding entity.")
    
    local entity = Blueprint_Entity.from_name(object_with_name_field.name)
    
    return add_single_entity_to_editing(player, entity)
end

function Blueprint_Edit_Actions.add_entity_from_item_stack_to_editing(player, item_stack)
    return add_entity_by_name_to_editing(player, item_stack)
end

function Blueprint_Edit_Actions.add_entity_from_lua_entity_to_editing(player, lua_entity)
    return add_entity_by_name_to_editing(player, lua_entity)
end

function Blueprint_Edit_Actions.copy(player)
    player:sendmessage("Copying editing.")
    
    local blueprint_existing = get_editable_blueprint(player)
    local selected_entity_nums = get_selection(player)
    
    local selection_one = next(selected_entity_nums) -- part of cludge below
    local selected_el = blueprint_existing.blueprint_entities[selection_one]
    
    local touple = blueprint_existing:add_entity(selected_el)
    
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
    local selected_el = blueprint_existing.blueprint_entities[next(selected_entity_nums)] -- massive cludge
    local centre = selected_el:get_on_grid_position()
    
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

function Blueprint_Edit_Actions.player_finish_editing(player)
    player:sendmessage("Finished editing.")
    
    local blueprint_existing = get_editable_blueprint(player)

    get_player_store(player):clear_editing()
    
    return blueprint_existing
end

return Blueprint_Edit_Actions