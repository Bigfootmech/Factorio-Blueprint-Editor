local Event = require("fakewrapper.Event")
local LuaItemStack_Mock = require("fakewrapper.LuaItemStack_Mock")

local Player_Helper = {}

local stored_player_messages = {}

local function store_msg(player_id, msg)
    -- print(msg) --TODO: log debug?
    table.insert(stored_player_messages[player_id], msg)
end

function Player_Helper.retrieve_msg(player_id)
    return table.remove(stored_player_messages[player_id],1,1)
end

function Player_Helper.populate_player(player_id)
    local player = game.players[player_id]
    stored_player_messages[player_id] = {}
    player.print = function(msg) store_msg(player_id, msg)end
    player.clean_cursor = function() player.cursor_stack = LuaItemStack_Mock.new(); return true end
    player.clean_cursor()
    Player_Helper.clear_selection(player_id)
end

function Player_Helper.clear_selection(player_id)
    game.players[player_id].selected = nil
end

function Player_Helper.set_selection(player_id, mouseover_selection)
    game.players[player_id].selected = mouseover_selection
end

function Player_Helper.presses_key(player_id, key_set)
    Event.keypress(1,key_set)
end

return Player_Helper