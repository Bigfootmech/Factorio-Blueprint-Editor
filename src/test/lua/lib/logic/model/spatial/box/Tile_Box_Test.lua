local lu = require('luaunit')
local Tile_Box = require('lib.logic.model.spatial.box.Tile_Box')
local Position = require('lib.logic.model.spatial.Position')
local Bounding_Box = require('lib.logic.model.spatial.box.Bounding_Box')
local Bounding_Box_Factory = require('lib.logic.model.spatial.box.Bounding_Box_Factory')
    
TestGridBoxWorks = {}
    function TestGridBoxWorks:testWorksOnSinglePosition()
        -- given
        local some_position = Position.new(0.5,0.5)
        local bounding_box = Bounding_Box.new(some_position, some_position)
        
        -- when
        local result = Tile_Box.from_collision_box(bounding_box)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(result:get_left_top(), some_position)
        lu.assertEquals(result:get_right_bottom(), some_position)
    end
    
    function TestGridBoxWorks:testWorksOnMultiplePositions()
        -- given
        local some_position = Position.new(1.5,2.5)
        local other_position = Position.new(4.5,4.5)
        local bounding_box = Bounding_Box.new(some_position, other_position)
        
        -- when
        local result = Tile_Box.from_collision_box(bounding_box)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(result:get_left_top(), some_position)
        lu.assertEquals(result:get_right_bottom(), other_position)
        lu.assertTrue(Position.is_position(result:get_centre_centre()))
    end
    function TestGridBoxWorks:testInnerWorksOnSinglePositionOngrid()
        -- given
        local some_position = Position.new(6,9)
        local bounding_box = Bounding_Box.new(some_position, some_position)
        
        -- when
        local result = Tile_Box.from_collision_box(bounding_box)
        
        -- then
        lu.assertNotNil(result)
        lu.assertTrue(Position.is_position(result:get_left_top()))
        lu.assertTrue(Position.is_perfectly_off_grid(result:get_left_top()))
        lu.assertTrue(Position.is_position(result:get_right_bottom()))
        lu.assertTrue(Position.is_perfectly_off_grid(result:get_right_bottom()))
        lu.assertTrue(Position.is_position(result:get_centre_centre()))
        lu.assertTrue(result:get_left_top():get_x() <= result:get_right_bottom():get_x())
        lu.assertTrue(result:get_left_top():get_y() <= result:get_right_bottom():get_y())
    end
    function TestGridBoxWorks:testInnerWorksForCombinatorNumbers()
        -- given
        local left_top = Position.new(-0.34765625,-1.1484375)
        local right_bottom = Position.new(0.34765625, 0.1484375)
        local bounding_box = Bounding_Box.new(left_top, right_bottom)
        
        -- when
        local result = Tile_Box.from_collision_box(bounding_box)
        
        -- then
        lu.assertNotNil(result)
        lu.assertTrue(Position.is_position(result:get_left_top()))
        lu.assertTrue(Position.is_perfectly_off_grid(result:get_left_top()))
        lu.assertTrue(Position.is_position(result:get_right_bottom()))
        lu.assertTrue(Position.is_perfectly_off_grid(result:get_right_bottom()))
        lu.assertTrue(Position.is_position(result:get_centre_centre()))
        lu.assertTrue(result:get_left_top():get_x() <= result:get_right_bottom():get_x())
        lu.assertTrue(result:get_left_top():get_y() <= result:get_right_bottom():get_y())
        lu.assertEquals(result:get_width(), 1)
        lu.assertEquals(result:get_height(), 2)
    end

return lu.LuaUnit.run()