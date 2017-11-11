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
local Math = require('lib.core.Math')
local Position = require('lib.logic.model.spatial.Position')
local Vector = require('lib.logic.model.spatial.Vector')

local Bounding_Box = Object.new_class()
Bounding_Box.type = "Bounding_Box"

function Bounding_Box:get_left_top_explicit()
    assert(type(self) == "table", "Can not get-left_top of a non-table.")
    return self.left_top
end
function Bounding_Box:get_right_bottom_explicit()
    assert(type(self) == "table", "Can not get-bottom_right of a non-table.")
    return self.right_bottom
end
function Bounding_Box:get_left_top_shorthand()
    assert(type(self) == "table", "Can not get-left_top of a non-table.")
    return self[1]
end
function Bounding_Box:get_right_bottom_shorthand()
    assert(type(self) == "table", "Can not get-bottom_right of a non-table.")
    return self[2]
end

function Bounding_Box:is_explicit_bounding_box()
    if(type(self) ~= "table")then
        return false
    end
    if(not Position.is_position(Bounding_Box.get_left_top_explicit(self)))then
        return false
    end
    if(not Position.is_position(Bounding_Box.get_right_bottom_explicit(self)))then
        return false
    end
    return true
end

function Bounding_Box:is_shorthand_bounding_box()
    if(type(self) ~= "table")then
        return false
    end
    if(not Position.is_position(Bounding_Box.get_left_top_shorthand(self)))then
        return false
    end
    if(not Position.is_position(Bounding_Box.get_right_bottom_shorthand(self)))then
        return false
    end
    return true
end

function Bounding_Box:is_bounding_box()
    if(type(self) ~= "table")then
        return false
    end
    if(Bounding_Box.type == "Bounding_Box")then
        return true
    end
    if(Bounding_Box.is_explicit_bounding_box(self))then
        return true
    end
    if(Bounding_Box.is_shorthand_bounding_box(self))then
        return true
    end
    return false
end

function Bounding_Box:get_left_top()
    assert(Bounding_Box.is_bounding_box(self), "Can not use this method on non-bounding_box.")
    if(Bounding_Box.is_explicit_bounding_box(self))then
        return Bounding_Box.get_left_top_explicit(self)
    end
    if(Bounding_Box.is_shorthand_bounding_box(self))then
        return Bounding_Box.get_left_top_shorthand(self)
    end
    -- error
end
function Bounding_Box:get_right_bottom()
    assert(Bounding_Box.is_bounding_box(self), "Can not use this method on non-bounding_box.")
    if(Bounding_Box.is_explicit_bounding_box(self))then
        return Bounding_Box.get_right_bottom_explicit(self)
    end
    if(Bounding_Box.is_shorthand_bounding_box(self))then
        return Bounding_Box.get_right_bottom_shorthand(self)
    end
    -- error
end

function Bounding_Box:get_right()
    return self:get_right_bottom():get_x()
end

function Bounding_Box:get_bottom()
    return self:get_right_bottom():get_y()
end

function Bounding_Box:get_left()
    return self:get_left_top():get_x()
end

function Bounding_Box:get_top()
    return self:get_left_top():get_y()
end

function Bounding_Box:get_right_top()
    return Position.new(self:get_right(), self:get_top())
end

function Bounding_Box:get_left_bottom()
    return Position.new(self:get_left(), self:get_bottom())
end

function Bounding_Box:get_x_centre()
    return (self:get_left_top():get_x() + self:get_right_bottom():get_x())/2
end

function Bounding_Box:get_y_centre()
    return (self:get_left_top():get_y() + self:get_right_bottom():get_y())/2
end

function Bounding_Box:get_centre_top()
    return Position.new(self:get_x_centre(), self:get_top())
end

function Bounding_Box:get_centre_bottom()
    return Position.new(self:get_x_centre(), self:get_bottom())
end

function Bounding_Box:get_right_centre()
    return Position.new(self:get_right(), self:get_y_centre())
end

function Bounding_Box:get_left_centre()
    return Position.new(self:get_left(), self:get_y_centre())
end

function Bounding_Box:get_centre_centre()
    return Position.new(self:get_x_centre(), self:get_y_centre())
end

function Bounding_Box:get_point(point_name)
    local method_name = "get_" .. point_name
    return Bounding_Box[method_name](self)
end

function Bounding_Box:get_width()
    return self:get_right() - self:get_left()
end

function Bounding_Box:get_height()
    return self:get_bottom() - self:get_top()
end

function Bounding_Box.new(left_top, right_bottom)
    assert(Position.is_position(left_top), "left_top was not a valid position.")
    assert(Position.is_position(right_bottom), "right_bottom was not a valid position.")
    
    local newObject = {left_top = left_top, right_bottom = right_bottom}
    
    return Object.instantiate(newObject, Bounding_Box)
end

function Bounding_Box.from_table(bounding_box)
    assert(Bounding_Box.is_bounding_box(bounding_box), "Can't convert " .. tostring(bounding_box) .. " to Bounding Box.")
    
    local left_top = Position.from_table(Bounding_Box.get_left_top(bounding_box))
    local right_bottom = Position.from_table(Bounding_Box.get_right_bottom(bounding_box))
    
    return Bounding_Box.new(left_top, right_bottom)
end

function Bounding_Box.from_position(position)
    return Bounding_Box.new(position, position)
end

function Bounding_Box:copy()
    assert(self:is_bounding_box(), "Tried to Bounding_Box.copy a non-Bounding_Box object")
    return Bounding_Box.new(self.get_left_top():copy(), self.get_right_bottom():copy())
end

local function get_least(one, two)
    if(one < two)then
        return one
    end
    return two
end

local function get_most(one, two)
    if(one > two)then
        return one
    end
    return two
end

function Bounding_Box:contains(position)
    if(position:get_x() < self:get_left())then
        return false
    end
    if(position:get_x() > self:get_right())then
        return false
    end
    if(position:get_y() < self:get_top())then
        return false
    end
    if(position:get_y() > self:get_bottom())then
        return false
    end
    return true
end

function Bounding_Box:include_position(position)
    if(self:contains(position))then
        return self
    end
    
    local new_x = position:get_x()
    local new_y = position:get_y()
    
    local left_x = get_least(self:get_left(), new_x)
    local top_y = get_least(self:get_top(), new_y)
    
    local right_x = get_most(self:get_right(), new_x)
    local bottom_y = get_most(self:get_bottom(), new_y)
    
    self.left_top = Position.new(left_x, top_y)
    self.right_bottom = Position.new(right_x, bottom_y)
    
    return self
end

return Bounding_Box