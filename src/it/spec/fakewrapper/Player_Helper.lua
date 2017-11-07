Player_Helper = {}

local stored_player_messages = {}

local function store_msg(playerid, msg)
    if(stored_player_messages[playerid] == nil)then
        stored_player_messages[playerid] = {}
    end
    table.insert(stored_player_messages[playerid], msg)
end

local function retrieve_msg(playerid)
    return table.remove(stored_player_messages[playerid],1,1)
end

function Player_Helper.populate_player(player_id))
    local player = game.players[player_id]
    player.print = function(msg) store_msg(playerid, msg)end
end

function Player_Helper.clear_selection(player_id)
    game.players[player_id].selected = nil
end

function Player_Helper.set_selection(player_id, mouseover_selection)
    game.players[player_id].selected = mouseover_selection
end

return Player_Helper