local lu = require('luaunit')
local Grid = require('lib.logic.model.spatial.Grid')
    
TestOnGridLocationsWork = {}
    function TestOnGridLocationsWork:test_OnGridCheck_Origin_ThenTrue()
        -- given
        local num = 0
        
        -- when
        local result = Grid.is_number_on_grid(num)
        
        -- then
        lu.assertTrue(result)
    end
    function TestOnGridLocationsWork:test_OnGridCheck_AnyWholeNumber_ThenTrue()
        -- given
        local num = 29
        
        -- when
        local result = Grid.is_number_on_grid(num)
        
        -- then
        lu.assertTrue(result)
    end
    function TestOnGridLocationsWork:test_OnGridCheck_UnwholeNumber_ThenFalse()
        -- given
        local num = 0.9
        
        -- when
        local result = Grid.is_number_on_grid(num)
        
        -- then
        lu.assertFalse(result)
    end
    function TestOnGridLocationsWork:test_OnGridCheck_PerfectlyOffgrid_ThenFalse()
        -- given
        local num = 0.5
        
        -- when
        local result = Grid.is_number_on_grid(num)
        
        -- then
        lu.assertFalse(result)
    end
    
TestPerfOffGridLocationsWork = {}
    function TestPerfOffGridLocationsWork:test_PerfOffGridCheck_PerfectlyOffgrid_ThenTrue()
        -- given
        local num = 0.5
        
        -- when
        local result = Grid.is_number_perfectly_off_grid(num)
        
        -- then
        lu.assertTrue(result)
    end
    function TestPerfOffGridLocationsWork:test_PerfOffGridCheck_PerfectlyOffgridNegative_ThenTrue()
        -- given
        local num = -0.5
        
        -- when
        local result = Grid.is_number_perfectly_off_grid(num)
        
        -- then
        lu.assertTrue(result)
    end
    function TestPerfOffGridLocationsWork:test_PerfOffGridCheck_AnyPerfectlyOffgrid_ThenTrue()
        -- given
        local num = 137.5
        
        -- when
        local result = Grid.is_number_perfectly_off_grid(num)
        
        -- then
        lu.assertTrue(result)
    end
    function TestPerfOffGridLocationsWork:test_PerfOffGridCheck_Origin_ThenFalse()
        -- given
        local num = 0
        
        -- when
        local result = Grid.is_number_perfectly_off_grid(num)
        
        -- then
        lu.assertFalse(result)
    end
    function TestPerfOffGridLocationsWork:test_PerfOffGridCheck_AnyWholeNumber_ThenFalse()
        -- given
        local num = 29
        
        -- when
        local result = Grid.is_number_perfectly_off_grid(num)
        
        -- then
        lu.assertFalse(result)
    end
    function TestPerfOffGridLocationsWork:test_PerfOffGridCheck_UnwholeNumber_ThenFalse()
        -- given
        local num = 0.9
        
        -- when
        local result = Grid.is_number_perfectly_off_grid(num)
        
        -- then
        lu.assertFalse(result)
    end
    
