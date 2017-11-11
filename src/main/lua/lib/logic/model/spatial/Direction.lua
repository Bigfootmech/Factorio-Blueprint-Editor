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

local DEFAULT_DIRECTION = 0

function Direction.default()
    return DEFAULT_DIRECTION
end

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

    dir = dir or DEFAULT_DIRECTION
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
    return Direction.rotate_x_times_clockwise_from_dir(nil, times, eight_axis)
end

function Direction.mirror_in_axis(dir, mirror_dir) -- should hold for any number of evenly distributed directions
    assert(Direction.is_direction(mirror_dir), "invalid mirror direction")
    
    dir = dir or DEFAULT_DIRECTION
    assert(Direction.is_direction(dir), "invalid direction")
    
    local factor_from_mirror_line = (mirror_dir*2) % get_number_of_directions()
    local mirrored_direction = (factor_from_mirror_line - dir) % get_number_of_directions()
    
    return mirrored_direction
end

function Direction.mirror_in_y_axis(dir)
    return Direction.mirror_in_axis(dir,0)
end

function Direction.mirror_in_x_axis(dir)
    return Direction.mirror_in_axis(dir,get_number_of_directions() / 4)
end

return Direction