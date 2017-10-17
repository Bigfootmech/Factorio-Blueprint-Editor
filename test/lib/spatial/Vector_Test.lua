
local lu = require('luaunit')
local Vector = require('lib.spatial.Vector')

local epsilon = 0.00001

TestCreateVector = {}
    function TestCreateVector:testCreated()
        -- given
        local x = 0
        local y = 1
        -- when
        local vec = Vector.new(x, y)
        -- then
        lu.assertEquals(vec[1], 0)
        lu.assertTrue(vec[2], 1)
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
    
TestIsVectorWorks = {}
    function TestIsVectorWorks:testNormalVectorWorks()
        -- given
        local x = 1
        local y = 2
        -- when
        local vec = Vector.new(x, y)
        -- then
        lu.assertTrue(Vector.is_vector(vec))
    end
    
    function TestIsVectorWorks:testTooLongWorks()
        -- given
        local x = 1
        local y = 2
        local random = 3
        -- when
        local vec = Vector.new(x, y,random)
        -- then
        lu.assertTrue(Vector.is_vector(vec))
        lu.assertTrue(Vector.is_vector({x,y,random}))
    end
    
    function TestIsVectorWorks:testTooShortFails()
        lu.assertFalse(Vector.is_vector({1}))
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
 
TestUnitVector = {}
    function TestUnitVector:testBasic()
        -- given
        local x = 1
        local y = 1
        
        local vec = Vector.new(x,y)
        
        local mag = vec:magnitude()
        lu.assertEquals(vec:magnitude(), math.sqrt(2))
        -- when
        vec = vec:make_unit_vector()
        -- then
        lu.assertAlmostEquals(vec:magnitude(), 1, epsilon)
    end
    
    function TestUnitVector:testWorksOnAnyVectorBig()
        -- given
        local x = 13
        local y = 22
        
        local vec = Vector.new(x,y)
        -- when
        vec = vec:make_unit_vector()
        -- then
        lu.assertEquals(vec:magnitude(), 1, epsilon)
    end
    
    function TestUnitVector:testWorksOnAnyVectorSmall()
        -- given
        local x = 0.003
        local y = 0.05
        
        local vec = Vector.new(x,y)
        -- when
        vec = vec:make_unit_vector()
        -- then
        lu.assertEquals(vec:magnitude(), 1, epsilon)
    end
    
lu.LuaUnit.run()