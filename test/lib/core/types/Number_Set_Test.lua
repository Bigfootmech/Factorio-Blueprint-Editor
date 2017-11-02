local lu = require('luaunit')
local Set = require('lib.core.types.Set')

TestBasicFunctions = {}
    function TestBasicFunctions:testCreates()
        -- given
        
        -- when 
        local result = Set("number").new()
        
        -- then
        lu.assertTrue(result)
        lu.assertEquals(type(result), "table")
    end
    
    function TestBasicFunctions:testCanInsert()
        -- given
        local set = Set("number").new()
        local obj = 1
        
        -- when 
        local result = set:insert(obj)
        
        -- then
        lu.assertTrue(result)
        lu.assertEquals(type(result), "table")
        lu.assertEquals(set, result)
    end
    
    function TestBasicFunctions:testCanInsertAll()
        -- given
        local set = Set("number").new()
        local obj = {1, 2, 3}
        
        -- when 
        local result = set:insert_all(obj)
        
        -- then
        lu.assertTrue(result)
        lu.assertEquals(type(result), "table")
        lu.assertEquals(set, result)
    end
    
    function TestBasicFunctions:testContainsPositive()
        -- given
        local set = Set("number").new()
        local obj = 2
        set:insert_all({1, obj, 3})
        
        -- when 
        local result = set:contains(obj)
        
        -- then
        lu.assertTrue(result)
    end
    
    function TestBasicFunctions:testContainsNegative()
        -- given
        local set = Set("number").new()
        set:insert_all({1, 2, 3})
        local obj = 4
        
        -- when 
        local result = set:contains(obj)
        
        -- then
        lu.assertFalse(result)
    end
    
    function TestBasicFunctions:testRemove()
        -- given
        local set = Set("number").new()
        local obj = 2
        set:insert_all({1, obj, obj, 3})
        
        -- when 
        local result = set:remove(obj)
        
        -- then
        lu.assertFalse(set:contains(obj))
    end

TestOnlyAllowsNumbers = {}
    function TestOnlyAllowsNumbers:testCanNotInsertNonNumber()
        -- given
        local set = Set("number").new()
        local obj = "b"
        
        -- when -- then
        lu.assertError(set.insert, set, obj)
    end
    
    function TestOnlyAllowsNumbers:testCanNotInsertNumberString()
        -- given
        local set = Set("number").new()
        local obj = "1"
        
        -- when -- then
        lu.assertError(set.insert, set, obj)
    end
    
    function TestOnlyAllowsNumbers:testInsertAll()
        -- given
        local set = Set("number").new()
        local obj = {1, "n", 3}
        
        -- when -- then
        lu.assertError(set.insert_all, set, obj)
    end
    
    function TestOnlyAllowsNumbers:testContains()
        -- given
        local set = Set("number").new()
        set:insert_all({1, 2, 3})
        local obj = "q"
        
        -- when -- then
        lu.assertError(set.contains, set, obj)
    end
    
    function TestOnlyAllowsNumbers:testRemove()
        -- given
        local set = Set("number").new()
        set:insert_all({1, 2, 2, 3})
        local obj = "L"
        
        -- when -- then
        lu.assertError(set.remove, set, obj)
    end
    
return lu.LuaUnit.run()