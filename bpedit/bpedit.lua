--control.lua
local Transformations = require 'lib.keybinds.Transformations'
local Event = require 'lib.events.Event'

local function init_global()
  global.editable_blueprint = global.editable_blueprint or {}
  global.selected_blueprint_element_nums = global.selected_blueprint_element_nums or {}
end

local function get_editable_blueprint(player)
    if global.editable_blueprint == nil then player.print("global not correctly initialized") end
    return global.editable_blueprint[player.index]
end

local function set_editable_blueprint(player, blueprint)
    global.editable_blueprint[player.index] = blueprint
end

local function clear_editable_blueprint(player)
    set_editable_blueprint(player, nil)
end

local function get_selected_nums(player)
    if global.selected_blueprint_element_nums == nil then player.print("global not correctly initialized") end
    return global.selected_blueprint_element_nums[player.index]
end

local function set_selected_nums(player, element_nums)
    global.selected_blueprint_element_nums[player.index] = element_nums
end

local function clear_selected_nums(player)
    global.selected_blueprint_element_nums[player.index] = {}
end

local function add_elnum_to_selected(player, new_entity_number)
    table.insert(global.selected_blueprint_element_nums[player.index], new_entity_number)
end

local function debugtext(player, message)
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
    if not stack or not stack.valid_for_read or stack.type ~= "blueprint" then
      return false
    end
    return stack
end

local function open_blueprint_menu(player)
    player.opened = get_editable_blueprint(player)
end

local function add_entity_to_blueprint(blueprint, entity_name, x, y)
    entities = blueprint.get_blueprint_entities()
    new_entity_number = entities[#entities].entity_number + 1
    entities[new_entity_number] = create_entity_for_insertion(new_entity_number,entity_name,x,y)
    blueprint.set_blueprint_entities(entities)
    
    return new_entity_number
end

local function add_blueprint_to_blueprint(player, blueprint_existing, blueprint_adding)
    clear_selected_nums(player)
    
    entities = blueprint_adding.get_blueprint_entities()
    
    entity_name = entities[1].name
        
    new_entity_number = add_entity_to_blueprint(blueprint_existing, entity_name, 0, 0)
    
    add_elnum_to_selected(player, new_entity_number)
end

local function move_entity(entities, entity_number, vector)
    selected_entity = entities[entity_number]
    selected_entity.position = add_vector_to_position(selected_entity.position, vector)
    entities[entity_number] = selected_entity
    return entities
end

local function begin_editing_blueprint(player, blueprint)
    set_editable_blueprint(player, blueprint)
    open_blueprint_menu(player)
end

local function add_inner_blueprint(event)
    local player = Event.new(event):get_player()
    
    local editable_blueprint = get_editable_blueprint(player)
    if not editable_blueprint then
        debugtext(player, "Can't add bp, not currently editing.")
        return false
    end
    
    local adding_blueprint = get_blueprint_from_hand(player)
    if not adding_blueprint then
        debugtext(player, "No blueprint in hand to add.")
        return false
    end
    
    debugtext(player, "Adding bp")
    add_blueprint_to_blueprint(player, editable_blueprint, adding_blueprint)
    open_blueprint_menu(player)
end

local function move_inner_blueprint(event)
    local player = Event.new(event):get_player()
    
    local editable_blueprint = get_editable_blueprint(player)
    if not editable_blueprint then
        debugtext(player, "Can't move selection, not currently editing.")
        return false
    end
    
    selected_element_nums = get_selected_nums(player)
    if not selected_element_nums then
        debugtext(player, "Can't move selection, don't currently have anything selected.")
        return false
    end
    
    -- TODO: add conflict check with dollies
    
    debugtext(player, "Moving bp")
    vector = Transformations.get_vector_from_direction_command(event.input_name)
    
    entities = editable_blueprint.get_blueprint_entities()
    
    for _,entity_number in pairs(selected_element_nums) do
        move_entity(entities, entity_number, vector)
    end
    
    get_editable_blueprint(player).set_blueprint_entities(entities)
    open_blueprint_menu(player)
end

local function edit_or_reopen_blueprint(event)
    local player = Event.new(event):get_player()
    
    local blueprint = get_blueprint_from_hand(player) -- Error, contains pointer to hand, rather than actual BP
    
    if blueprint then
        debugtext(player, "loading BP")
        return begin_editing_blueprint(player, blueprint) -- starts editing hand
    end
    
    local editable_blueprint = get_editable_blueprint(player)
    if editable_blueprint ~= nil then
        debugtext(player, "reopening BP")
        return open_blueprint_menu(player)
    end
    
    debugtext(player, "Error: blueprints found for editing (hand, or store)!")
end

local function stop_editing(event)
    local player = Event.new(event):get_player()
    clear_editable_blueprint(player)
    
    debugtext(player, "stopped editing")
end

local function register_keybindings()
    script.on_event("a-primary-action", edit_or_reopen_blueprint)
    script.on_event("b-secondary-action", add_inner_blueprint)
    script.on_event({"c-up", 
                    "c-up-more", 
                    "d-down", 
                    "d-down-more",
                    "e-left", 
                    "e-left-more",
                    "f-right",  
                    "f-right-more"}, move_inner_blueprint)
    script.on_event(defines.events.on_player_configured_blueprint, stop_editing)
end

script.on_init(function()
    init_global() 
    register_keybindings() 
end)
