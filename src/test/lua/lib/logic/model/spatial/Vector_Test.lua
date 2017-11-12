local lu = require('luaunit')
local Vector = require('lib.logic.model.spatial.Vector')

local epsilon = 0.00001
    
TestIsVectorWorks = {}
    function TestIsVectorWorks:testWorksOnGameObjects()
        -- given
        local game_vector = {1,2}
        
        -- when
        local result = Vector.is_vector(game_vector)
        
        -- then
        lu.assertTrue(result)
    end
    
    function TestIsVectorWorks:testNilFails()
        -- given
        local obj = nil
        
        -- when
        local result = Vector.is_vector(obj)
        
        -- then
        lu.assertFalse(result)
    end
    
    function TestIsVectorWorks:testTooShortFails()
        -- given
        local obj = {1}
        
        -- when
        local result = Vector.is_vector(obj)
        
        -- then
        lu.assertFalse(result)
    end
    
    function TestIsVectorWorks:testTooLongWorks()
        -- given
        local obj = {1,2,3}
        
        -- when
        local result = Vector.is_vector(obj)
        
        -- then
        lu.assertTrue(result)
    end
    
    function TestIsVectorWorks:testOnlyWorksOnNumbers()
        -- given
        local obj = {"blarg", 4}
        
        -- when
        local result = Vector.is_vector(obj)
        
        -- then
        lu.assertFalse(result)
    end
    function TestIsVectorWorks:testWorksOnWeirdObjects()
        -- given
        local weird_vector = {}
        weird_vector[1] = "6.5"
        weird_vector[2] = "-2"
        
        -- when
        local result = Vector.is_vector(weird_vector)
        
        -- then
        lu.assertTrue(result)
    end

TestCreateVector = {}
    function TestCreateVector:testCreated()
        -- given
        local x = 0
        local y = 1
        
        -- when
        local vec = Vector.new(x, y)
        
        -- then
        lu.assertNotNil(vec)
        lu.assertTrue(Vector.is_vector(vec))
        lu.assertEquals(vec[1], x)
        lu.assertTrue(vec[2], y)
    end
    function TestCreateVector:testCreatedFromTable()
        -- given
        local x = 0
        local y = 1
        local some_table = {x,y}
        
        -- when
        local vec = Vector.from_table(some_table)
        
        -- then
        lu.assertNotNil(vec)
        lu.assertTrue(Vector.is_vector(vec))
        lu.assertEquals(vec[1], x)
        lu.assertTrue(vec[2], y)
    end
    
    function TestCreateVector:testCreatedIndependently()
        -- given
        local x1 = 0
        local y1 = 1
        local x2 = 2
        local y2 = 3
        
        -- when
        local vec1 = Vector.new(x1, y1)
        local vec2 = Vector.new(x2, y2)
        
        -- then
        lu.assertEquals(vec1[1], 0)
        lu.assertTrue(vec1[2], 1)
        lu.assertEquals(vec2[1], 2)
        lu.assertTrue(vec2[2], 3)
    end
    
    function TestCreateVector:testTooShortFails()
        -- given
        local x = 1
        
        -- when -- then
        lu.assertError(Vector.new, x)
    end

TestMutability = {}
    function TestMutability:testMutable()
        -- given
        local x = 0
        local y = 1
        local vec = Vector.new(x, y)
        
        -- when
        vec[1] = 1
        vec[2] = 2
        
        -- then
        lu.assertEquals(vec[1], 1)
        lu.assertEquals(vec[2], 2)
    end
    function TestMutability:testRemovingAPartStopsItBeingAVector()
        -- given
        local x = 0
        local y = 1
        local vec = Vector.new(x, y)
        
        -- when
        vec[1] = nil
        
        -- then
        lu.assertEquals(vec[1], nil)
        lu.assertFalse(Vector.is_vector(vec))
    end

TestCreateSpecialVectors = {}
    function TestCreateSpecialVectors:testVectorsCreate()
        -- given
        
        -- when
        local zero = Vector.zero()
        local up = Vector.up()
        local down = Vector.down()
        local left = Vector.left()
        local right = Vector.right()
        
        -- then
        lu.assertTrue(Vector.is_vector(zero))
        lu.assertTrue(Vector.is_vector(up))
        lu.assertTrue(Vector.is_vector(down))
        lu.assertTrue(Vector.is_vector(left))
        lu.assertTrue(Vector.is_vector(right))
    end

TestMagnitude = {}
    function TestMagnitude:testVectorMagnitudeZero()
        -- given
        local x = 0
        local y = 0
        local vec = Vector.new(x,y)
        
        -- when
        local mag = vec:magnitude()
        
        -- then
        lu.assertEquals(mag, 0)
    end
    function TestMagnitude:testVectorMagnitudeX()
        -- given
        local x = 1
        local y = 0
        local vec = Vector.new(x,y)
        
        -- when
        local mag = vec:magnitude()
        
        -- then
        lu.assertEquals(mag, 1)
    end
    function TestMagnitude:testVectorMagnitudeY()
        -- given
        local x = 0
        local y = 1
        local vec = Vector.new(x,y)
        
        -- when
        local mag = vec:magnitude()
        
        -- then
        lu.assertEquals(mag, 1)
    end
    function TestMagnitude:testVectorMagnitudeCombined()
        -- given
        local x = 1
        local y = 1
        local vec = Vector.new(x,y)
        
        -- when
        local mag = vec:magnitude()
        
        -- then
        lu.assertEquals(mag, math.sqrt(2))
    end
    
