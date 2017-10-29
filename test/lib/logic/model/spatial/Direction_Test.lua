local lu = require('luaunit')

defines = {}
defines.direction = {}
defines.direction.north     = 0
defines.direction.northeast = 1
defines.direction.east      = 2
defines.direction.southeast = 3
defines.direction.south     = 4
defines.direction.southwest = 5
defines.direction.west      = 6
defines.direction.northwest = 7

local Direction = require('lib.logic.model.spatial.Direction')

TestSimpleWorks = {}
    function TestSimpleWorks:testAddZero()
        -- given
        local start = defines.direction.north
        local times = 0
        local eight_axis_boolean = false
        
        -- when
        local result = Direction.rotate_x_times_clockwise_from_dir(start, times, eight_axis_boolean)
        
        -- then
        lu.assertEquals(result, defines.direction.north)
    end

TestRotateDegreesFromDefault = {}
    function TestRotateDegreesFromDefault:testAddZero()
        lu.assertEquals(Direction.rotate_x_times_from_default(0), defines.direction.north)
    end
    

TestRotateDegreesFromDefaultDefaultAxis = {}
    function TestRotateDegreesFromDefaultDefaultAxis:testAddZero()
        lu.assertEquals(Direction.rotate_x_times_from_default(0), defines.direction.north)      
    end                                                                                         
    function TestRotateDegreesFromDefaultDefaultAxis:testAdd45()                                
        lu.assertEquals(Direction.rotate_x_times_from_default(1), defines.direction.east)       
    end                                                                                         
    function TestRotateDegreesFromDefaultDefaultAxis:testAdd90()                                
        lu.assertEquals(Direction.rotate_x_times_from_default(2), defines.direction.south)      
    end                                                                                         
    function TestRotateDegreesFromDefaultDefaultAxis:testAdd135()                               
        lu.assertEquals(Direction.rotate_x_times_from_default(3), defines.direction.west)       
    end                                                                                         
    function TestRotateDegreesFromDefaultDefaultAxis:testAdd180()                               
        lu.assertEquals(Direction.rotate_x_times_from_default(4), defines.direction.north)      
    end                                                                                         
    function TestRotateDegreesFromDefaultDefaultAxis:testAdd225()                               
        lu.assertEquals(Direction.rotate_x_times_from_default(5), defines.direction.east)       
    end                                                                                         
    function TestRotateDegreesFromDefaultDefaultAxis:testAdd270()                               
        lu.assertEquals(Direction.rotate_x_times_from_default(6), defines.direction.south)      
    end                                                                                         
    function TestRotateDegreesFromDefaultDefaultAxis:testAdd315()                               
        lu.assertEquals(Direction.rotate_x_times_from_default(7), defines.direction.west)       
    end                                                                                         
    function TestRotateDegreesFromDefaultDefaultAxis:testAdd360()                               
        lu.assertEquals(Direction.rotate_x_times_from_default(8), defines.direction.north)      
    end                                                                                          
    function TestRotateDegreesFromDefaultDefaultAxis:testSub45()                                 
        lu.assertEquals(Direction.rotate_x_times_from_default(-1), defines.direction.west)      
    end                                                                                         
    function TestRotateDegreesFromDefaultDefaultAxis:testSub90()                                
        lu.assertEquals(Direction.rotate_x_times_from_default(-2), defines.direction.south)     
    end                                                                                         
    function TestRotateDegreesFromDefaultDefaultAxis:testSub135()                               
        lu.assertEquals(Direction.rotate_x_times_from_default(-3), defines.direction.east)      
    end                                                                                         
    function TestRotateDegreesFromDefaultDefaultAxis:testSub180()                               
        lu.assertEquals(Direction.rotate_x_times_from_default(-4), defines.direction.north)     
    end                                                                                         
    function TestRotateDegreesFromDefaultDefaultAxis:testSub225()                               
        lu.assertEquals(Direction.rotate_x_times_from_default(-5), defines.direction.west)      
    end                                                                                         
    function TestRotateDegreesFromDefaultDefaultAxis:testSub270()                               
        lu.assertEquals(Direction.rotate_x_times_from_default(-6), defines.direction.south)     
    end                                                                                         
    function TestRotateDegreesFromDefaultDefaultAxis:testSub315()                               
        lu.assertEquals(Direction.rotate_x_times_from_default(-7), defines.direction.east)      
    end                                                                                         
    function TestRotateDegreesFromDefaultDefaultAxis:testSub360()                               
        lu.assertEquals(Direction.rotate_x_times_from_default(-8), defines.direction.north)     
    end
    
