local lu = require('luaunit')
local Object = require('lib.core.types.Object')
local Object_Type_Mocker = require('test.lib.lua_enhance.util.Object_Type_Mocker')

TestLuaObject = {}
    function TestLuaObject:testNilIsNotLuaObject()
        -- given
        local obj = Object_Type_Mocker.get_object_of_type("nil")
        
        -- when 
        local result = Object.is_lua_object(obj)
        
        -- then
        lu.assertFalse(result)
    end
    function TestLuaObject:testStringIsNotLuaObject()
        -- given
        local obj = Object_Type_Mocker.get_object_of_type("string")
        
        -- when 
        local result = Object.is_lua_object(obj)
        
        -- then
        lu.assertFalse(result)
    end
    function TestLuaObject:testNumberIsNotLuaObject()
        -- given
        local obj = Object_Type_Mocker.get_object_of_type("number")
        
        -- when 
        local result = Object.is_lua_object(obj)
        
        -- then
        lu.assertFalse(result)
    end
    function TestLuaObject:testTableIsNotLuaObject()
        -- given
        local obj = Object_Type_Mocker.get_object_of_type("table")
        
        -- when 
        local result = Object.is_lua_object(obj)
        
        -- then
        lu.assertFalse(result)
    end
    function TestLuaObject:testUserdataIsNotLuaObject()
        -- given
        local obj = Object_Type_Mocker.get_object_of_type("userdata")
        
        -- when 
        local result = Object.is_lua_object(obj)
        
        -- then
        lu.assertFalse(result)
    end
    function TestLuaObject:testSelfUserdataIsLuaObject()
        -- given
        local userdata = Object_Type_Mocker.get_object_of_type("userdata")
        local obj = {__self = userdata}
        
        -- when 
        local result = Object.is_lua_object(obj)
        
        -- then
        lu.assertTrue(result)
    end
    
return lu.LuaUnit.run()