TestAddition = {}
    function TestAddition:testAddWorksAnyNumberSign()
        -- given
        local x_1 = 3
        local y_1 = 7
        
        local x_2 = 5
        local y_2 = 11
        
        local vec_1 = Vector.new(x_1,y_1)
        local vec_2 = Vector.new(x_2,y_2)
        
        local expected_x = x_1 + x_2
        local expected_y = y_1 + y_2
        
        -- when
        local result = vec_1 + vec_2
        
        -- then
        lu.assertNotNil(result)
        lu.assertTrue(Vector.is_vector(result))
        lu.assertEquals(result[1], expected_x)
        lu.assertEquals(result[2], expected_y)
    end
    
    function TestAddition:testSubtractWorksAnyNumberSign()
        -- given
        local x_1 = 4
        local y_1 = 9
        
        local x_2 = 142
        local y_2 = 33
        
        local vec_1 = Vector.new(x_1,y_1)
        local vec_2 = Vector.new(x_2,y_2)
        
        local expected_x = x_1 - x_2
        local expected_y = y_1 - y_2
        
        -- when
        local result = vec_1 - vec_2
        
        -- then
        lu.assertNotNil(result)
        lu.assertTrue(Vector.is_vector(result))
        lu.assertEquals(result[1], expected_x)
        lu.assertEquals(result[2], expected_y)
    end
 
TestMultiplication = {}
    function TestMultiplication:testMultiply()
        -- given
        local x = 0
        local y = 1
        local mulfact = 2
        
        local vec = Vector.new(x,y)
        
        local mag = vec:magnitude()
        local finalmag = mag * mulfact
        
        -- when
        vec = vec:multiply(mulfact)
        
        -- then
        lu.assertEquals(vec:magnitude(), finalmag)
    end
    function TestMultiplication:testMultiplySign()
        -- given
        local x = 0
        local y = 1
        local mulfact = 2
        
        local vec = Vector.new(x,y)
        
        local mag = vec:magnitude()
        local finalmag = mag * mulfact
        
        -- when
        vec = vec * mulfact
        
        -- then
        lu.assertEquals(vec:magnitude(), finalmag)
    end
    
    function TestMultiplication:testMultiplyWorksAnyValues()
        -- given
        local x = 3
        local y = 5
        local mulfact = 9
        
        local vec = Vector.new(x,y)
        
        local mag = vec:magnitude()
        local finalmag = mag * mulfact
        
        -- when
        vec = vec:multiply(mulfact)
        
        -- then
        lu.assertEquals(vec:magnitude(), finalmag)
    end
    
    function TestMultiplication:testDivisionWorksAnyValues()
        -- given
        local x = 7
        local y = 2
        local mulfact = 4
        
        local vec = Vector.new(x,y)
        
        local mag = vec:magnitude()
        local finalmag = mag / mulfact
        
        -- when
        vec = vec:divide(mulfact)
        
        -- then
        lu.assertEquals(vec:magnitude(), finalmag)
    end
    
    function TestMultiplication:testDivisionWorksSign()
        -- given
        local x = 7
        local y = 2
        local mulfact = 4
        
        local vec = Vector.new(x,y)
        
        local mag = vec:magnitude()
        local finalmag = mag / mulfact
        
        -- when
        vec = vec / mulfact
        
        -- then
        lu.assertEquals(vec:magnitude(), finalmag)
    end
 
TestUnitVector = {}
    function TestUnitVector:testBasic()
        -- given
        local x = 1
        local y = 1
        
        local vec = Vector.new(x,y)
        
        local mag = vec:magnitude()
        lu.assertEquals(vec:magnitude(), math.sqrt(2))
        
        -- when
        local result = vec:get_unit_vector()
        
        -- then
        lu.assertAlmostEquals(result:magnitude(), 1, epsilon)
    end
    
    function TestUnitVector:testWorksOnAnyVectorBig()
        -- given
        local x = 13
        local y = 22
        local vec = Vector.new(x,y)
        
        -- when
        local result = vec:get_unit_vector()
        
        -- then
        lu.assertAlmostEquals(result:magnitude(), 1, epsilon)
    end
    
    function TestUnitVector:testWorksOnAnyVectorSmall()
        -- given
        local x = 0.003
        local y = 0.05
        local vec = Vector.new(x,y)
        
        -- when
        local result = vec:get_unit_vector()
        
        -- then
        lu.assertAlmostEquals(result:magnitude(), 1, epsilon)
    end

return lu.LuaUnit.run()