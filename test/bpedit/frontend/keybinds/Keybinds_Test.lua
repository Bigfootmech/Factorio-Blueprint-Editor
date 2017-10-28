local lu = require('luaunit')
local Keybinds = require('bpedit.frontend.keybinds.Keybinds')
local Map = require('lib.core.types.Map')

TestBasics = {}
    
    function TestBasics:testInterfaceMap()
        -- given
        
        -- when 
        local result = Keybinds.get_interface_mapping()
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(type(result), "table")
        lu.assertTrue(Map.size(result) > 0)
    end
    function TestBasics:testKeySequences()
        -- given
        
        -- when 
        local result = Keybinds.get_registered_key_sequences()
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(type(result), "table")
        lu.assertTrue(Map.size(result) > 0)
    end
    function TestBasics:testLocaleText()
        -- given
        
        -- when 
        local result = Keybinds.get_locale_text()
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(type(result), "table")
        lu.assertTrue(Map.size(result) > 0)
    end

return lu.LuaUnit.run()