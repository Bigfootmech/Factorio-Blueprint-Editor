local lu = require('luaunit')
local Direction_Keys = require('lib.frontend.events.Direction_Keys')
local Util = require ('lib.frontend.events.Util')

Test_DirectionKeys_GetVector = {}
    function Test_DirectionKeys_GetVector:testActionDefinitionTableReturned()
        -- given
        local results_table = {}
        
        -- when 
        for _, direction_name in pairs(Direction_Keys.names) do
            table.insert(results_table, Direction_Keys.get_vector(direction_name))
        end
        
        -- then
        for i, _ in ipairs(Direction_Keys.names) do
            lu.assertNotEquals(results_table[i], nil)
        end
    end

Test_DirectionKeys_GetActionDefinition = {}
    
    function Test_DirectionKeys_GetActionDefinition:testActionDefinitionTableReturned()
        -- given
        local direction_name = Direction_Keys.names[1]
        
        -- when 
        local result = Direction_Keys.get_action_definition(direction_name)
        
        -- then
        lu.assertEquals(type(result), 'table')
    end
    
    function Test_DirectionKeys_GetActionDefinition:testActionDefinitionTableContainsValues()
        -- given
        local direction_name = Direction_Keys.names[1]
        
        -- when 
        local result = Direction_Keys.get_action_definition(direction_name)
        
        -- then
        lu.assertNotEquals(result[Util.action_name_field_name], nil)
        lu.assertNotEquals(result[Util.locale_text_field_name], nil)
        lu.assertNotEquals(result[Util.key_sequence_field_name], nil)
        
        lu.assertEquals(type(result[Util.action_name_field_name]), 'string')
        lu.assertEquals(type(result[Util.locale_text_field_name]), 'string')
        lu.assertEquals(type(result[Util.key_sequence_field_name]), 'string')
    end
    
    function Test_DirectionKeys_GetActionDefinition:testActionDefinitionTableReturned()
        -- given
        local direction_name = Direction_Keys.names[1]
        
        -- when 
        local result = Direction_Keys.get_action_definition(direction_name)
        
        -- then
        lu.assertEquals(type(result), 'table')
        lu.assertNotEquals(result[Util.var_field_name], nil)
        lu.assertEquals(type(result[Util.var_field_name]), 'table')
        lu.assertEquals(result[Util.var_field_name], Direction_Keys.get_vector(direction_name))
    end
    
    function Test_DirectionKeys_GetActionDefinition:testCanManipulateVectorVar()
        -- given
        local direction_name = Direction_Keys.names[1]
        local action_definition = Direction_Keys.get_action_definition(direction_name)
        
        -- when
        action_definition[Util.var_field_name] = action_definition[Util.var_field_name]:multiply(2)
        
        -- then
        lu.assertNotEquals(action_definition[Util.var_field_name], nil)
        lu.assertNotEquals(action_definition[Util.var_field_name], Direction_Keys.get_vector(direction_name))
    end
    
return lu.LuaUnit.run()