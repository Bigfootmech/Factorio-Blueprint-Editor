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
local Bounding_Box = require('lib.logic.model.spatial.Bounding_Box')

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
    return self:get_number_of_entities() == 0
end

function Blueprint:has_tiles()
    return self:get_number_of_tiles() == 0
end

function Blueprint:get_entity(num)
    return self.blueprint_entities[num]
end

function Blueprint.new(blueprint_entities, blueprint_tiles, label, blueprint_icons)
    
    local constructed_entity = {blueprint_entities = blueprint_entities, blueprint_tiles = blueprint_tiles, label = label, blueprint_icons = blueprint_icons}
    
    return Object.instantiate(constructed_entity, Blueprint)
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
    assert(is_lua_blueprint(lua_blueprint), "Cannot use 'from lua blueprint' method on non-lua blueprint " .. tostring(lua_blueprint))
    
    lua_blueprint.set_blueprint_entities(self.blueprint_entities)
    lua_blueprint.set_blueprint_tiles(self.blueprint_tiles)
    lua_blueprint.label = self.label or "" -- sends nil, but doesn't accept nil
    lua_blueprint.blueprint_icons = self.blueprint_icons
end

function Blueprint:add_entity(blueprint_entity)
    blueprint_entity = Blueprint_Entity.from_table(blueprint_entity)
    
    local result = self.blueprint_entities:add_entity(blueprint_entity)
    return {self, result[2]}
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

function Blueprint:get_bounding_box()
    local bounding_box
    
    if(self:has_entities())then
        if(bounding_box == nil)then
            bounding_box = Bounding_Box.from_position(self.blueprint_entities[1]:get_position())
        end
        for index, entity in pairs(self.blueprint_entities)do
            bounding_box:include_position(entity:get_position())
        end
    end
    
    if(self:has_tiles())then
        if(bounding_box == nil)then
            bounding_box = Bounding_Box.from_position(self.blueprint_tiles[1].position)
        end
        for index, tile in pairs(self.blueprint_tiles)do
            bounding_box:include_position(tile.position) -- needs to be replaced when I implement "tile" class (remove position import as well)
        end
    end
    return bounding_box
end

return Blueprint