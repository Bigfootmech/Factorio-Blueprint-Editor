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

return lu.LuaUnit.run()