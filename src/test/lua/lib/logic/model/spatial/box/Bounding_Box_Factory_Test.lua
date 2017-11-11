local lu = require('luaunit')
local Grid_Box = require('lib.logic.model.spatial.box.Grid_Box')
local Position = require('lib.logic.model.spatial.Position')
local Bounding_Box = require('lib.logic.model.spatial.box.Bounding_Box')
local Bounding_Box_Factory = require('lib.logic.model.spatial.box.Bounding_Box_Factory')
    
TestBoundingBoxFactoryWorks = {}
    function TestBoundingBoxFactoryWorks:testNewCreatesAnObject()
        -- given
        
        -- when
        local result = Bounding_Box_Factory.new()
        
        -- then
        lu.assertNotNil(result)
    end
    function TestBoundingBoxFactoryWorks:testNewCreatesAnObject()
        -- given
        local factory = Bounding_Box_Factory.new()
        
        -- when
        local result = factory:build()
        
        -- then
        lu.assertNil(result)
    end
    
    function TestBoundingBoxFactoryWorks:testWorksOnSinglePosition()
        -- given
        local some_position = Position.new(1,2)
        
        -- when
        local result = Bounding_Box_Factory.new():with_position(some_position):build()
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(result:get_left_top(), some_position)
        lu.assertEquals(result:get_right_bottom(), some_position)
    end
    
    function TestBoundingBoxFactoryWorks:testWorksOnTwoPositions()
        -- given
        local left_top = Position.new(1,2)
        local right_bottom = Position.new(2,3)
        
        local factory = Bounding_Box_Factory.new()
        factory:with_position(left_top)
        factory:with_position(right_bottom)
        
        -- when
        local result = factory:build()
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(result:get_left_top(), left_top)
        lu.assertEquals(result:get_right_bottom(), right_bottom)
    end
    
    function TestBoundingBoxFactoryWorks:testWorksOnTwoPositionsReversed()
        -- given
        local left_top = Position.new(1,2)
        local right_bottom = Position.new(2,3)
        
        local factory = Bounding_Box_Factory.new()
        factory:with_position(right_bottom)
        factory:with_position(left_top)
        
        -- when
        local result = factory:build()
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(result:get_left_top(), left_top)
        lu.assertEquals(result:get_right_bottom(), right_bottom)
    end
    
    function TestBoundingBoxFactoryWorks:testWorksOnMultiplePositions()
        -- given
        local positions = {}
        table.insert(positions, Position.new(1,2))
        table.insert(positions, Position.new(2,3))
        table.insert(positions, Position.new(1,4))
        table.insert(positions, Position.new(2,1))
        
        local expected_left_top = Position.new(1,1)
        local expected_right_bottom = Position.new(2,4)
        
        local factory = Bounding_Box_Factory.new()
        for any_order, element in pairs(positions)do
            factory:with_position(element)
        end
        
        -- when
        local result = factory:build()
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(result:get_left_top(), expected_left_top)
        lu.assertEquals(result:get_right_bottom(), expected_right_bottom)
    end
    
    function TestBoundingBoxFactoryWorks:testWorksOnMultiplePositions()
        -- given
        local positions = {}
        table.insert(positions, Position.new(1,2))
        table.insert(positions, Position.new(2,3))
        table.insert(positions, Position.new(1,4))
        table.insert(positions, Position.new(2,1))
        
        local expected_left_top = Position.new(1,1)
        local expected_right_bottom = Position.new(2,4)
        
        local factory = Bounding_Box_Factory.new()
        for any_order, element in pairs(positions)do
            factory:with_position(element)
        end
        
        -- when
        local result = factory:build()
        
        -- then
        lu.assertNotNil(result)
        lu.assertEquals(result:get_left_top(), expected_left_top)
        lu.assertEquals(result:get_right_bottom(), expected_right_bottom)
    end

return lu.LuaUnit.run()