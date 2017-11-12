local lu = require('luaunit')
local Matrix = require('lib.logic.model.spatial.Matrix')
local Vector = require('lib.logic.model.spatial.Vector')
    
TestIsMatrixWorks = {}
    function TestIsMatrixWorks:testWorksOnPlainTables()
        -- given
        local plain_table = {{1,2},{3,4}}
        
        -- when
        local result = Matrix.is_matrix(plain_table)
        
        -- then
        lu.assertTrue(result)
    end

TestCreateMatrix = {}
    function TestCreateMatrix:testCreated()
        -- given
        local a = 0
        local b = 1
        local c = 2
        local d = 3
        local vec_a = Vector.new(a,b)
        local vec_b = Vector.new(c,d)
        
        -- when
        local mat = Matrix.new(vec_a, vec_b)
        
        -- then
        lu.assertNotNil(mat)
        lu.assertTrue(Matrix.is_matrix(mat))
    end
    function TestCreateMatrix:testCreatedFromTable()
        -- given
        local a = 0
        local b = 1
        local c = 2
        local d = 3
        local some_table = {{a,b},{c,d}}
        
        -- when
        local mat = Matrix.from_table(some_table)
        
        -- then
        lu.assertNotNil(mat)
        lu.assertTrue(Matrix.is_matrix(mat))
    end

TestCreateSpecialMatrices = {}
    function TestCreateSpecialMatrices:testMatricesCreate()
        -- given
        
        -- when
        local rotate_clockwise = Matrix.rotate_clockwise()
        local rotate_anticlockwise = Matrix.rotate_anticlockwise()
        local mirror_in_x_axis = Matrix.mirror_in_x_axis()
        local mirror_in_y_axis = Matrix.mirror_in_y_axis()
        
        -- then
        lu.assertTrue(Matrix.is_matrix(rotate_clockwise))
        lu.assertTrue(Matrix.is_matrix(rotate_anticlockwise))
        lu.assertTrue(Matrix.is_matrix(mirror_in_x_axis))
        lu.assertTrue(Matrix.is_matrix(mirror_in_y_axis))
    end

TestMultiplication = {}
    
    function TestMultiplication:testMultiplicationWorksSign()
        -- given
        local mat = Matrix.from_table({{1,2},{3,4}})
        local vec = Vector.new(2,3)
        
        -- when
        local result = mat * vec
        
        -- then
        lu.assertNotNil(result)
        lu.assertTrue(Vector.is_vector(result))
    end

TestRotation = {}
    
    function TestRotation:testRotatingZeroTimesWorks()
        -- given
        local x = 1
        local y = 2
        local vec = Vector.new(x,y)
        
        local times = 0
        
        -- when
        local result = Matrix.rotate_vector_clockwise_x_times(vec, times)
        
        -- then
        lu.assertNotNil(result)
        lu.assertTrue(Vector.is_vector(result))
        lu.assertEquals(result[1], x)
        lu.assertEquals(result[2], y)
    end
    
    function TestRotation:testRotatingOnceWorks()
        -- given
        local x = 1
        local y = 0
        
        local vec = Vector.new(x,y)
        
        local times = 1
        
        local expected_x = -y
        local expected_y = x
        
        -- when
        local result = Matrix.rotate_vector_clockwise_x_times(vec, times)
        
        -- then
        lu.assertNotNil(result)
        lu.assertTrue(Vector.is_vector(result))
        lu.assertEquals(result[1], expected_x)
        lu.assertEquals(result[2], expected_y)
    end
    
    function TestRotation:testRotatingReverseOnceWorks()
        -- given
        local x = 1
        local y = 0
        
        local vec = Vector.new(x,y)
        
        local times = -1
        
        local expected_x = y
        local expected_y = -x
        
        -- when
        local result = Matrix.rotate_vector_clockwise_x_times(vec, times)
        
        -- then
        lu.assertNotNil(result)
        lu.assertTrue(Vector.is_vector(result))
        lu.assertEquals(result[1], expected_x)
        lu.assertEquals(result[2], expected_y)
    end

TestMirror = {}
    
    function TestMirror:testMirroringXAxisWorks()
        -- given
        local x = 1
        local y = 1
        local vec = Vector.new(x,y)
        
        -- when
        local result = Matrix.mirror_vector_in_x_axis(vec)
        
        -- then
        lu.assertNotNil(result)
        lu.assertTrue(Vector.is_vector(result))
        lu.assertEquals(result[1], x)
        lu.assertEquals(result[2], -y)
    end
    
    function TestMirror:testMirroringYAxisWorks()
        -- given
        local x = 23
        local y = 57
        local vec = Vector.new(x,y)
        
        -- when
        local result = Matrix.mirror_vector_in_y_axis(vec)
        
        -- then
        lu.assertNotNil(result)
        lu.assertTrue(Vector.is_vector(result))
        lu.assertEquals(result[1], -x)
        lu.assertEquals(result[2], y)
    end

return lu.LuaUnit.run()