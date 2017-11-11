--[[
http://lua-api.factorio.com/latest/Concepts.html#BoundingBox
BoundingBox

Two positions, specifying the top-left and bottom-right corner of the box, respectively. Like with Position, the names of the members may be omitted.

Members:

    left_top :: Position
    right_bottom :: Position

Example
Explicit specification:
{left_top = {-2, -3}, right_bottom = {5, 8}}
Example
Shorthand:
{{-2, -3}, {5, 8}}

]]
local Object = require('lib.core.types.Object')
local Bounding_Box = require('lib.logic.model.spatial.Bounding_Box')

local classname = "Tile_Box"
local superclass = Bounding_Box

local Self = Object.extends(superclass, classname)

function Self:is_tile_box()
    if(type(self) ~= "table")then
        return false
    end
    if(not self.parent().is_bounding_box(self))then
        return false
    end
    -- conditions about being "off grid" edge coords.
    return true
end

function Self:get_width()
    return math.ceil(self.parent().get_width(self))
end

function Self:get_tile_height()
    return math.ceil(self.parent().get_height(self))
end

function Self:is_width_even()
    return Math.is_even(self:get_width())
end

function Self:is_height_even()
    return Math.is_even(self:get_height())
end

function Self.new(left_top, right_bottom)
    assert(Position.is_position(left_top), "left_top was not a valid position.")
    assert(Position.is_position(right_bottom), "right_bottom was not a valid position.")
    -- check is perfectly on/off grid "position"?
    
    local newObject = {left_top = left_top, right_bottom = right_bottom}
    
    return Object.instantiate(newObject, Self)
end

function Self.from_bounding_box(bounding_box)
    return Self.new(bounding_box:get_left_top():move_perfectly_off_grid_floor(), bounding_box:get_right_bottom():move_perfectly_off_grid_ceil())
end

function Self.from_table(some_table)
    assert(Self.is_tile_box(some_table), "Can't convert " .. Object.to_string(some_table) .. " to " .. classname .. ".")
    
    return Self.from_bounding_box(superclass.from_table(some_table))
end

function Self.from_position(position)
    return Self.new(position, position)
end

function Self:copy()
    assert(self:is_bounding_box(), "Tried to Bounding_Box.copy a non-Bounding_Box object")
    return Self.new(self.get_left_top():copy(), self.get_right_bottom():copy())
end

return Self