TestMoveToGridWorks = {}
    function TestMoveToGridWorks:test_MoveToGridFloor_PerfectlyOnGrid_ThenNotMoved()
        -- given
        local num = 3
        
        -- when
        local result = Grid.move_to_grid_floor(num)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(type(result), "number")
        lu.assertTrue(Grid.is_number_on_grid(result))
        lu.assertEquals(result, num)
    end
    function TestMoveToGridWorks:test_MoveToGridCeil_PerfectlyOnGrid_ThenNotMoved()
        -- given
        local num = 4
        
        -- when
        local result = Grid.move_to_grid_ceil(num)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(type(result), "number")
        lu.assertTrue(Grid.is_number_on_grid(result))
        lu.assertEquals(result, num)
    end
    function TestMoveToGridWorks:test_MoveToGridFloor_OffGrid_ThenMoves()
        -- given
        local num = 3.3
        
        -- when
        local result = Grid.move_to_grid_floor(num)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(type(result), "number")
        lu.assertTrue(Grid.is_number_on_grid(result))
        lu.assertNotEquals(result, num)
    end
    function TestMoveToGridWorks:test_MoveToGridCeil_OffGrid_ThenMoves()
        -- given
        local num = 3.3
        
        -- when
        local result = Grid.move_to_grid_ceil(num)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(type(result), "number")
        lu.assertTrue(Grid.is_number_on_grid(result))
        lu.assertNotEquals(result, num)
    end
    function TestMoveToGridWorks:test_MoveToGridFloor_PerfectlyOffGrid_ThenMoves()
        -- given
        local num = 7.5
        
        -- when
        local result = Grid.move_to_grid_floor(num)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(type(result), "number")
        lu.assertTrue(Grid.is_number_on_grid(result))
        lu.assertNotEquals(result, num)
    end
    function TestMoveToGridWorks:test_MoveToGridCeil_PerfectlyOffGrid_ThenMoves()
        -- given
        local num = 7.5
        
        -- when
        local result = Grid.move_to_grid_ceil(num)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(type(result), "number")
        lu.assertTrue(Grid.is_number_on_grid(result))
        lu.assertNotEquals(result, num)
    end
    
TestMovePerfectlyOffGridWorks = {}
    function TestMovePerfectlyOffGridWorks:test_MovePerfectlyOffGridFloor_PerfectlyOffGrid_ThenNotMoved()
        -- given
        local num = 7.5
        
        -- when
        local result = Grid.move_perfectly_off_grid_floor(num)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(type(result), "number")
        lu.assertTrue(Grid.is_number_perfectly_off_grid(result))
        lu.assertEquals(result, num)
    end
    function TestMovePerfectlyOffGridWorks:test_MovePerfectlyOffGridCeil_PerfectlyOffGrid_ThenNotMoved()
        -- given
        local num = 7.5
        
        -- when
        local result = Grid.move_perfectly_off_grid_ceil(num)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(type(result), "number")
        lu.assertTrue(Grid.is_number_perfectly_off_grid(result))
        lu.assertEquals(result, num)
    end
    function TestMovePerfectlyOffGridWorks:test_MovePerfectlyOffGridFloor_PerfectlyOnGrid_ThenMoves()
        -- given
        local num = 3
        
        -- when
        local result = Grid.move_perfectly_off_grid_floor(num)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(type(result), "number")
        lu.assertTrue(Grid.is_number_perfectly_off_grid(result))
        lu.assertNotEquals(result, num)
    end
    function TestMovePerfectlyOffGridWorks:test_MovePerfectlyOffGridCeil_PerfectlyOnGrid_ThenMoves()
        -- given
        local num = 4
        
        -- when
        local result = Grid.move_perfectly_off_grid_ceil(num)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(type(result), "number")
        lu.assertTrue(Grid.is_number_perfectly_off_grid(result))
        lu.assertNotEquals(result, num)
    end
    function TestMovePerfectlyOffGridWorks:test_MovePerfectlyOffGridFloor_OffGrid_ThenMoves()
        -- given
        local num = 3.3
        
        -- when
        local result = Grid.move_perfectly_off_grid_floor(num)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(type(result), "number")
        lu.assertTrue(Grid.is_number_perfectly_off_grid(result))
        lu.assertNotEquals(result, num)
    end
    function TestMovePerfectlyOffGridWorks:test_MovePerfectlyOffGridCeil_OffGrid_ThenMoves()
        -- given
        local num = 3.3
        
        -- when
        local result = Grid.move_perfectly_off_grid_ceil(num)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(type(result), "number")
        lu.assertTrue(Grid.is_number_perfectly_off_grid(result))
        lu.assertNotEquals(result, num)
    end

return lu.LuaUnit.run()