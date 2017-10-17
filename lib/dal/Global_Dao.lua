local Player_Store_Dao = require 'lib.dal.Player_Store_Dao'

local Global_Dao = {}

local function init()
    global.BPEdit = global.BPEdit or {}
    global.editable_blueprint = nil
    global.selected_blueprint_element_nums= nil
end

GlobalDao.init = init

local function init_player(store, player)
    store[player.index] = Player_Store_Dao.new()
end

local function get_store()
    if global.BPEdit == nil then init() end
    return global.BPEdit
end

local function get_player_store(player)
    local store = get_store()
    if store[player.index] then init_player(store, player) end
    return store[player.index]
end

Global_Dao.get_player_store = get_player_store

return Global_Dao