require("faketorio_busted")
require("fakewrapper.Defines")
local Player_Helper = require("fakewrapper.Player_Helper")
local Data = require("fakewrapper.Data")

local Fakewrapper = {}

function Fakewrapper.initialize()
    faketorio.initialize_world_busted()
    for id in pairs(game.players)do
        Player_Helper.populate_player(id)
    end
    require("fakewrapper.Script")
    data = Data.new()
    require("data") -- from mod
end

return Fakewrapper