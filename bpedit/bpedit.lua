--control.lua
local Transformations = require 'bpedit.keybinds.Transformations'
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

local function is_editing(player)
    if(get_editable_blueprint(player)) then return true end
    return false
end

local function has_selection(player)
    if(get_selected_nums(player)) then return true end
    return false
end

----------------------- end of global, start of player -------------------

local function sendmessage(player, message)
    player.print(message)
end

local function open_menu(player, object)
    player.opened = object
end

local function get_blueprint_from_hand(player)
    local stack = player.cursor_stack
    if not stack or not stack.valid_for_read or stack.type ~= "blueprint" then
      return false
    end
    return stack -- TODO: where we want to transform stack to BP via copy
end

local function has_blueprint_in_hand(player)
    if(get_blueprint_from_hand(player)) then return true end
    return false
end

----------------------- end of player, start of main functions -------------------

local function open_blueprint_menu(player)
    open_menu(player, get_editable_blueprint(player))
end

local function begin_editing_blueprint(player)
    sendmessage(player, "Opening BP for editing.")
    
    local blueprint = get_blueprint_from_hand(player)
    
    set_editable_blueprint(player, blueprint)
    
    clear_selected_nums(player)
    open_blueprint_menu(player)
end

local function reopen_blueprint_menu(player)
    sendmessage(player, "Reopening BP.")
    open_blueprint_menu(player)
end

local function add_blueprint_to_editing(player)
    sendmessage(player, "Adding bp.")
    
    local blueprint_existing = get_editable_blueprint(player)
    local blueprint_adding = get_blueprint_from_hand(player)
    
    clear_selected_nums(player)
    
    local entities = blueprint_adding.get_blueprint_entities()
    
    blueprint_existing = Blueprint.add_entity(blueprint_existing, entities[1])
    local new_entity_number = #blueprint_existing.get_blueprint_entities()
    
    set_editable_blueprint(player, blueprint_existing)
    add_elnum_to_selected(player, new_entity_number)
    open_blueprint_menu(player)
end

local function player_move_selection(player, vector)
    sendmessage(player, "Moving selection.")
    
    local blueprint_existing = get_editable_blueprint(player)
    local selected_element_nums = get_selected_nums(player)
    
    local edited_blueprint = Blueprint.move_multiple_entitities_by_vector(blueprint_existing, selected_element_nums, vector)
    
    set_editable_blueprint(player, edited_blueprint)
    open_blueprint_menu(player)
end

local function player_stop_editing(player)
    sendmessage(player, "Stopped editing.")

    clear_editable_blueprint(player)
    clear_selected_nums(player)
end

----------------------- end of main functions, start of api -------------------

local function add_inner_blueprint(event)
    local player = Event.new(event):get_player()
    
    if not is_editing(player) then
        sendmessage(player, "Can't add bp, not currently editing.")
        return false
    end
    
    if not has_blueprint_in_hand(player) then
        sendmessage(player, "No blueprint in hand to add.")
        return false
    end
    
    add_blueprint_to_editing(player)
end

local function move_inner_blueprint(event)
    local player = Event.new(event):get_player()
    
    if not is_editing(player) then
        sendmessage(player, "Can't move selection, not currently editing.")
        return false
    end
    
    if not has_selection(player) then
        sendmessage(player, "Can't move selection, don't currently have anything selected.")
        return false
    end
    
    -- TODO: add conflict check with dollies
    
    local vector = Transformations.get_vector_from_direction_command(event.input_name)
    
    player_move_selection(player, vector)
end

local function edit_or_reopen_blueprint(event)
    local player = Event.new(event):get_player()
    
    if has_blueprint_in_hand(player) then
        return begin_editing_blueprint(player)
    end
    
    if is_editing(player) then
        return reopen_blueprint_menu(player)
    end
    
    sendmessage(player, "Error: No blueprints found for editing (hand, or store)!")
end

local function stop_editing(event)
    local player = Event.new(event):get_player()
    
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
