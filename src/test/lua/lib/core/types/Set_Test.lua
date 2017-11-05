local lu = require('luaunit')
local Set = require('lib.core.types.Set')

TestBasicFunctions = {}
    function TestBasicFunctions:testCreates()
        -- given
        
        -- when 
        local result = Set.new()
        
        -- then
        lu.assertTrue(result)
        lu.assertEquals(type(result), "table")
    end
    
    function TestBasicFunctions:testCanInsert()
        -- given
        local set = Set.new()
        local obj = "stringifyied"
        
        -- when 
        local result = set:insert(obj)
        
        -- then
        lu.assertTrue(result)
        lu.assertEquals(type(result), "table")
        lu.assertEquals(set, result)
    end
    
    function TestBasicFunctions:testCanInsertAll()
        -- given
        local set = Set.new()
        local obj = {{}, function()end, 3}
        
        -- when 
        local result = set:insert_all(obj)
        
        -- then
        lu.assertTrue(result)
        lu.assertEquals(type(result), "table")
        lu.assertEquals(set, result)
        lu.assertEquals(set:size(), 3)
    end
    
    function TestBasicFunctions:testContainsPositive()
        -- given
        local set = Set.new()
        local obj = "eep"
        set:insert_all({1, obj, 3})
        
        -- when 
        local result = set:contains(obj)
        
        -- then
        lu.assertTrue(result)
    end
    
    function TestBasicFunctions:testContainsNegative()
        -- given
        local set = Set.new()
        set:insert_all({1, "nay", 3})
        local obj = 4
        
        -- when 
        local result = set:contains(obj)
        
        -- then
        lu.assertFalse(result)
    end
    
    function TestBasicFunctions:testRemove()
        -- given
        local set = Set.new()
        local obj = "wakka"
        set:insert_all({1, obj, obj, 3})
        
        -- when 
        local result = set:remove(obj)
        
        -- then
        lu.assertFalse(set:contains(obj))
    end
    
return lu.LuaUnit.run()