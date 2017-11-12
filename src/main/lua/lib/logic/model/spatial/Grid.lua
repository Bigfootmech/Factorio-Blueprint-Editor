local Object = require('lib.core.types.Object')
local Math = require('lib.core.Math')
local Vector = require('lib.logic.model.spatial.Vector')

local GRID_SIZE = 1
local PERFECTLY_OFF_GRID = GRID_SIZE / 2

local Self = Object.util_class("Grid")
Self.PERFECTLY_OFF_GRID = PERFECTLY_OFF_GRID

function Self.is_number_on_grid(num)
    return Math.is_whole(num)
end

function Self.is_number_perfectly_off_grid(num)
    return Math.is_whole(num + PERFECTLY_OFF_GRID)
end

function Self.move_to_grid_floor(num)
    return math.floor(num)
end

function Self.move_to_grid_ceil(num)
    return math.ceil(num)
end

function Self.move_perfectly_off_grid_floor(num)
    return math.floor(num + PERFECTLY_OFF_GRID) - PERFECTLY_OFF_GRID
end

function Self.move_perfectly_off_grid_ceil(num)
    return math.ceil(num - PERFECTLY_OFF_GRID) + PERFECTLY_OFF_GRID
end

local function get_offset_for_side(side_length)
    if(Math.is_even(side_length))then
        return -PERFECTLY_OFF_GRID
    end
    return 0
end

function Self.get_offset_for_collision_box(bounding_box)
    local tile_box_width = math.ceil(bounding_box:get_width())
    local tile_box_height = math.ceil(bounding_box:get_height())
    local x_offset = get_offset_for_side(tile_box_width)
    local y_offset = get_offset_for_side(tile_box_height)
    return Vector.new(x_offset, y_offset)
end

return Self