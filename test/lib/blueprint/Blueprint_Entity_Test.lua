local lu = require('luaunit')
local Blueprint_Entity = require('lib.logic.model.blueprint.Blueprint_Entity')

TestCopy = {}
    
    function TestCopy:testCopyWorks()
        -- given
        local blueprint_entity = {entity_number = 1, name = "dinosaur", position = {1, 1}}
        
        -- when 
        local result = Blueprint_Entity.copy(blueprint_entity)
        
        -- then
        lu.assertTrue(result)
    end
    
return lu.LuaUnit.run()