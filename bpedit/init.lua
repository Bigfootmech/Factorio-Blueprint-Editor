local Global_Dao = require('bpedit.backend.data.Global_Dao')
local Message_Bus = require('bpedit.frontend.Message_Bus')

script.on_init(function()
    Global_Dao.init() 
    Message_Bus.init() 
end)
