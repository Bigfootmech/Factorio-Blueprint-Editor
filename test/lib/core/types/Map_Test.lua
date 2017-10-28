local lu = require('luaunit')
local Map = require('lib.core.types.Map')

TestInsertAll = {}
    function TestInsertAll:testInsertAllEmpty()
        -- given
        local table_one = {}
        local table_two = {}
        
        -- when 
        local result = Map.insert_all(table_one,table_two)
        
        -- then
        lu.assertEquals(result,{})
    end
    function TestInsertAll:testInsertAllOneWay()
        -- given
        local table_one = {a = 1}
        local table_two = {}
        
        -- when 
        local result = Map.insert_all(table_one,table_two)
        
        -- then
        lu.assertEquals(result,{a = 1})
    end
    function TestInsertAll:testInsertAllOtherWay()
        -- given
        local table_one = {}
        local table_two = {b = 2}
        
        -- when 
        local result = Map.insert_all(table_one,table_two)
        
        -- then
        lu.assertEquals(result,{b = 2})
    end
    function TestInsertAll:testInsertAllCombine()
        -- given
        local table_one = {a = 1}
        local table_two = {b = 2}
        
        -- when 
        local result = Map.insert_all(table_one,table_two)
        
        -- then
        lu.assertEquals(result,{a = 1,b = 2})
    end
    function TestInsertAll:testInsertAllCombineAndOverwrite()
        -- given
        local table_one = {a = 1, b = 3, c = 3}
        local table_two = {b = 2, d = 4, e = 5}
        
        -- when 
        local result = Map.insert_all(table_one,table_two)
        
        -- then
        lu.assertEquals(result,{a = 1,b = 2, c = 3, d = 4, e = 5})
    end

TestDeepcopy = {}
    function TestDeepcopy:testDeepcopyEmpty()
        -- given
        local my_table = {}
        
        -- when 
        local result = Map.deepcopy(my_table)
        
        -- then
        lu.assertEquals(result,{})
    end
    function TestDeepcopy:testDeepcopyCopiesBasic()
        -- given
        local my_table = {a = "b"}
        
        -- when 
        local result = Map.deepcopy(my_table)
        
        -- then
        lu.assertEquals(result,my_table)
    end
    function TestDeepcopy:testDeepcopyWorks()
        -- given
        local my_table = {a = "b", ["c"] = 4, [5]="floygen", my_tab = {deeper = {much_deeper = {a = 9}}}, q = p}
        
        -- when 
        local result = Map.deepcopy(my_table)
        
        -- then
        lu.assertEquals(result,my_table)
    end
    
return lu.LuaUnit.run()