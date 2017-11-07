require("faketorio_busted")
defines = require("fakewrapper.Defines")
local Player_Helper = require("fakewrapper.Player_Helper")
local Script_Helper = require("fakewrapper.Script_Helper")
local Data_Helper = require("fakewrapper.Data_Helper")
local Data = require("fakewrapper.Data")

local Fakewrapper = {}

function Fakewrapper.initialize()
    faketorio.initialize_world_busted()
    for id in pairs(game.players)do
        Player_Helper.populate_player(id)
    end
    Script_Helper.wrap(script)
    data = Data.new()
    require("data") -- from mod
    -- hide data from mod?
end

return Fakewrapper