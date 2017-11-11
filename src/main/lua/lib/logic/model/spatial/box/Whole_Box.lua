local Object = require('lib.core.types.Object')
local Bounding_Box = require('lib.logic.model.spatial.box.Bounding_Box')
local Grid = require('lib.logic.model.spatial.Grid')
local Math = require('lib.core.Math')

local classname = "Tile_Box"
local superclass = Bounding_Box

local Self = Object.extends(superclass, classname)

function Self:get_x_centre()
    return Grid.move_to_grid_ceil(superclass.get_x_centre(self))
end

function Self:get_y_centre()
    return Grid.move_to_grid_ceil(superclass.get_y_centre(self))
end

function Self:get_width()
    return math.ceil(superclass.get_width(self))
end

function Self:get_height()
    return math.ceil(superclass.get_height(self))
end

function Self:is_width_even()
    return Math.is_even(self:get_width())
end

function Self:is_height_even()
    return Math.is_even(self:get_height())
end

return Self