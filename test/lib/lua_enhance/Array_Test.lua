local lu = require('luaunit')
local Array = require('lib.lua_enhance.Array')

TestGetIndex = {}
    function TestGetIndex:testGetIndexWorks()
        -- given
        local my_array = {1, 2, 3, 4, 7, 9, 12, 5}
        local trying_to_retrieve_number = 9
        local expected_index = 6
        
        -- when 
        local result = Array.get_index(my_array, trying_to_retrieve_number)
        
        -- then
        lu.assertEquals(result,expected_index)
    end

TestContains = {}
    function TestContains:testContains()
        -- given
        local my_array = {1, 2, 3, 4, 7, 9, 12, 5}
        local trying_to_retrieve_number = 12
        
        -- when 
        local result = Array.contains(my_array, trying_to_retrieve_number)
        
        -- then
        lu.assertTrue(result)
    end
    
lu.LuaUnit.run()