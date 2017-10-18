--control.lua
local Transformations = require 'bpedit.keybinds.Transformations'
local Player = require 'lib.player.Player'
local Blueprint_Entity = require 'lib.blueprint.Blueprint_Entity'
local Blueprint = require 'lib.blueprint.Blueprint'

local function init_global()
  global.editable_blueprint = global.editable_blueprint or {}
  global.selected_blueprint_element_nums = global.selected_blueprint_element_nums or {}
end

local function get_editable_blueprint(player)
    if global.editable_blueprint == nil then player:sendmessage("global not correctly initialized") end
    return global.editable_blueprint[player.index]
end

local function set_editable_blueprint(player, blueprint)
    global.editable_blueprint[player.index] = blueprint
end

local function clear_editable_blueprint(player)
    set_editable_blueprint(player, nil)
end

local function get_selected_nums(player)
    if global.selected_blueprint_element_nums == nil then player:sendmessage("global not correctly initialized") end
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

local function is_editing(player)
    if(get_editable_blueprint(player)) then return true end
    return false
end

local function has_selection(player)
    if(get_selected_nums(player)) then return true end
    return false
end

----------------------- end of global, start of main functions -------------------

local function open_blueprint_menu(player)
    player:open_menu(get_editable_blueprint(player))
end

local function begin_editing_blueprint(player)
    player:sendmessage("Opening BP for editing.")
    
    local blueprint = player:get_blueprint_from_hand()
    
    set_editable_blueprint(player, blueprint)
    
    clear_selected_nums(player)
    open_blueprint_menu(player)
end

local function reopen_blueprint_menu(player)
    player:sendmessage("Reopening BP.")
    open_blueprint_menu(player)
end

local function add_blueprint_to_editing(player)
    player:sendmessage("Adding bp.")
    
    local blueprint_existing = get_editable_blueprint(player)
    local blueprint_adding = player:get_blueprint_from_hand()
    
    clear_selected_nums(player)
    
    local entities = blueprint_adding.get_blueprint_entities()
    
    blueprint_existing = Blueprint.add_entity(blueprint_existing, entities[1])
    local new_entity_number = #blueprint_existing.get_blueprint_entities()
    
    set_editable_blueprint(player, blueprint_existing)
    add_elnum_to_selected(player, new_entity_number)
    open_blueprint_menu(player)
end

local function player_move_selection(player, vector)
    player:sendmessage("Moving selection.")
    
    local blueprint_existing = get_editable_blueprint(player)
    local selected_element_nums = get_selected_nums(player)
    
    local edited_blueprint = Blueprint.move_multiple_entitities_by_vector(blueprint_existing, selected_element_nums, vector)
    
    set_editable_blueprint(player, edited_blueprint)
    open_blueprint_menu(player)
end

local function player_stop_editing(player)
    player:sendmessage("Stopped editing.")

    clear_editable_blueprint(player)
    clear_selected_nums(player)
end

----------------------- end of main functions, start of api -------------------

local function add_inner_blueprint(event)
    local player = Player.from_event(event)
    
    if not is_editing(player) then
        player:sendmessage("Can't add bp, not currently editing.")
        return false
    end
    
    if not player:has_blueprint_in_hand() then
        player:sendmessage("No blueprint in hand to add.")
        return false
    end
    
    add_blueprint_to_editing(player)
end

local function move_inner_blueprint(event)
    local player = Player.from_event(event)
    
    if not is_editing(player) then
        player:sendmessage("Can't move selection, not currently editing.")
        return false
    end
    
    if not has_selection(player) then
        player:sendmessage("Can't move selection, don't currently have anything selected.")
        return false
    end
    
    -- TODO: add conflict check with dollies
    
    local vector = Transformations.get_vector_from_direction_command(event.input_name) -- TODO: wanna move the event interpreting in to transformations I think
    
    player_move_selection(player, vector)
end

local function edit_or_reopen_blueprint(event)
    local player = Player.from_event(event)
    
    if player:has_blueprint_in_hand() then
        return begin_editing_blueprint(player)
    end
    
    if is_editing(player) then
        return reopen_blueprint_menu(player)
    end
    
    player:sendmessage("Error: No blueprints found for editing (hand, or store)!")
end

local function stop_editing(event)
    local player = Player.from_event(event)
    
    player_stop_editing(player)
end

----------------------- end of api, start of keybinds -------------------

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

----------------------- end of keybinds, start of init -------------------

script.on_init(function()
    init_global() 
    register_keybindings() 
end)
