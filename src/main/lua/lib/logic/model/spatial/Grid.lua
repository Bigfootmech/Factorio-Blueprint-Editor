local Object = require('lib.core.types.Object')
local Math = require('lib.core.Math')

local GRID_SIZE = 1
local PERFECTLY_OFF_GRID = GRID_SIZE / 2

local Self = Object.util_class("Grid")

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

return Self