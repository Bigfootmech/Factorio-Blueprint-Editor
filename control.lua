--control.lua

local editable_blueprint -- are these shared accross server, and all players?
local selected_blueprint_nums = {}

local input_to_vector = {
    ["bp-move-up"] = {0.0, -0.5},
    ["bp-move-down"] = {0.0, 0.5},
    ["bp-move-left"] = {-0.5, 0.0},
    ["bp-move-right"] = {0.5, 0.0},
    ["bp-move-up-more"] = {0.0, -2},
    ["bp-move-down-more"] = {0.0, 2},
    ["bp-move-left-more"] = {-2, 0.0},
    ["bp-move-right-more"] = {2, 0.0}
}

local function get_player(event)
    return game.players[event.player_index]
end

local function debugtext(event, message)
    local player = get_player(event)
    player.print(message)
end

local function create_position(x,y)
    return {["x"] = x, ["y"] = y}
end

local function add_vector_to_position(pos,vect)
    new_x = pos["x"] + vect[1] -- can't add - vect err?
    new_y = pos["y"] + vect[2]
    return {["x"] = new_x , ["y"] = new_y}
end

local function create_entity_for_insertion(entity_number, entity_name, x, y)
    position = create_position(x,y)
    return {["entity_number"] = entity_number, ["name"] = entity_name, ["position"] = position}
end

local function get_blueprint_from_hand(player)
    return player.cursor_stack -- needs error checking first
end

local function open_blueprint_menu(player)
    player.opened = editable_blueprint
end

local function reopen_blueprint_menu(event)
    local player = get_player(event)
    open_blueprint_menu(player)
end

local function add_entity_to_blueprint(blueprint, entity_name, x, y)
    entities = blueprint.get_blueprint_entities()
    new_entity_number = entities[#entities].entity_number + 1
    entities[new_entity_number] = create_entity_for_insertion(new_entity_number,entity_name,x,y)
    blueprint.set_blueprint_entities(entities)
    
    return new_entity_number
end

local function add_blueprint_to_blueprint(blueprint_existing, blueprint_adding)
    selected_blueprint_nums = {}
    
    entities = blueprint_adding.get_blueprint_entities()
    
    entity_name = entities[1].name -- needs error checking first
        
    new_entity_number = add_entity_to_blueprint(blueprint_existing, entity_name, 0, 0)
    
    table.insert(selected_blueprint_nums, new_entity_number)
end

local function move_entity(entities, entity_number, vector)
    selected_entity = entities[entity_number]
    selected_entity.position = add_vector_to_position(selected_entity.position, vector)
    entities[entity_number] = selected_entity
    return entities
end

local function load_outer_blueprint(event)
    local player = get_player(event)
    editable_blueprint = get_blueprint_from_hand(player)
    reopen_blueprint_menu(event)
end

local function add_inner_blueprint(event)
    local player = get_player(event)
    local adding_blueprint = get_blueprint_from_hand(player)
    add_blueprint_to_blueprint(editable_blueprint, adding_blueprint) -- subs add bp for ed bp :/
    reopen_blueprint_menu(event)
end

local function move_inner_blueprint(event)
    -- add error checking / valid mouse over
    entities = editable_blueprint.get_blueprint_entities()
    vector = input_to_vector[event.input_name]
    for _,entity_number in pairs(selected_blueprint_nums) do
        move_entity(entities, entity_number, vector)
    end
    editable_blueprint.set_blueprint_entities(entities)
    reopen_blueprint_menu(event)
end

local function register_keybindings()
    script.on_event("load-editable-blueprint", load_outer_blueprint)
    script.on_event("add-blueprint", add_inner_blueprint)
    script.on_event({"bp-move-up", "bp-move-down", "bp-move-left", "bp-move-right","bp-move-up-more", "bp-move-down-more", "bp-move-left-more", "bp-move-right-more"}, move_inner_blueprint)
end

script.on_load(function(event) register_keybindings() end)