TestRotateDegreesFromDefaultFourAxis = {}
    function TestRotateDegreesFromDefaultFourAxis:testAddZero()
        lu.assertEquals(Direction.rotate_x_times_from_default(0, false), defines.direction.north)
    end
    function TestRotateDegreesFromDefaultFourAxis:testAdd45()
        lu.assertEquals(Direction.rotate_x_times_from_default(1, false), defines.direction.east)
    end
    function TestRotateDegreesFromDefaultFourAxis:testAdd90()
        lu.assertEquals(Direction.rotate_x_times_from_default(2, false), defines.direction.south)
    end
    function TestRotateDegreesFromDefaultFourAxis:testAdd135()
        lu.assertEquals(Direction.rotate_x_times_from_default(3, false), defines.direction.west)
    end
    function TestRotateDegreesFromDefaultFourAxis:testAdd180()
        lu.assertEquals(Direction.rotate_x_times_from_default(4, false), defines.direction.north)
    end
    function TestRotateDegreesFromDefaultFourAxis:testAdd225()
        lu.assertEquals(Direction.rotate_x_times_from_default(5, false), defines.direction.east)
    end
    function TestRotateDegreesFromDefaultFourAxis:testAdd270()
        lu.assertEquals(Direction.rotate_x_times_from_default(6, false), defines.direction.south)
    end
    function TestRotateDegreesFromDefaultFourAxis:testAdd315()
        lu.assertEquals(Direction.rotate_x_times_from_default(7, false), defines.direction.west)
    end
    function TestRotateDegreesFromDefaultFourAxis:testAdd360()
        lu.assertEquals(Direction.rotate_x_times_from_default(8, false), defines.direction.north)
    end
    function TestRotateDegreesFromDefaultFourAxis:testSub45()
        lu.assertEquals(Direction.rotate_x_times_from_default(-1, false), defines.direction.west)
    end
    function TestRotateDegreesFromDefaultFourAxis:testSub90()
        lu.assertEquals(Direction.rotate_x_times_from_default(-2, false), defines.direction.south)
    end
    function TestRotateDegreesFromDefaultFourAxis:testSub135()
        lu.assertEquals(Direction.rotate_x_times_from_default(-3, false), defines.direction.east)
    end
    function TestRotateDegreesFromDefaultFourAxis:testSub180()
        lu.assertEquals(Direction.rotate_x_times_from_default(-4, false), defines.direction.north)
    end
    function TestRotateDegreesFromDefaultFourAxis:testSub225()
        lu.assertEquals(Direction.rotate_x_times_from_default(-5, false), defines.direction.west)
    end
    function TestRotateDegreesFromDefaultFourAxis:testSub270()
        lu.assertEquals(Direction.rotate_x_times_from_default(-6, false), defines.direction.south)
    end
    function TestRotateDegreesFromDefaultFourAxis:testSub315()
        lu.assertEquals(Direction.rotate_x_times_from_default(-7, false), defines.direction.east)
    end
    function TestRotateDegreesFromDefaultFourAxis:testSub360()
        lu.assertEquals(Direction.rotate_x_times_from_default(-8, false), defines.direction.north)
    end
    
