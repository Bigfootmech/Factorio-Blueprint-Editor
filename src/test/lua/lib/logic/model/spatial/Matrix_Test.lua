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

return lu.LuaUnit.run()