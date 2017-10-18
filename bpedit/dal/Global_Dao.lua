local Player_Store_Dao = require 'bpedit.dal.Player_Store_Dao'

local Global_Dao = {}

local function init()
    global.BPEdit = global.BPEdit or {}
    global.editable_blueprint = nil
    global.selected_blueprint_element_nums= nil
end
Global_Dao.init = init

local function get_global_store()
    if global.BPEdit == nil then init() end
    return global.BPEdit
end

local function init_player(store, player_id)
    store[player_id] = Player_Store_Dao.new()
end

local function get_player_store(player_id)
    local global_store = get_global_store()
    if not global_store[player_id] then init_player(global_store, player_id) end
    return global_store[player_id]
end
Global_Dao.get_player_store = get_player_store

return Global_Dao