local Player_Store_Dao = require('bpedit.backend.data.Player_Store_Dao')

local Mod_Name = "BPEdit"

local Global_Dao = {}

local function init()
    global[Mod_Name] = global[Mod_Name] or {}
    global.editable_blueprint = nil
    global.selected_blueprint_element_nums= nil
end
Global_Dao.init = init

local function get_global_store()
    if global[Mod_Name] == nil then init() end
    return global[Mod_Name]
end

local function init_player(store, player_id)
    store[player_id] = Player_Store_Dao.new() -- need some way of initializing per player, if we want to split out "global" to lib
end

local function get_player_store(player_id)
    local global_store = get_global_store()
    if not global_store[player_id] then init_player(global_store, player_id) end
    return global_store[player_id]
end
Global_Dao.get_player_store = get_player_store

return Global_Dao