TestRotateDegreesFromDefaultEightAxis = {}
    function TestRotateDegreesFromDefaultEightAxis:testAddZero()
        lu.assertEquals(Direction.rotate_x_times_from_default(0, true), defines.direction.north)
    end
    function TestRotateDegreesFromDefaultEightAxis:testAdd45()
        lu.assertEquals(Direction.rotate_x_times_from_default(1, true), defines.direction.northeast)
    end
    function TestRotateDegreesFromDefaultEightAxis:testAdd90()
        lu.assertEquals(Direction.rotate_x_times_from_default(2, true), defines.direction.east)
    end
    function TestRotateDegreesFromDefaultEightAxis:testAdd135()
        lu.assertEquals(Direction.rotate_x_times_from_default(3, true), defines.direction.southeast)
    end
    function TestRotateDegreesFromDefaultEightAxis:testAdd180()
        lu.assertEquals(Direction.rotate_x_times_from_default(4, true), defines.direction.south)
    end
    function TestRotateDegreesFromDefaultEightAxis:testAdd225()
        lu.assertEquals(Direction.rotate_x_times_from_default(5, true), defines.direction.southwest)
    end
    function TestRotateDegreesFromDefaultEightAxis:testAdd270()
        lu.assertEquals(Direction.rotate_x_times_from_default(6, true), defines.direction.west)
    end
    function TestRotateDegreesFromDefaultEightAxis:testAdd315()
        lu.assertEquals(Direction.rotate_x_times_from_default(7, true), defines.direction.northwest)
    end
    function TestRotateDegreesFromDefaultEightAxis:testAdd360()
        lu.assertEquals(Direction.rotate_x_times_from_default(8, true), defines.direction.north)
    end
    function TestRotateDegreesFromDefaultEightAxis:testSub45()
        lu.assertEquals(Direction.rotate_x_times_from_default(-1, true), defines.direction.northwest)
    end
    function TestRotateDegreesFromDefaultEightAxis:testSub90()
        lu.assertEquals(Direction.rotate_x_times_from_default(-2, true), defines.direction.west)
    end
    function TestRotateDegreesFromDefaultEightAxis:testSub135()
        lu.assertEquals(Direction.rotate_x_times_from_default(-3, true), defines.direction.southwest)
    end
    function TestRotateDegreesFromDefaultEightAxis:testSub180()
        lu.assertEquals(Direction.rotate_x_times_from_default(-4, true), defines.direction.south)
    end
    function TestRotateDegreesFromDefaultEightAxis:testSub225()
        lu.assertEquals(Direction.rotate_x_times_from_default(-5, true), defines.direction.southeast)
    end
    function TestRotateDegreesFromDefaultEightAxis:testSub270()
        lu.assertEquals(Direction.rotate_x_times_from_default(-6, true), defines.direction.east)
    end
    function TestRotateDegreesFromDefaultEightAxis:testSub315()
        lu.assertEquals(Direction.rotate_x_times_from_default(-7, true), defines.direction.northeast)
    end
    function TestRotateDegreesFromDefaultEightAxis:testSub360()
        lu.assertEquals(Direction.rotate_x_times_from_default(-8, true), defines.direction.north)
    end

TestDifferentStarts = {}
    function TestDifferentStarts:test90FromEast()
        lu.assertEquals(Direction.rotate_x_times_clockwise_from_dir(defines.direction.east, 2, true), defines.direction.south)
    end
    function TestDifferentStarts:test135FromSouthWest()
        lu.assertEquals(Direction.rotate_x_times_clockwise_from_dir(defines.direction.southwest, 3, true), defines.direction.north)
    end
    function TestDifferentStarts:test90FromWest()
        lu.assertEquals(Direction.rotate_x_times_clockwise_from_dir(defines.direction.west, 2, true), defines.direction.north)
    end
    function TestDifferentStarts:test135FromWest()
        lu.assertEquals(Direction.rotate_x_times_clockwise_from_dir(defines.direction.west, 3, true), defines.direction.northeast)
    end
    
TestAnticlockwise = {}
    function TestAnticlockwise:test90FromSouthWest()
        lu.assertEquals(Direction.rotate_x_times_anticlockwise_from_dir(defines.direction.southwest, 2, true), defines.direction.southeast)
    end

--[[
TestFractions = {} -- not necessary for now
    function TestFractions:test1degree()
        lu.assertEquals(Direction.rotate_x_times_clockwise_from_dir(defines.direction.north, 0.01, true), defines.direction.north)
    end
    function TestFractions:test22and4degrees()
        lu.assertEquals(Direction.rotate_x_times_clockwise_from_dir(defines.direction.north, 0.49, true), defines.direction.north)
    end
    function TestFractions:test22and5degrees()
        lu.assertEquals(Direction.rotate_x_times_clockwise_from_dir(defines.direction.north, 0.5, true), defines.direction.northeast)
    end
    function TestFractions:test367degrees()
        lu.assertEquals(Direction.rotate_x_times_clockwise_from_dir(defines.direction.north, 7.9, true), defines.direction.north)
    end
]]
    
