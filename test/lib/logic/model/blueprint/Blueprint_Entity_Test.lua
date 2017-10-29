local lu = require('luaunit')
local Blueprint_Entity = require('lib.logic.model.blueprint.Blueprint_Entity')

TestBlueprintEntity = {}

    function TestBlueprintEntity:testFromTable()
        -- given
        local blueprint_entity_table = {entity_number = 1, name = "dinosaur", position = {1, 1}}
        
        -- when 
        local result = Blueprint_Entity.from_table(blueprint_entity_table)
        
        -- then
        lu.assertTrue(result)
    end
    
    function TestBlueprintEntity:testCopyWorks()
        -- given
        local blueprint_entity = Blueprint_Entity.from_table({entity_number = 1, name = "dinosaur", position = {1, 1}})
        
        -- when 
        local result = Blueprint_Entity.copy(blueprint_entity)
        
        -- then
        lu.assertTrue(result)
    end
    
return lu.LuaUnit.run()