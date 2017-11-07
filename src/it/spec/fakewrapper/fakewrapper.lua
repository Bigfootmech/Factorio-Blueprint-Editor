require("faketorio_busted")
require("fakewrapper.Defines")
local Data = require("fakewrapper.Data")

local Fakewrapper = {}

function Fakewrapper.initialize()
    faketorio.initialize_world_busted()
    require("fakewrapper.Script")
    data = Data.new()
    require("data") -- from mod
end

return Fakewrapper