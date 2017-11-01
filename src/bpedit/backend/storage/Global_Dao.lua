local Player_Store_Dao = require('bpedit.backend.storage.Player_Store_Dao')
local Player = require('lib.frontend.player.Player')

local Mod_Name = "BPEdit"

local Global_Dao = {}

local function init()
    global[Mod_Name] = global[Mod_Name] or {}
end
Global_Dao.init = init

local function get_global_store()
    if global[Mod_Name] == nil then init() end
    return global[Mod_Name]
end

local function init_player(global_store, player_id)
    Player.from_index(player_id):sendmessage("Making new dao")
    global_store[player_id] = Player_Store_Dao.new() -- need some way of initializing per player, if we want to split out "global" to lib
end

function Global_Dao.revive()
    local global_store = get_global_store()
    for player_id, player_store_dao in pairs(global_store)do
        game.players[player_id].print("restoring your player dao")
        global_store[player_id] = Player_Store_Dao.revive(player_store_dao)
    end
end

local Object = require('lib.core.types.Object')
function Global_Dao.get_player_store(player_id)
    local global_store = get_global_store()
    game.players[player_id].print("getting player dao")
    if(not global_store[player_id])then 
        init_player(global_store, player_id) 
    end
    
    game.players[player_id].print(Object.to_string(global_store[player_id]))
    
    return global_store[player_id]
end

return Global_Dao