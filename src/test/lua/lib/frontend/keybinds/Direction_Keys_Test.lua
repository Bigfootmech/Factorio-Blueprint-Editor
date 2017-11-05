local lu = require('luaunit')
local Direction_Keys = require('lib.frontend.keybinds.Direction_Keys')
local Util = require ('lib.frontend.keybinds.Util')

Test_DirectionKeys_GetVector = {}
    function Test_DirectionKeys_GetVector:testCreateFromDirectionName()
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
    function Test_DirectionKeys_GetVector:testCreateFromDirectionNameCaseless()
        -- given
        local up = Direction_Keys.get_vector(Direction_Keys.names[1]) -- hacky :/
        local down = Direction_Keys.get_vector(Direction_Keys.names[2])
        local left = Direction_Keys.get_vector(Direction_Keys.names[3])
        local right = Direction_Keys.get_vector(Direction_Keys.names[4])
        
        -- when
        local up_result = Direction_Keys.get_vector("uP")
        local down_result = Direction_Keys.get_vector("dOwN")
        local left_result = Direction_Keys.get_vector("left")
        local right_result = Direction_Keys.get_vector("RIGHT")
        
        -- then
        lu.assertEquals(up_result, up)
        lu.assertEquals(down_result, down)
        lu.assertEquals(left_result, left)
        lu.assertEquals(right_result, right)
    end
    function Test_DirectionKeys_GetVector:testThrowsErrorOnNilName()
        -- given
        local not_a_direction_name = nil
        
        -- when -- then
        lu.assertError(Direction_Keys.get_vector, not_a_direction_name)
    end
    function Test_DirectionKeys_GetVector:testThrowsErrorOnNonDirectionName()
        -- given
        local not_a_direction_name = "zero"
        
        -- when -- then
        lu.assertError(Direction_Keys.get_vector, not_a_direction_name)
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