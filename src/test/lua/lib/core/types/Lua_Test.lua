local lu = require('luaunit')

Test_LuaFunctionMapping = {}

    function Test_LuaFunctionMapping:setUp()
        Obj1 = {}
        Obj2 = {}
        
        local function mappy(x,y)
            return {x, y}
        end
        Obj1.method = mappy
    end
    
    function Test_LuaFunctionMapping:testEvenMethods()
        -- given
        
        Obj2.method = Obj1.method
        
        -- when
        local result = Obj2.method("a")
        
        -- then
        lu.assertNotEquals(result[1], nil)
        lu.assertEquals(result[2], nil)
    end
    
    function Test_LuaFunctionMapping:testAddingArgument()
        -- given
        local function xtra(a)
            return Obj1.method(a,"b")
        end
        
        Obj2.method = xtra
        
        -- when
        local result = Obj2.method("a")
        
        -- then
        lu.assertNotEquals(result[1], nil)
        lu.assertNotEquals(result[2], nil)
    end
    
    function Test_LuaFunctionMapping:testMappingFunction()
        -- given
        
        Obj2.method = function(a) return Obj1.method(a, "b") end
        
        -- when
        local result = Obj2.method({"a"})
        
        -- then
        lu.assertNotEquals(result[1], nil)
        lu.assertNotEquals(result[2], nil)
        
        
    end

Test_LuaGlobalsReplacing = {}
    
    function Test_LuaGlobalsReplacing:testCanReplaceMethod()
        -- given
        local typesaved = type
        
        -- when
        type = function() return "more fool you" end
        
        -- then
        lu.assertNotEquals(type("string"), "string")
        type = typesaved
        
        
    end
    
    function Test_LuaGlobalsReplacing:testCanPlaceOldMethodBack()
        -- given
        local typesaved = type
        type = function() return "more fool you" end
        
        -- when
        type = typesaved
        
        -- then
        lu.assertEquals(type("string"), "string")
        
        
    end
    
return lu.LuaUnit.run()