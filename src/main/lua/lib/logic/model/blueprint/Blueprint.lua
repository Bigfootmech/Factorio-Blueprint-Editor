--[[
http://lua-api.factorio.com/latest/LuaItemStack.html#LuaItemStack.get_blueprint_entities
Blueprint

valid :: boolean [R]	Is this object valid?
is_blueprint_setup() → boolean   Is this blueprint item setup? I.e. is it a non-empty blueprint?
blueprint_icons :: array of Icon [RW]	Icons of a blueprint item.
default_icons :: array of Icon [R]	The default icons for a blueprint item.
set_blueprint_entities(entities)
get_blueprint_entities() → array of blueprint entity
get_blueprint_tiles() → array of blueprint tile
set_blueprint_tiles(tiles)

build_blueprint{surface=…, force=…, position=…, force_build=…, direction=…} → array of LuaEntity	Build this blueprint
create_blueprint{surface=…, force=…, area=…, always_include_tiles=…}	Sets up this blueprint using the found blueprintable entities/tiles on the surface.
clear_blueprint()	Clears this blueprint item.

label :: string [RW]	The current label for this item. -- blueprint name!!
label_color :: Color [RW]	The current label color for this item. - nil
allow_manual_label_change :: boolean [RW]	If the label for this item can be manually changed. - true

prototype :: LuaItemPrototype [R]	Prototype of the item held in this stack.
name :: string [R]	Prototype name of the item held in this stack. = blueprint
type :: string [R]	Type of the item prototype. = blueprint
count :: uint [RW]	Number of items in this stack. = 1

cost_to_build :: dictionary string → uint [R]	Raw materials required to build this blueprint. - "unknown key" Rip
]]
local Object = require('lib.core.types.Object')
local Blueprint_Entity = require('lib.logic.model.blueprint.Blueprint_Entity')
local Blueprint_All_Entities_List = require('lib.logic.model.blueprint.Blueprint_All_Entities_List')
local Position = require('lib.logic.model.spatial.Position')
local Vector = require('lib.logic.model.spatial.Vector')
local Bounding_Box_Factory = require('lib.logic.model.spatial.box.Bounding_Box_Factory')
local Grid_Box = require('lib.logic.model.spatial.box.Grid_Box')

local Blueprint = Object.new_class()

local function is_lua_blueprint(blueprint)
    if(not Object.is_lua_object(blueprint)) then
        return false
    end
    if(not blueprint.type == "blueprint")then
        return false
    end
    return true
end

function Blueprint:get_number_of_entities()
    if(self.blueprint_entities == nil)then
        return 0
    end
    return #self.blueprint_entities
end

function Blueprint:get_number_of_tiles()
    if(self.blueprint_tiles == nil)then
        return 0
    end
    return #self.blueprint_tiles
end

function Blueprint:has_entities()
    return self:get_number_of_entities() ~= 0
end

function Blueprint:has_tiles()
    return self:get_number_of_tiles() ~= 0
end

function Blueprint:get_entity(num)
    return self.blueprint_entities[num]
end

function Blueprint.new(blueprint_entities, blueprint_tiles, label, blueprint_icons)
    
    local constructed_entity = {blueprint_entities = blueprint_entities, blueprint_tiles = blueprint_tiles, label = label, blueprint_icons = blueprint_icons}
    
    return Object.instantiate(constructed_entity, Blueprint)
end

function Blueprint.from_table(table)

    local blueprint_entities = Blueprint_All_Entities_List.from_table(table.blueprint_entities)
    local blueprint_tiles = table.blueprint_tiles
    local label = table.label
    local blueprint_icons = table.blueprint_icons
    
    return Blueprint.new(blueprint_entities, blueprint_tiles, label, blueprint_icons)
end

function Blueprint.empty()
    return Blueprint.from_table({blueprint_entities={}, blueprint_tiles={}, label="", blueprint_icons={}})
end

