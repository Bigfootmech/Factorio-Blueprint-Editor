require("faketorio_busted")
require("fakewrapper.Defines")
local Data = require("fakewrapper.Data")

local stored_player_messages = {}

local function store_msg(playerid, msg)
    if(stored_player_messages[playerid] == nil)then
        stored_player_messages[playerid] = {}
    end
    table.insert(stored_player_messages[playerid], msg)
end

local Fakewrapper = {}

function Fakewrapper.initialize()
    faketorio.initialize_world_busted()
    require("fakewrapper.Script")
    data = Data.new()
    require("data") -- from mod
    for playerid, player in ipairs(game.players)do
        player.print = function(msg) store_msg(playerid, msg)end
    end
end

return Fakewrapper