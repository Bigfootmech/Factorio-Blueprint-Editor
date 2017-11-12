local Object = require('lib.core.types.Object')
local Grid = require('lib.logic.model.spatial.Grid')
local Bounding_Box = require('lib.logic.model.spatial.box.Bounding_Box')
local Tile_Box = require('lib.logic.model.spatial.box.Tile_Box')

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

function Self.get_default_centre_offset(entity_name)
    return Grid.get_offset_for_collision_box(Self.get_collision_box(entity_name))
end

function Self.get_tile_box(entity_name)
    local collision_box_with_offset = Self.get_collision_box(entity_name) + Self.get_default_centre_offset(entity_name)
    return Tile_Box.from_collision_box(collision_box_with_offset)
end

function Self.is_oblong(entity_name)
    local tile_box = Self.get_tile_box(entity_name) -- can also be derived from collision box, and Grid
    return tile_box:get_width() ~= tile_box:get_height()
end

return Self