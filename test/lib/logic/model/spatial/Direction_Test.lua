local lu = require('luaunit')
local Direction = require('lib.logic.model.spatial.Direction')

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

TestRotateDegreesFromDefault = {}
    function TestRotateDegreesFromDefault:testAddZero()
        lu.assertEquals(Direction.rotate_degrees_from_default(0), defines.direction.north)
    end
    
TestRotateDegreesFromNorth = {}
    function TestRotateDegreesFromNorth:testAddZero()
        lu.assertEquals(Direction.rotate_degrees_from_default(0), defines.direction.north)
    end
    function TestRotateDegreesFromNorth:testAdd45()
        lu.assertEquals(Direction.rotate_degrees_from_default(45), defines.direction.northeast)
    end
    function TestRotateDegreesFromNorth:testAdd90()
        lu.assertEquals(Direction.rotate_degrees_from_default(90), defines.direction.east)
    end
    function TestRotateDegreesFromNorth:testAdd135()
        lu.assertEquals(Direction.rotate_degrees_from_default(135), defines.direction.southeast)
    end
    function TestRotateDegreesFromNorth:testAdd180()
        lu.assertEquals(Direction.rotate_degrees_from_default(180), defines.direction.south)
    end
    function TestRotateDegreesFromNorth:testAdd225()
        lu.assertEquals(Direction.rotate_degrees_from_default(225), defines.direction.southwest)
    end
    function TestRotateDegreesFromNorth:testAdd270()
        lu.assertEquals(Direction.rotate_degrees_from_default(270), defines.direction.west)
    end
    function TestRotateDegreesFromNorth:testAdd315()
        lu.assertEquals(Direction.rotate_degrees_from_default(315), defines.direction.northwest)
    end
    function TestRotateDegreesFromNorth:testAdd360()
        lu.assertEquals(Direction.rotate_degrees_from_default(360), defines.direction.north)
    end
    function TestRotateDegreesFromNorth:testSub45()
        lu.assertEquals(Direction.rotate_degrees_from_default(-45), defines.direction.northwest)
    end
    function TestRotateDegreesFromNorth:testSub90()
        lu.assertEquals(Direction.rotate_degrees_from_default(-90), defines.direction.west)
    end
    function TestRotateDegreesFromNorth:testSub135()
        lu.assertEquals(Direction.rotate_degrees_from_default(-135), defines.direction.southwest)
    end
    function TestRotateDegreesFromNorth:testSub180()
        lu.assertEquals(Direction.rotate_degrees_from_default(-180), defines.direction.south)
    end
    function TestRotateDegreesFromNorth:testSub225()
        lu.assertEquals(Direction.rotate_degrees_from_default(-225), defines.direction.southeast)
    end
    function TestRotateDegreesFromNorth:testSub270()
        lu.assertEquals(Direction.rotate_degrees_from_default(-270), defines.direction.east)
    end
    function TestRotateDegreesFromNorth:testSub315()
        lu.assertEquals(Direction.rotate_degrees_from_default(-315), defines.direction.northeast)
    end
    function TestRotateDegreesFromNorth:testSub360()
        lu.assertEquals(Direction.rotate_degrees_from_default(-360), defines.direction.north)
    end

TestDifferentStarts = {}
    function TestDifferentStarts:test90FromEast()
        lu.assertEquals(Direction.rotate_clockwise_dir_degrees(defines.direction.east, 90), defines.direction.south)
    end
    function TestDifferentStarts:test135FromSouthWest()
        lu.assertEquals(Direction.rotate_clockwise_dir_degrees(defines.direction.southwest, 135), defines.direction.north)
    end
    function TestDifferentStarts:test90FromWest()
        lu.assertEquals(Direction.rotate_clockwise_dir_degrees(defines.direction.west, 90), defines.direction.north)
    end
    function TestDifferentStarts:test135FromWest()
        lu.assertEquals(Direction.rotate_clockwise_dir_degrees(defines.direction.west, 135), defines.direction.northeast)
    end
    
TestAnticlockwise = {}
    function TestAnticlockwise:test90FromSouthWest()
        lu.assertEquals(Direction.rotate_anticlockwise_dir_degrees(defines.direction.southwest, 90), defines.direction.southeast)
    end
    
TestFractions = {}
    function TestFractions:test1degree()
        lu.assertEquals(Direction.rotate_clockwise_dir_degrees(defines.direction.north, 1), defines.direction.north)
    end
    function TestFractions:test22and4degrees()
        lu.assertEquals(Direction.rotate_clockwise_dir_degrees(defines.direction.north, 22.4), defines.direction.north)
    end
    function TestFractions:test22and5degrees()
        lu.assertEquals(Direction.rotate_clockwise_dir_degrees(defines.direction.north, 22.5), defines.direction.northeast)
    end
    function TestFractions:test367degrees()
        lu.assertEquals(Direction.rotate_clockwise_dir_degrees(defines.direction.north, 367), defines.direction.north)
    end

return lu.LuaUnit.run()