TestMirrorInYAxis = {}
    function TestMirrorInYAxis:testMirrorNorth()
        -- given
        local start = defines.direction.north
        
        -- when
        local result = Direction.mirror_in_y_axis(start)
        
        -- then
        lu.assertEquals(result, defines.direction.north)
    end
    function TestMirrorInYAxis:testMirrorNorthEast()
        -- given
        local start = defines.direction.northeast
        
        -- when
        local result = Direction.mirror_in_y_axis(start)
        
        -- then
        lu.assertEquals(result, defines.direction.northwest)
    end
    function TestMirrorInYAxis:testMirrorEast()
        -- given
        local start = defines.direction.east
        
        -- when
        local result = Direction.mirror_in_y_axis(start)
        
        -- then
        lu.assertEquals(result, defines.direction.west)
    end
    function TestMirrorInYAxis:testMirrorSouthEast()
        -- given
        local start = defines.direction.southeast
        
        -- when
        local result = Direction.mirror_in_y_axis(start)
        
        -- then
        lu.assertEquals(result, defines.direction.southwest)
    end
    function TestMirrorInYAxis:testMirrorSouth()
        -- given
        local start = defines.direction.south
        
        -- when
        local result = Direction.mirror_in_y_axis(start)
        
        -- then
        lu.assertEquals(result, defines.direction.south)
    end
    function TestMirrorInYAxis:testMirrorSouthWest()
        -- given
        local start = defines.direction.southwest
        
        -- when
        local result = Direction.mirror_in_y_axis(start)
        
        -- then
        lu.assertEquals(result, defines.direction.southeast)
    end
    function TestMirrorInYAxis:testMirrorWest()
        -- given
        local start = defines.direction.west
        
        -- when
        local result = Direction.mirror_in_y_axis(start)
        
        -- then
        lu.assertEquals(result, defines.direction.east)
    end
    function TestMirrorInYAxis:testMirrorNorthWest()
        -- given
        local start = defines.direction.northwest
        
        -- when
        local result = Direction.mirror_in_y_axis(start)
        
        -- then
        lu.assertEquals(result, defines.direction.northeast)
    end
    
TestMirrorInXAxis = {}
    function TestMirrorInXAxis:testMirrorNorth()
        -- given
        local start = defines.direction.north
        
        -- when
        local result = Direction.mirror_in_x_axis(start)
        
        -- then
        lu.assertEquals(result, defines.direction.south)
    end
    function TestMirrorInXAxis:testMirrorNorthEast()
        -- given
        local start = defines.direction.northeast
        
        -- when
        local result = Direction.mirror_in_x_axis(start)
        
        -- then
        lu.assertEquals(result, defines.direction.southeast)
    end
    function TestMirrorInXAxis:testMirrorEast()
        -- given
        local start = defines.direction.east
        
        -- when
        local result = Direction.mirror_in_x_axis(start)
        
        -- then
        lu.assertEquals(result, defines.direction.east)
    end
    function TestMirrorInXAxis:testMirrorSouthEast()
        -- given
        local start = defines.direction.southeast
        
        -- when
        local result = Direction.mirror_in_x_axis(start)
        
        -- then
        lu.assertEquals(result, defines.direction.northeast)
    end
    function TestMirrorInXAxis:testMirrorSouth()
        -- given
        local start = defines.direction.south
        
        -- when
        local result = Direction.mirror_in_x_axis(start)
        
        -- then
        lu.assertEquals(result, defines.direction.north)
    end
    function TestMirrorInXAxis:testMirrorSouthWest()
        -- given
        local start = defines.direction.southwest
        
        -- when
        local result = Direction.mirror_in_x_axis(start)
        
        -- then
        lu.assertEquals(result, defines.direction.northwest)
    end
    function TestMirrorInXAxis:testMirrorWest()
        -- given
        local start = defines.direction.west
        
        -- when
        local result = Direction.mirror_in_x_axis(start)
        
        -- then
        lu.assertEquals(result, defines.direction.west)
    end
    function TestMirrorInXAxis:testMirrorNorthWest()
        -- given
        local start = defines.direction.northwest
        
        -- when
        local result = Direction.mirror_in_x_axis(start)
        
        -- then
        lu.assertEquals(result, defines.direction.southwest)
    end
    
TestMirrorInNorthEastAxis = {}
    function TestMirrorInNorthEastAxis:testMirrorNorth()
        -- given
        local start = defines.direction.north
        local axis = defines.direction.northeast
        
        -- when
        local result = Direction.mirror_in_axis(start, axis)
        
        -- then
        lu.assertEquals(result, defines.direction.east)
    end

return lu.LuaUnit.run()