local Object = require('lib.core.types.Object')
local Vector = require('lib.logic.model.spatial.Vector')

local Matrix = Object.new_class()
local function_metatable = {}

-- epsilon?

function Matrix.is_matrix(obj)
    if(type(obj) ~= "table")then
        --log.debug("Object " .. tostring(obj) .. " was not a table, and therefore not a vector."
        return false
    end
    if(not Vector.is_vector(obj[1]))then 
        --log.debug("Object field 1 " .. tostring(obj[1]) .. " was not a number, and therefore not a vector."
        return false
    end
    if(not Vector.is_vector(obj[2]))then 
        --log.debug("Object field 1 " .. tostring(obj[2]) .. " was not a number, and therefore not a vector."
        return false
    end
    return true
end

function Matrix.new(row_1, row_2)
    assert(Vector.is_vector(row_1), "row_1 is not a vector")
    assert(Vector.is_vector(row_2), "row_2 is not a vector")
    local newObject = {row_1, row_2}
    
    return Object.instantiate(newObject, Matrix, function_metatable)
end

function Matrix.from_table(some_table)
    assert(type(some_table) == "table", "cannot instantiate vector from non-table")
    assert(#some_table == 2, "2D matrix must be size 2")
    some_table[1] = Vector.from_table(some_table[1])
    some_table[2] = Vector.from_table(some_table[2])
    
    return Object.instantiate(some_table, Matrix, function_metatable)
end

function Matrix.rotate_clockwise()
    return Matrix.from_table({{0, -1},{1, 0}})
end
function Matrix.rotate_anticlockwise()
    return Matrix.from_table({{0, 1},{-1, 0}})
end
function Matrix.mirror_in_x_axis()
    return Matrix.from_table({{1, 0},{0, -1}})
end
function Matrix.mirror_in_y_axis()
    return Matrix.from_table({{-1, 0},{0, 1}})
end

function Matrix:vector_product(vector)
    assert(Matrix.is_matrix(self), "Can only use this method on a matrices")
    assert(Vector.is_vector(vector), "Can only use this method to multiply matrices by vectors")
    local new_x = self[1]:get_x() * vector:get_x() + self[1]:get_y() * vector:get_y()
    local new_y = self[2]:get_x() * vector:get_x() + self[2]:get_y() * vector:get_y()
    return Vector.new(new_x, new_y)
end

local function is_negative(num)
    return num < 0
end

function Matrix.rotate_vector_clockwise_x_times(vector, times)
    if(is_negative(times))then
        return Matrix.rotate_vector_anticlockwise_x_times(vector, times)
    end
    for i=1,times do
        vector = Matrix.rotate_clockwise() * vector
    end
    
    return vector
end

function Matrix.rotate_vector_anticlockwise_x_times(vector, times)
    for i=1,times do
        vector = Matrix.rotate_anticlockwise() * vector
    end
    
    return vector
end

function Matrix.mirror_vector_in_x_axis(vector)
    return Matrix.mirror_in_x_axis() * vector
end

function Matrix.mirror_vector_in_y_axis(vector)
    return Matrix.mirror_in_y_axis() * vector
end

function_metatable.__mul = function( ... )
    return Matrix.vector_product( ... )
end
-- tostring?
-- equals?
-- hashcode???

return Matrix