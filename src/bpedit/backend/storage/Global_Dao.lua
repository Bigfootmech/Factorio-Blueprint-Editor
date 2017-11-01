local Player_Store_Dao = require('bpedit.backend.storage.Player_Store_Dao')
local Object = require('lib.core.types.Object')
local Player = require('lib.frontend.player.Player')

local Mod_Name = "BPEdit"

local Global_Dao = Object.new_class()
Global_Dao.type = "Global_Dao"

local function init()
    global[Mod_Name] = global[Mod_Name] or {}
end
Global_Dao.init = init

local function get_global_store()
    if global[Mod_Name] == nil then init() end
    return global[Mod_Name]
end

local function init_player(global_store, player_id)
    global_store[player_id] = Player_Store_Dao.new() -- need some way of initializing per player, if we want to split out "global" to lib
end

function Global_Dao.get_player_store(player_id)
    local global_store = get_global_store()
    if(not global_store[player_id])then 
        init_player(global_store, player_id) 
    end
    
    if(not Object.is_instatiated(global_store[player_id]))then
        global_store[player_id] = Player_Store_Dao.revive(global_store[player_id])
    end
    
    return global_store[player_id]
end

return Global_Dao