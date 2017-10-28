local lu = require('luaunit')
local Object_Type_Mocker = require('lib.lua_enhance.util.Object_Type_Mocker')


TestObjectTypeMocker = {}
    function TestObjectTypeMocker:testMocksNilTypeCorrectly()
        -- given
        local type_request = "nil"
        
        -- when 
        local result = Object_Type_Mocker.get_object_of_type(type_request)
        
        -- then
        lu.assertEquals(type(result), type_request)
    end
    function TestObjectTypeMocker:testMocksStringTypeCorrectly()
        -- given
        local type_request = "string"
        
        -- when 
        local result = Object_Type_Mocker.get_object_of_type(type_request)
        
        -- then
        lu.assertEquals(type(result), type_request)
    end
    function TestObjectTypeMocker:testMocksNumberTypeCorrectly()
        -- given
        local type_request = "number"
        
        -- when 
        local result = Object_Type_Mocker.get_object_of_type(type_request)
        
        -- then
        lu.assertEquals(type(result), type_request)
    end
    function TestObjectTypeMocker:testMocksTableTypeCorrectly()
        -- given
        local type_request = "table"
        
        -- when 
        local result = Object_Type_Mocker.get_object_of_type(type_request)
        
        -- then
        lu.assertEquals(type(result), type_request)
    end
    function TestObjectTypeMocker:testMocksUserdataTypeCorrectly()
        -- given
        local type_request = "userdata"
        
        -- when 
        local result = Object_Type_Mocker.get_object_of_type(type_request)
        
        -- then
        lu.assertEquals(type(result), type_request)
    end
    function TestObjectTypeMocker:testMocksFunctionTypeCorrectly()
        -- given
        local type_request = "function"
        
        -- when 
        local result = Object_Type_Mocker.get_object_of_type(type_request)
        
        -- then
        lu.assertEquals(type(result), type_request)
    end
    function TestObjectTypeMocker:testMocksBooleanTypeCorrectly()
        -- given
        local type_request = "boolean"
        
        -- when 
        local result = Object_Type_Mocker.get_object_of_type(type_request)
        
        -- then
        lu.assertEquals(type(result), type_request)
    end
    function TestObjectTypeMocker:testMocksThreadTypeCorrectly()
        -- given
        local type_request = "thread"
        
        -- when 
        local result = Object_Type_Mocker.get_object_of_type(type_request)
        
        -- then
        lu.assertEquals(type(result), type_request)
    end
    
return lu.LuaUnit.run()