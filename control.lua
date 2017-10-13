--control.lua

local editable_blueprint -- are these shared accross server, and all players?
local selected_blueprint_nums = {}

Event.register({"load-editable-blueprint"}, load_outer_blueprint)
Event.register({"add-blueprint"}, add_inner_blueprint)
Event.register({"bp-move-up", "bp-move-down", "bp-move-left", "bp-move-right"}, move_inner_blueprint)

local function reopen_blueprint_menu(event)
    local player = get_player(event)
    open_blueprint_menu(player)
end

local function open_blueprint_menu(player)
    player.opened = editable_blueprint
end

local function load_outer_blueprint(event)
    local player = get_player(event)
    editable_blueprint = get_blueprint_from_hand(player)
    reopen_blueprint_menu(event)
end

local function add_inner_blueprint(event)
    local player = get_player(event)
    local adding_blueprint = get_blueprint_from_hand(player)
    add_blueprint_to_blueprint(editable_blueprint, adding_blueprint)
    reopen_blueprint_menu(event)
end

local function get_blueprint_from_hand(player)
    return player.cursor_stack -- needs error checking first
end

local function get_player(event)
    return game.players[event.player_index]
end

function create_position(x,y)
    return {["x"] = x, ["y"] = y}
end

function create_entity_for_insertion(entity_number, entity_name, x, y)
    position = create_position(x,y)
    return {["entity_number"] = entity_number, ["name"] = entity_name, ["position"] = position}
end

function add_entity_to_blueprint(blueprint, entity_name, x, y)
    entities = blueprint.get_blueprint_entities()
    new_entity_number = entities[#entities].entity_number + 1
    entities[new_entity_number] = create_entity_for_insertion(new_entity_number,entity_name,x,y)
    blueprint.set_blueprint_entities(entities)
    
    return new_entity_number
end

function add_blueprint_to_blueprint(blueprint_existing, blueprint_adding)
    selected_blueprint_nums = {}
    
    entities = blueprint_adding.get_blueprint_entities()
    
    entity_name = entities[1].name -- needs error checking first
        
    new_entity_number = add_entity_to_blueprint(blueprint_existing, entity_name, 0, 0)
    
    table.insert(selected_blueprint_nums, new_entity_number)
end

local input_to_vector = {
    ["bp-move-up"] = {0.0, 0.5},
    ["bp-move-down"] = {0.0, -0.5},
    ["bp-move-left"] = {-0.5, 0.0},
    ["bp-move-right"] = {0.5, 0.0},
}

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

