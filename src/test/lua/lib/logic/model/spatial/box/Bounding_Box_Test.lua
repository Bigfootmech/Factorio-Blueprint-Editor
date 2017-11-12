local lu = require('luaunit')
local Grid_Box = require('lib.logic.model.spatial.box.Grid_Box')
local Position = require('lib.logic.model.spatial.Position')
local Bounding_Box = require('lib.logic.model.spatial.box.Bounding_Box')
local Bounding_Box_Factory = require('lib.logic.model.spatial.box.Bounding_Box_Factory')
    
TestBoundingBoxWorks = {}
    function TestBoundingBoxWorks:testWorksOnSinglePosition()
        -- given
        local some_position = Position.new(1,2)
        
        -- when
        local result = Bounding_Box.new(some_position, some_position)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(result:get_left_top(), some_position)
        lu.assertEquals(result:get_right_bottom(), some_position)
        lu.assertEquals(result:get_centre_centre(), some_position)
    end
    
    function TestBoundingBoxWorks:testWorksOnMultiplePositions()
        -- given
        local some_position = Position.new(1,2)
        local other_position = Position.new(3,4)
        
        -- when
        local result = Bounding_Box.new(some_position, other_position)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(result:get_left_top(), some_position)
        lu.assertEquals(result:get_right_bottom(), other_position)
        lu.assertTrue(Position.is_position(result:get_centre_centre()))
    end
    
    function TestBoundingBoxWorks:testMultiplePositionsCorrectsDirection()
        -- given
        local some_position = Position.new(1,2)
        local other_position = Position.new(3,4)
        
        -- when
        local result = Bounding_Box.new(other_position, some_position)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(result:get_left_top(), some_position)
        lu.assertEquals(result:get_right_bottom(), other_position)
        lu.assertTrue(Position.is_position(result:get_centre_centre()))
    end
    
    function TestBoundingBoxWorks:testMultiplePositionsCorrectsPartialDirectionX()
        -- given
        local some_position = Position.new(3,2)
        local other_position = Position.new(1,4)
        
        local expected_left_top = Position.new(1,2)
        local expected_right_bottom = Position.new(3,4)
        
        -- when
        local result = Bounding_Box.new(other_position, some_position)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(result:get_left_top(), expected_left_top)
        lu.assertEquals(result:get_right_bottom(), expected_right_bottom)
        lu.assertTrue(Position.is_position(result:get_centre_centre()))
    end
    
    function TestBoundingBoxWorks:testMultiplePositionsCorrectsPartialDirectionY()
        -- given
        local some_position = Position.new(1,4)
        local other_position = Position.new(3,2)
        
        local expected_left_top = Position.new(1,2)
        local expected_right_bottom = Position.new(3,4)
        
        -- when
        local result = Bounding_Box.new(other_position, some_position)
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(result:get_left_top(), expected_left_top)
        lu.assertEquals(result:get_right_bottom(), expected_right_bottom)
        lu.assertTrue(Position.is_position(result:get_centre_centre()))
    end

return lu.LuaUnit.run()