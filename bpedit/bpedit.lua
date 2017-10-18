--control.lua
local Global_Dao = require 'bpedit.dal.Global_Dao'
local Message_Bus = require 'bpedit.keybinds.Message_Bus'

script.on_init(function()
    Global_Dao.init() 
    Message_Bus.init() 
end)
