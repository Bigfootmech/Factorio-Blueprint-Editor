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
local Position = require('lib.logic.model.spatial.Position')

local classname = "Bounding_Box"
local Self = Object.new_class(classname)

function Self:get_left_top_explicit()
    assert(type(self) == "table", "Can not get-left_top of a non-table.")
    return self.left_top
end
function Self:get_right_bottom_explicit()
    assert(type(self) == "table", "Can not get-bottom_right of a non-table.")
    return self.right_bottom
end
function Self:get_left_top_shorthand()
    assert(type(self) == "table", "Can not get-left_top of a non-table.")
    return self[1]
end
function Self:get_right_bottom_shorthand()
    assert(type(self) == "table", "Can not get-bottom_right of a non-table.")
    return self[2]
end

function Self:is_explicit_bounding_box()
    if(type(self) ~= "table")then
        return false
    end
    if(not Position.is_position(Self.get_left_top_explicit(self)))then
        return false
    end
    if(not Position.is_position(Self.get_right_bottom_explicit(self)))then
        return false
    end
    return true
end

function Self:is_shorthand_bounding_box()
    if(type(self) ~= "table")then
        return false
    end
    if(not Position.is_position(Self.get_left_top_shorthand(self)))then
        return false
    end
    if(not Position.is_position(Self.get_right_bottom_shorthand(self)))then
        return false
    end
    return true
end

function Self:is_bounding_box()
    if(Object.is_type(self, classname))then
        return true
    end
    if(Self.is_explicit_bounding_box(self))then
        return true
    end
    if(Self.is_shorthand_bounding_box(self))then
        return true
    end
    return false
end

function Self:get_left_top()
    assert(Self.is_bounding_box(self), "Can not use this method on non-bounding_box.")
    if(Self.is_explicit_bounding_box(self))then
        return Self.get_left_top_explicit(self)
    end
    if(Self.is_shorthand_bounding_box(self))then
        return Self.get_left_top_shorthand(self)
    end
    -- error
end
function Self:get_right_bottom()
    assert(Self.is_bounding_box(self), "Can not use this method on non-bounding_box.")
    if(Self.is_explicit_bounding_box(self))then
        return Self.get_right_bottom_explicit(self)
    end
    if(Self.is_shorthand_bounding_box(self))then
        return Self.get_right_bottom_shorthand(self)
    end
    -- error
end

function Self:get_right()
    return self:get_right_bottom():get_x()
end

function Self:get_bottom()
    return self:get_right_bottom():get_y()
end

function Self:get_left()
    return self:get_left_top():get_x()
end

function Self:get_top()
    return self:get_left_top():get_y()
end

function Self:get_right_top()
    return Position.new(self:get_right(), self:get_top())
end

function Self:get_left_bottom()
    return Position.new(self:get_left(), self:get_bottom())
end

function Self:get_x_centre()
    return (self:get_left_top():get_x() + self:get_right_bottom():get_x())/2
end

function Self:get_y_centre()
    return (self:get_left_top():get_y() + self:get_right_bottom():get_y())/2
end

function Self:get_centre_top()
    return Position.new(self:get_x_centre(), self:get_top())
end

function Self:get_centre_bottom()
    return Position.new(self:get_x_centre(), self:get_bottom())
end

function Self:get_right_centre()
    return Position.new(self:get_right(), self:get_y_centre())
end

function Self:get_left_centre()
    return Position.new(self:get_left(), self:get_y_centre())
end

function Self:get_centre_centre()
    return Position.new(self:get_x_centre(), self:get_y_centre())
end

function Self:get_point(point_name)
    local method_name = "get_" .. point_name
    return Self[method_name](self)
end

function Self:get_width()
    return self:get_right() - self:get_left()
end

function Self:get_height()
    return self:get_bottom() - self:get_top()
end

function Self.new(left_top, right_bottom)
    assert(Position.is_position(left_top), "left_top was not a valid position.")
    assert(Position.is_position(right_bottom), "right_bottom was not a valid position.")
    
    assert(left_top:get_x() <= right_bottom:get_x(), "positions would make an inverted box")
    assert(left_top:get_y() <= right_bottom:get_y(), "positions would make an inverted box")
    
    local newObject = {left_top = left_top, right_bottom = right_bottom}
    
    return Object.instantiate(newObject, Self)
end

function Self.from_table(bounding_box)
    assert(Self.is_bounding_box(bounding_box), "Can't convert " .. tostring(bounding_box) .. " to Bounding Box.")
    
    local left_top = Position.from_table(Self.get_left_top(bounding_box))
    local right_bottom = Position.from_table(Self.get_right_bottom(bounding_box))
    
    return Self.new(left_top, right_bottom)
end

function Self.from_position(position)
    return Self.new(position, position)
end

function Self:copy()
    assert(self:is_bounding_box(), "Tried to Bounding_Box.copy a non-Bounding_Box object")
    return Self.new(self.get_left_top():copy(), self.get_right_bottom():copy())
end

function Self:is_position_outside_left_top(position)
    local left_top = self:get_left_top()
    
    if(position:get_x() < left_top:get_x())then
        return true
    end
    if(position:get_y() < left_top:get_y())then
        return true
    end
    return false
end

function Self:is_position_outside_right_bottom(position)
    local right_bottom = self:get_right_bottom()
    
    if(position:get_x() > right_bottom:get_x())then
        return true
    end
    if(position:get_y() > right_bottom:get_y())then
        return true
    end
    return false
end

function Self:contains(position)
    if(self:is_position_outside_left_top(position))then
        return false
    end
    if(self:is_position_outside_right_bottom(position))then
        return false
    end
    return true
end

return Self