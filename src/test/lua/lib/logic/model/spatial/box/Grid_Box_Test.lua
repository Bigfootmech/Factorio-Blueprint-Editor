local lu = require('luaunit')
local Grid_Box = require('lib.logic.model.spatial.box.Grid_Box')
local Position = require('lib.logic.model.spatial.Position')
local Bounding_Box = require('lib.logic.model.spatial.box.Bounding_Box')
local Bounding_Box_Factory = require('lib.logic.model.spatial.box.Bounding_Box_Factory')
    
TestGridBoxWorks = {}
    function TestGridBoxWorks:testWorksOnSinglePosition()
        -- given
        local some_position = Position.new(1,2)
        local bounding_box = Bounding_Box.new(some_position, some_position)
        
        -- when
        local result = Grid_Box.from_bounding_box_inner(bounding_box)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(result:get_left_top(), some_position)
        lu.assertEquals(result:get_right_bottom(), some_position)
        lu.assertEquals(result:get_centre_centre(), some_position)
    end
    
    function TestGridBoxWorks:testWorksOnMultiplePositions()
        -- given
        local some_position = Position.new(1,2)
        local other_position = Position.new(4,4)
        local bounding_box = Bounding_Box.new(some_position, other_position)
        
        -- when
        local result = Grid_Box.from_bounding_box_inner(bounding_box)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(result:get_left_top(), some_position)
        lu.assertEquals(result:get_right_bottom(), other_position)
        lu.assertTrue(Position.is_position(result:get_centre_centre()))
        lu.assertTrue(Position.is_on_grid(result:get_centre_centre()))
    end
    function TestGridBoxWorks:testInnerWorksOnSinglePositionOffgrid()
        -- given
        local some_position = Position.new(6.1,0.9)
        local bounding_box = Bounding_Box.new(some_position, some_position)
        
        -- when
        local result = Grid_Box.from_bounding_box_inner(bounding_box)
        
        -- then
        lu.assertNotNil(result)
        lu.assertTrue(Position.is_position(result:get_left_top()))
        lu.assertTrue(Position.is_on_grid(result:get_left_top()))
        lu.assertTrue(Position.is_position(result:get_right_bottom()))
        lu.assertTrue(Position.is_on_grid(result:get_right_bottom()))
        lu.assertTrue(Position.is_position(result:get_centre_centre()))
        lu.assertTrue(Position.is_on_grid(result:get_centre_centre()))
        lu.assertTrue(result:get_left_top():get_x() <= result:get_right_bottom():get_x())
        lu.assertTrue(result:get_left_top():get_y() <= result:get_right_bottom():get_y())
    end

return lu.LuaUnit.run()