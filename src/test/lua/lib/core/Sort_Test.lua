local lu = require('luaunit')
local Sort = require('lib.core.Sort')

TestSort = {}
    function TestSort:testDescending()
        -- given
        local smallest = 1
        local middle = 2
        local largest = 3
        local test_table = {smallest, largest, middle}
        
        -- when
        table.sort(test_table, Sort.descending)
        
        --then 
        lu.assertEquals(test_table[1], largest)
        lu.assertEquals(test_table[2], middle)
        lu.assertEquals(test_table[3], smallest)
    end
    
    
return lu.LuaUnit.run()