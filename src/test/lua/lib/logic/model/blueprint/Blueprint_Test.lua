local lu = require('luaunit')
local Blueprint = require('lib.logic.model.blueprint.Blueprint')



TestBlueprint = {}

    function TestBlueprint:testEmpty()
        -- given
        
        -- when 
        local result = Blueprint.empty()
        
        -- then
        lu.assertTrue(result)
    end
    
return lu.LuaUnit.run()