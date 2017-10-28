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
local Map = require('lib.core.types.Map')

local Direction = {}

local function get_number_of_directions()
    return Map.size(defines.direction)
end

function Direction.is_direction(dir)
    return Map.has_value(defines.direction, dir)
end

local function is_not_eight_axis(eight_axis_boolean)
    if(eight_axis_boolean == nil)then
        return true
    end
    assert(type(eight_axis_boolean) == "boolean", "eight_axis_boolean needs to be a boolean value")
    return not eight_axis_boolean
end

function Direction.rotate_x_times_clockwise_from_dir(dir, times, eight_axis)
    assert(type(times) == "number", "times supplied was not a number")
    assert(Direction.is_direction(dir), "invalid direction")
    
    local dir_pos = dir
    local pos_change = times
    if(is_not_eight_axis(eight_axis))then
        pos_change = pos_change * 2 -- magic number
    end
    local number_of_directions = get_number_of_directions()
    
    local pos_flat = dir_pos + pos_change
    local pos_return = pos_flat % number_of_directions
    
    return pos_return
end

function Direction.rotate_x_times_anticlockwise_from_dir(dir, times, eight_axis)
    return Direction.rotate_x_times_clockwise_from_dir(dir, -times, eight_axis)
end

function Direction.rotate_x_times_from_default(times, eight_axis)
    return Direction.rotate_x_times_clockwise_from_dir(0, times, eight_axis) -- magic number
end

return Direction