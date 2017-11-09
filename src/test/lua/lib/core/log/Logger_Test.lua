local lu = require('luaunit')
local Logger = require('lib.core.log.Logger')

TestLogger = {}
    function TestLogger:testCanConstructBasicLogger()
        -- given
        
        -- when
        local result = Logger.new()
        
        -- then
        lu.assertTrue(result)
    end

return lu.LuaUnit.run()