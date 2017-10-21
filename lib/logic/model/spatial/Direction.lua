--[[
http://lua-api.factorio.com/latest/defines.html#defines.direction
direction

defines.direction.north	
defines.direction.northeast	
defines.direction.east	
defines.direction.southeast	
defines.direction.south	
defines.direction.southwest	
defines.direction.west	
defines.direction.northwest
]]

local Array = require('lib.core.types.Array')

local Direction = {}

local direction_set = {"defines.direction.north",
                        "defines.direction.northeast",
                        "defines.direction.east",
                        "defines.direction.southeast",
                        "defines.direction.south",
                        "defines.direction.southwest",
                        "defines.direction.west",
                        "defines.direction.northwest"}

local direction_degree_separation = 45

local function is_direction(dir)
    return Array.contains(direction_set, dir)
end
Direction.is_direction = is_direction


local function rotate_clockwise_dir_degrees(dir, degrees)
    assert(type(degrees) == "number", "degrees supplied were not a number")
    assert(is_direction(dir), "invalid direction")
    
    local dir_pos = Array.get_index(direction_set, dir)
    local pos_change = degrees / direction_degree_separation
    
    local pos_flat = dir_pos + pos_change
    local pos_return = pos_flat % #direction_set
    
    if pos_return == 0 then return direction_set[#direction_set] end
    
    return direction_set[pos_return]
end
Direction.rotate_clockwise_dir_degrees = rotate_clockwise_dir_degrees

local function rotate_anticlockwise_dir_degrees(dir, degrees)
    return rotate_clockwise_dir_degrees(dir, -degrees)
end
Direction.rotate_anticlockwise_dir_degrees = rotate_anticlockwise_dir_degrees

local function rotate_degrees_from_default(degrees)
    return rotate_clockwise_dir_degrees(direction_set[1], degrees) -- assuming "north" is default until proven otherwise
end
Direction.rotate_degrees_from_default = rotate_degrees_from_default

return Direction