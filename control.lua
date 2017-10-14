--control.lua

local function init_global()
  global.editable_blueprint = global.editable_blueprint or {}
  global.selected_blueprint_nums = global.selected_blueprint_nums or {}
end

local function get_editable_blueprint(player)
    if global.editable_blueprint == nil then player.print("global not correctly initialized") end
    return global.editable_blueprint[player.index]
end

local function set_editable_blueprint(player, blueprint)
    global.editable_blueprint[player.index] = blueprint -- keeps pointer to "hand" :/
end

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
    new_x = pos["x"] + vect[1]
    new_y = pos["y"] + vect[2]
    return {["x"] = new_x , ["y"] = new_y}
end

local function create_entity_for_insertion(entity_number, entity_name, x, y)
    position = create_position(x,y)
    return {["entity_number"] = entity_number, ["name"] = entity_name, ["position"] = position}
end

local function get_blueprint_from_hand(player)
    local stack = player.cursor_stack
    if not stack or not stack.valid_for_read or stack.type ~= "blueprint" then -- TODO: double check valid for read
      return false
    end
    return stack
end

local function open_blueprint_menu(player)
    player.opened = get_editable_blueprint(player)
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

local function begin_editing_blueprint(event)
    debugtext(event, "loading BP")
    local player = get_player(event)
    set_editable_blueprint(player, get_blueprint_from_hand(player))
    reopen_blueprint_menu(event)
end

local function add_inner_blueprint(event)
    debugtext(event, "adding bp")
    local player = get_player(event)
    local adding_blueprint = get_blueprint_from_hand(player)
    add_blueprint_to_blueprint(get_editable_blueprint(player), adding_blueprint) -- subs add bp for ed bp :/
    reopen_blueprint_menu(event)
end

local function move_inner_blueprint(event)
    debugtext(event, "moving bp")
    -- add error checking / valid mouse over
    local player = get_player(event)
    entities = get_editable_blueprint(player).get_blueprint_entities()
    vector = input_to_vector[event.input_name]
    for _,entity_number in pairs(selected_blueprint_nums) do
        move_entity(entities, entity_number, vector)
    end
    get_editable_blueprint(player).set_blueprint_entities(entities)
    reopen_blueprint_menu(event)
end

local function edit_blueprint(event)
    local player = get_player(event)
    local editable_blueprint = get_editable_blueprint(player)
    if editable_blueprint == nil then
        debugtext(event, "loading BP")
        begin_editing_blueprint(event)
    else
        debugtext(event, "reopening BP")
        reopen_blueprint_menu(event)
    end
end

local function register_keybindings()
    script.on_event("edit-blueprint", edit_blueprint)
    script.on_event("add-blueprint", add_inner_blueprint)
    script.on_event({"bp-move-up", "bp-move-down", "bp-move-left", "bp-move-right","bp-move-up-more", "bp-move-down-more", "bp-move-left-more", "bp-move-right-more"}, move_inner_blueprint)
end

script.on_init(function()
    init_global() 
    register_keybindings() 
end)
