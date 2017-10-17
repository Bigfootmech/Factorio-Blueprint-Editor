--control.lua
local Transformations = require 'lib.keybinds.Transformations'
local Event = require 'lib.events.Event'
local Blueprint_Entity = require 'lib.blueprint.Blueprint_Entity'
local Blueprint = require 'lib.blueprint.Blueprint'

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

local function get_blueprint_from_hand(player)
    local stack = player.cursor_stack
    if not stack or not stack.valid_for_read or stack.type ~= "blueprint" then
      return false
    end
    return stack -- TODO: where we want to transform stack to BP via copy
end

local function open_blueprint_menu(player)
    player.opened = get_editable_blueprint(player)
end

local function add_blueprint_to_blueprint(player, blueprint_existing, blueprint_adding)
    clear_selected_nums(player)
    
    local entities = blueprint_adding.get_blueprint_entities()
    
    blueprint_existing = Blueprint.add_entity(blueprint_existing, entities[1])
    local new_entity_number = #blueprint_existing.get_blueprint_entities()
    
    set_editable_blueprint(player, blueprint_existing)
    add_elnum_to_selected(player, new_entity_number)
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
    
    local selected_element_nums = get_selected_nums(player)
    if not selected_element_nums then
        debugtext(player, "Can't move selection, don't currently have anything selected.")
        return false
    end
    
    -- TODO: add conflict check with dollies
    
    debugtext(player, "Moving bp")
    local vector = Transformations.get_vector_from_direction_command(event.input_name)
    
    local edited_blueprint = Blueprint.move_multiple_entitities_by_vector(editable_blueprint, selected_element_nums, vector)
    
    set_editable_blueprint(player, edited_blueprint)
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
    
    debugtext(player, "Error: No blueprints found for editing (hand, or store)!")
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
