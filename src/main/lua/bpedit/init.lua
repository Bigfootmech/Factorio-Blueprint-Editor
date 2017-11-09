local Global_Dao = require('bpedit.backend.storage.Global_Dao')
local Message_Bus = require('bpedit.frontend.Message_Bus')

script.on_init(function()
    Global_Dao.init()
end)

Message_Bus.init()
