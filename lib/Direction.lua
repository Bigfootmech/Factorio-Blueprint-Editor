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



require 'lib/Array'

Direction = {}
Direction.__index = Direction

local direction_set = {"defines.direction.north",
                        "defines.direction.northeast",
                        "defines.direction.east",
                        "defines.direction.southeast",
                        "defines.direction.south",
                        "defines.direction.southwest",
                        "defines.direction.west",
                        "defines.direction.northwest"}

local direction_degree_separation = 45

function Direction:is_direction(dir)
    return Array:contains(direction_set, dir)
end

function Direction:rotate_clockwise_dir_degrees(dir, degrees)
    assert(type(degrees) == "number", "degrees supplied were not a number")
    assert(Direction:is_direction(dir), "invalid direction")
    
    local dir_pos = Array:get_index(direction_set, dir)
    local pos_change = degrees / direction_degree_separation
    
    local pos_flat = dir_pos + pos_change
    local pos_return = pos_flat % #direction_set
    
    if pos_return == 0 then return direction_set[#direction_set] end
    
    return direction_set[pos_return]
end

function Direction:rotate_anticlockwise_dir_degrees(dir, degrees)
    return Direction:rotate_clockwise_dir_degrees(dir, -degrees)
end

function Direction:rotate_degrees_from_default(degrees)
    return Direction:rotate_clockwise_dir_degrees(direction_set[1], degrees) -- assuming "north" is default until proven otherwise
end

print("array length")
print(#direction_set)

print("directions")
print(Direction:rotate_degrees_from_default(0)) -- should be "north"
print(Direction:rotate_degrees_from_default(45)) -- should be "northeast"
print(Direction:rotate_degrees_from_default(90)) -- should be "east"
print(Direction:rotate_degrees_from_default(135)) -- should be "southeast"
print(Direction:rotate_degrees_from_default(180)) -- should be "south"
print(Direction:rotate_degrees_from_default(225)) -- should be "southwest"
print(Direction:rotate_degrees_from_default(270)) -- should be "west"
print(Direction:rotate_degrees_from_default(315)) -- should be "northwest"
print(Direction:rotate_degrees_from_default(360)) -- should be "north"
print(Direction:rotate_degrees_from_default(-45)) -- should be "northwest"
print(Direction:rotate_degrees_from_default(-90)) -- should be "west"
print(Direction:rotate_degrees_from_default(-135)) -- should be "southwest"
print(Direction:rotate_degrees_from_default(-180)) -- should be "south"
print(Direction:rotate_degrees_from_default(-225)) -- should be "southeast"
print(Direction:rotate_degrees_from_default(-270)) -- should be "east"
print(Direction:rotate_degrees_from_default(-315)) -- should be "northeast"
print(Direction:rotate_degrees_from_default(-360)) -- should be "north"

print("different starts")
print(Direction:rotate_clockwise_dir_degrees("defines.direction.east", 90)) -- should be "south"
print(Direction:rotate_clockwise_dir_degrees("defines.direction.southwest", 135)) -- should be "north"
print(Direction:rotate_clockwise_dir_degrees("defines.direction.west", 90)) -- should be "north"
print(Direction:rotate_anticlockwise_dir_degrees("defines.direction.southwest", 90)) -- should be "southeast"

print("fractions")
print(Direction:rotate_clockwise_dir_degrees("defines.direction.north", 1)) -- should be "north"
print(Direction:rotate_clockwise_dir_degrees("defines.direction.north", 22.4)) -- should be "north"
print(Direction:rotate_clockwise_dir_degrees("defines.direction.north", 22.5)) -- should be "northeast"
print(Direction:rotate_clockwise_dir_degrees("defines.direction.north", 367)) -- should be "north"