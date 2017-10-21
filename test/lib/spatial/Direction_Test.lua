local lu = require('luaunit')
local Direction = require('lib.logic.model.spatial.Direction')

TestRotateDegreesFromDefault = {}
    function TestRotateDegreesFromDefault:testAddZero()
        lu.assertStrContains(Direction.rotate_degrees_from_default(0),"north")
    end
    
TestRotateDegreesFromNorth = {}
    function TestRotateDegreesFromNorth:testAddZero()
        lu.assertStrContains(Direction.rotate_degrees_from_default(0),"north")
    end
    function TestRotateDegreesFromNorth:testAdd45()
        lu.assertStrContains(Direction.rotate_degrees_from_default(45),"northeast")
    end
    function TestRotateDegreesFromNorth:testAdd90()
        lu.assertStrContains(Direction.rotate_degrees_from_default(90),"east")
    end
    function TestRotateDegreesFromNorth:testAdd135()
        lu.assertStrContains(Direction.rotate_degrees_from_default(135),"southeast")
    end
    function TestRotateDegreesFromNorth:testAdd180()
        lu.assertStrContains(Direction.rotate_degrees_from_default(180),"south")
    end
    function TestRotateDegreesFromNorth:testAdd225()
        lu.assertStrContains(Direction.rotate_degrees_from_default(225),"southwest")
    end
    function TestRotateDegreesFromNorth:testAdd270()
        lu.assertStrContains(Direction.rotate_degrees_from_default(270),"west")
    end
    function TestRotateDegreesFromNorth:testAdd315()
        lu.assertStrContains(Direction.rotate_degrees_from_default(315),"northwest")
    end
    function TestRotateDegreesFromNorth:testAdd360()
        lu.assertStrContains(Direction.rotate_degrees_from_default(360),"north")
    end
    function TestRotateDegreesFromNorth:testSub45()
        lu.assertStrContains(Direction.rotate_degrees_from_default(-45),"northwest")
    end
    function TestRotateDegreesFromNorth:testSub90()
        lu.assertStrContains(Direction.rotate_degrees_from_default(-90),"west")
    end
    function TestRotateDegreesFromNorth:testSub135()
        lu.assertStrContains(Direction.rotate_degrees_from_default(-135),"southwest")
    end
    function TestRotateDegreesFromNorth:testSub180()
        lu.assertStrContains(Direction.rotate_degrees_from_default(-180),"south")
    end
    function TestRotateDegreesFromNorth:testSub225()
        lu.assertStrContains(Direction.rotate_degrees_from_default(-225),"southeast")
    end
    function TestRotateDegreesFromNorth:testSub270()
        lu.assertStrContains(Direction.rotate_degrees_from_default(-270),"east")
    end
    function TestRotateDegreesFromNorth:testSub315()
        lu.assertStrContains(Direction.rotate_degrees_from_default(-315),"northeast")
    end
    function TestRotateDegreesFromNorth:testSub360()
        lu.assertStrContains(Direction.rotate_degrees_from_default(-360),"north")
    end

TestDifferentStarts = {}
    function TestDifferentStarts:test90FromEast()
        lu.assertStrContains(Direction.rotate_clockwise_dir_degrees("defines.direction.east", 90),"south")
    end
    function TestDifferentStarts:test135FromSouthWest()
        lu.assertStrContains(Direction.rotate_clockwise_dir_degrees("defines.direction.southwest", 135),"north")
    end
    function TestDifferentStarts:test90FromWest()
        lu.assertStrContains(Direction.rotate_clockwise_dir_degrees("defines.direction.west", 90),"north")
    end
    function TestDifferentStarts:test135FromWest()
        lu.assertStrContains(Direction.rotate_clockwise_dir_degrees("defines.direction.west", 135),"northeast")
    end
    
TestAnticlockwise = {}
    function TestAnticlockwise:test90FromSouthWest()
        lu.assertStrContains(Direction.rotate_anticlockwise_dir_degrees("defines.direction.southwest", 90),"southeast")
    end
    
--[[
print("fractions")
print(Direction.rotate_clockwise_dir_degrees("defines.direction.north", 1)) -- should be "north"
print(Direction.rotate_clockwise_dir_degrees("defines.direction.north", 22.4)) -- should be "north"
print(Direction.rotate_clockwise_dir_degrees("defines.direction.north", 22.5)) -- should be "northeast"
print(Direction.rotate_clockwise_dir_degrees("defines.direction.north", 367)) -- should be "north"
]]

return lu.LuaUnit.run()