function Blueprint.from_lua_blueprint(lua_blueprint)
    assert(is_lua_blueprint(lua_blueprint), "Cannot use 'from lua blueprint' method on non-lua blueprint " .. tostring(lua_blueprint))
    
    local blueprint_entities = Blueprint_All_Entities_List.from_table(lua_blueprint.get_blueprint_entities())
    local blueprint_tiles = lua_blueprint.get_blueprint_tiles()
    local label = lua_blueprint.label
    local blueprint_icons = lua_blueprint.blueprint_icons
    
    return Blueprint.new(blueprint_entities, blueprint_tiles, label, blueprint_icons)
end

function Blueprint:dump_to_lua_blueprint(lua_blueprint)
    -- assert self is Blueprint
    assert(is_lua_blueprint(lua_blueprint), "Cannot use 'dump to lua blueprint' method on non-lua blueprint " .. tostring(lua_blueprint))
    
    lua_blueprint.set_blueprint_entities(self.blueprint_entities)
    lua_blueprint.set_blueprint_tiles(self.blueprint_tiles)
    lua_blueprint.label = self.label or "" -- sends nil, but doesn't accept nil
    lua_blueprint.blueprint_icons = self.blueprint_icons
end

function Blueprint:add_entity(blueprint_entity)
    if(type(blueprint_entity) == "string")then
        blueprint_entity = Blueprint_Entity.new_minimal(blueprint_entity)
    else
        blueprint_entity = Blueprint_Entity.from_table(blueprint_entity)
    end
    
    local result = self.blueprint_entities:add_entity(blueprint_entity)
    return {self, result[2]}
end

function Blueprint:remove_entity(blueprint_entity_num)
    return self.blueprint_entities:remove_entity(blueprint_entity_num)
end

function Blueprint:remove_entities(blueprint_entity_nums)
    return self.blueprint_entities:remove_entities(blueprint_entity_nums)
end

function Blueprint:move_entitity_by_vector(entity_number, vector)
    self.blueprint_entities:move_entitity_by_vector(entity_number, vector)
    return self
end

function Blueprint:move_entities_by_vector(entity_number_array, vector)
    self.blueprint_entities:move_entities_by_vector(entity_number_array, vector)
    return self
end

function Blueprint:move_all_entities_and_tiles_by_vector(vector)
    assert(Vector.is_vector(vector), "Tried to move entities, by non-vector " .. Object.to_string(vector))
    if(self:has_entities())then
        for index, entity in pairs(self.blueprint_entities)do
            entity:move_with_vector(vector)
        end
    end
    if(self:has_tiles())then
        for index, tile in pairs(self.blueprint_tiles)do
            tile.position = Position.add(tile.position, vector) -- needs to be replaced when I implement "tile" class (remove position import as well)
        end
    end
    return self
end

function Blueprint:rotate_entities_by_amount(entity_number_array, amount)
    self.blueprint_entities:rotate_entities_by_amount(entity_number_array, amount)
    return self
end

function Blueprint:mirror_entities_through_direction(entity_number_array, direction_mirror_line)
    self.blueprint_entities:mirror_entities_through_direction(entity_number_array, direction_mirror_line)
    return self
end

function Blueprint:get_bounding_box()
    local bounding_box_factory = Bounding_Box_Factory.new()
    
    if(self:has_entities())then
        for index, entity in pairs(self.blueprint_entities)do
            bounding_box_factory:with_position(entity:get_on_grid_position())
        end
    end
    
    if(self:has_tiles())then
        for index, tile in pairs(self.blueprint_tiles)do
            bounding_box_factory:with_position(tile.position) -- need to check this works. Both uninstantiated position, and location
        end
    end
    
    local status, err_or_bounding_box = pcall(bounding_box_factory.build, bounding_box_factory)
    
    if(not status)then
        error("Can't create bounding box with no entities, or tiles")
    end
    
    return Grid_Box.from_bounding_box_inner(err_or_bounding_box)
end

return Blueprint