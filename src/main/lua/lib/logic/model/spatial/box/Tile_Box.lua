local Object = require('lib.core.types.Object')
local Whole_Box = require('lib.logic.model.spatial.box.Whole_Box')
local Position = require('lib.logic.model.spatial.Position')

local classname = "Tile_Box"
local superclass = Whole_Box

local Self = Object.extends(superclass, classname)

function Self:is_tile_box()
    if(not superclass.is_bounding_box(self))then
        return false
    end
    
    if(not Position.is_perfectly_off_grid(superclass.get_left_top(self)))then
        return false
    end
    if(not Position.is_perfectly_off_grid(superclass.get_right_bottom(self)))then
        return false
    end
    
    return true
end

function Self.new(left_top, right_bottom)
    assert(Position.is_position(left_top), "left_top was not a valid position.")
    assert(Position.is_position(right_bottom), "right_bottom was not a valid position.")
    
    assert(left_top:is_perfectly_off_grid(), "invalid position for" .. classname)
    assert(right_bottom:is_perfectly_off_grid(), "invalid position for" .. classname)
    
    local newObject = superclass.new(left_top, right_bottom)
    
    return Object.instantiate(newObject, Self)
end

function Self.from_bounding_box_inner(bounding_box)
    return Self.new(bounding_box:get_left_top():move_perfectly_off_grid_ceil(), bounding_box:get_right_bottom():move_perfectly_off_grid_floor())
end

function Self.from_bounding_box_outer(bounding_box)
    return Self.new(bounding_box:get_left_top():move_perfectly_off_grid_floor(), bounding_box:get_right_bottom():move_perfectly_off_grid_ceil())
end

function Self.from_collision_box(bounding_box)
    return Self.from_bounding_box_outer(bounding_box)
end

return Self