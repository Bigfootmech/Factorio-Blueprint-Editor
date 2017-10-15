
lu = require('luaunit')
Direction = require('lib.spatial.Direction')

TestRotateDegreesFromDefault = {}
    function TestRotateDegreesFromDefault:testAddZero()
        lu.assertEquals(Direction.rotate_degrees_from_default(0),"defines.direction.north")
    end
    
TestRotateDegreesFromNorth = {}
    function TestRotateDegreesFromNorth:testAddZero()
        lu.assertEquals(Direction.rotate_degrees_from_default(0),"defines.direction.north")
    end
    function TestRotateDegreesFromNorth:testAdd45()
        lu.assertEquals(Direction.rotate_degrees_from_default(45),"defines.direction.northeast")
    end
    function TestRotateDegreesFromNorth:testAdd90()
        lu.assertEquals(Direction.rotate_degrees_from_default(90),"defines.direction.east")
    end
    function TestRotateDegreesFromNorth:testAdd135()
        lu.assertEquals(Direction.rotate_degrees_from_default(135),"defines.direction.southeast")
    end
    function TestRotateDegreesFromNorth:testAdd180()
        lu.assertEquals(Direction.rotate_degrees_from_default(180),"defines.direction.south")
    end
    function TestRotateDegreesFromNorth:testAdd225()
        lu.assertEquals(Direction.rotate_degrees_from_default(225),"defines.direction.southwest")
    end
    function TestRotateDegreesFromNorth:testAdd270()
        lu.assertEquals(Direction.rotate_degrees_from_default(270),"defines.direction.west")
    end
    function TestRotateDegreesFromNorth:testAdd315()
        lu.assertEquals(Direction.rotate_degrees_from_default(315),"defines.direction.northwest")
    end
    function TestRotateDegreesFromNorth:testAdd360()
        lu.assertEquals(Direction.rotate_degrees_from_default(360),"defines.direction.north")
    end
    function TestRotateDegreesFromNorth:testSub45()
        lu.assertEquals(Direction.rotate_degrees_from_default(-45),"defines.direction.northwest")
    end
    function TestRotateDegreesFromNorth:testSub90()
        lu.assertEquals(Direction.rotate_degrees_from_default(-90),"defines.direction.west")
    end
    function TestRotateDegreesFromNorth:testSub135()
        lu.assertEquals(Direction.rotate_degrees_from_default(-135),"defines.direction.southwest")
    end
    function TestRotateDegreesFromNorth:testSub180()
        lu.assertEquals(Direction.rotate_degrees_from_default(-180),"defines.direction.south")
    end
    function TestRotateDegreesFromNorth:testSub225()
        lu.assertEquals(Direction.rotate_degrees_from_default(-225),"defines.direction.southeast")
    end
    function TestRotateDegreesFromNorth:testSub270()
        lu.assertEquals(Direction.rotate_degrees_from_default(-270),"defines.direction.east")
    end
    function TestRotateDegreesFromNorth:testSub315()
        lu.assertEquals(Direction.rotate_degrees_from_default(-315),"defines.direction.northeast")
    end
    function TestRotateDegreesFromNorth:testSub360()
        lu.assertEquals(Direction.rotate_degrees_from_default(-360),"defines.direction.north")
    end

TestDifferentStarts = {}
print("different starts")
    function TestDifferentStarts:test90FromEast()
        lu.assertEquals(Direction.rotate_clockwise_dir_degrees("defines.direction.east", 90),"defines.direction.south")
    end
    function TestDifferentStarts:test135FromSouthWest()
        lu.assertEquals(Direction.rotate_clockwise_dir_degrees("defines.direction.southwest", 135),"defines.direction.north")
    end
    function TestDifferentStarts:test90FromWest()
        lu.assertEquals(Direction.rotate_clockwise_dir_degrees("defines.direction.west", 90),"defines.direction.north")
    end
    function TestDifferentStarts:test135FromWest()
        lu.assertEquals(Direction.rotate_clockwise_dir_degrees("defines.direction.west", 135),"defines.direction.northeast")
    end
    
TestAnticlockwise = {}
    function TestAnticlockwise:test90FromSouthWest()
        lu.assertEquals(Direction.rotate_anticlockwise_dir_degrees("defines.direction.southwest", 90),"defines.direction.southeast")
    end
    
--[[
print("fractions")
print(Direction.rotate_clockwise_dir_degrees("defines.direction.north", 1)) -- should be "north"
print(Direction.rotate_clockwise_dir_degrees("defines.direction.north", 22.4)) -- should be "north"
print(Direction.rotate_clockwise_dir_degrees("defines.direction.north", 22.5)) -- should be "northeast"
print(Direction.rotate_clockwise_dir_degrees("defines.direction.north", 367)) -- should be "north"
]]

os.exit(lu.LuaUnit.run())