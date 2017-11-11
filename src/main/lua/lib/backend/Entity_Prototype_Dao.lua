local Object = require('lib.core.types.Object')
local Grid = require('lib.logic.model.spatial.Grid')
local Bounding_Box = require('lib.logic.model.spatial.box.Bounding_Box')
local Tile_Box = require('lib.logic.model.spatial.box.Tile_Box')
local Math = require('lib.core.Math')
local Vector = require('lib.logic.model.spatial.Vector')

local EVEN_SIDE_OFFSET = - Grid.PERFECTLY_OFF_GRID

local Self = Object.util_class("Entity_Prototype_Dao")

local function get_prototype(entity_name)
    return game.entity_prototypes[entity_name]
end

local function get_collision_box_from_lua_prototype(lua_prototype)
    return Bounding_Box.from_table(lua_prototype.collision_box)
end

function Self.get_collision_box(entity_name)
    return get_collision_box_from_lua_prototype(get_prototype(entity_name))
end

function Self.get_tile_box(entity_name)
    return Tile_Box.from_collision_box(Self.get_collision_box(entity_name))
end

function Self.is_oblong(entity_name)
    local tile_box = Self.get_tile_box(entity_name)
    return tile_box:get_width() ~= tile_box:get_height()
end

local function get_offset_for_side(side_length)
    if(Math.is_even(side_length))then
        return EVEN_SIDE_OFFSET
    end
    return 0
end

function Self.default_centre_offset(entity_name)
    local tile_box = Self.get_tile_box(entity_name)
    local x_offset = get_offset_for_side(tile_box:get_width())
    local y_offset = get_offset_for_side(tile_box:get_height())
    return Vector.new(x_offset, y_offset)
end

return Self